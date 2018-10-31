//
//  File.swift
//  Bicisendas
//
//  Created by Pablo Bendersky on 17/10/2018.
//  Copyright © 2018 Pablo Bendersky. All rights reserved.
//

import MapKit

public protocol RouteStep {

    var coordinates: [CLLocationCoordinate2D] { get }

}

public struct RouteStepBegin: RouteStep {

    public let coordinates: [CLLocationCoordinate2D]

    init(recorridoPasoDAO: RecorridoPasoDAO) {
        if let gmlFeature = recorridoPasoDAO.gmlFeature,
            let point = gmlFeature.point {

            let coordinate = USIGCoordinateHelper.shared().convertFromUSIG(x: point.coordinates.x, y: point.coordinates.y)

            coordinates = [ coordinate ]
        } else {
            coordinates = []
        }
    }

}

public struct RouteStepBike: RouteStep {

    public let coordinates: [CLLocationCoordinate2D]

    init(recorridoPasoDAO: RecorridoPasoDAO) {
        if let gmlFeature = recorridoPasoDAO.gmlFeature,
            let points = gmlFeature.multilineString {

            var coordinates = [CLLocationCoordinate2D]()

            points.lineStringMembers.forEach { (lineStringMember) in
                let convertedCoordinates = lineStringMember.lineString.coordinates.map {
                    USIGCoordinateHelper.shared().convertFromUSIG(x: $0.x, y: $0.y)
                }
                if let lastInCollection = coordinates.last,
                    let first = convertedCoordinates.first,
                    let last = convertedCoordinates.last {

                    let lastInCollectionPoint = MKMapPointForCoordinate(lastInCollection)
                    let firstPoint = MKMapPointForCoordinate(first)
                    let lastPoint = MKMapPointForCoordinate(last)

                    if MKMetersBetweenMapPoints(lastInCollectionPoint, firstPoint) < MKMetersBetweenMapPoints(lastInCollectionPoint, lastPoint) {

                        coordinates.append(contentsOf: convertedCoordinates)
                        
                    } else {

                        coordinates.append(contentsOf: convertedCoordinates.reversed())
                    }

                } else {
                    coordinates.append(contentsOf: convertedCoordinates)
                }
            }

            self.coordinates = coordinates
        } else {
            coordinates = []
        }
    }

}

public struct RouteStepEnd: RouteStep {

    public let coordinates: [CLLocationCoordinate2D]

    init(recorridoPasoDAO: RecorridoPasoDAO) {
        if let gmlFeature = recorridoPasoDAO.gmlFeature,
            let point = gmlFeature.point {

            let coordinate = USIGCoordinateHelper.shared().convertFromUSIG(x: point.coordinates.x, y: point.coordinates.y)

            coordinates = [ coordinate ]
        } else {
            coordinates = []
        }
    }

}
