//
//  File.swift
//  Bicisendas
//
//  Created by Pablo Bendersky on 17/10/2018.
//  Copyright © 2018 Pablo Bendersky. All rights reserved.
//

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
                lineStringMember.lineString.coordinates.forEach({ (coordinate) in
                    coordinates.append(USIGCoordinateHelper.shared().convertFromUSIG(x: coordinate.x, y: coordinate.y))
                })
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
