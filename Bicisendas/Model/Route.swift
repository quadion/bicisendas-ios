//
//  Route.swift
//  Bicisendas
//
//  Created by Pablo Bendersky on 12/10/2018.
//  Copyright © 2018 Pablo Bendersky. All rights reserved.
//

import MapKit

public class Route {

    public let time: Measurement<UnitDuration>
    public let distance: Measurement<UnitLength>
    public let fromLocation: RouteLocation
    public let toLocation: RouteLocation
    public let origin: CLLocationCoordinate2D
    public let destination: CLLocationCoordinate2D
    public let steps: [RouteStep]

    public var coordinates: [CLLocationCoordinate2D] {

        var coordinates = [CLLocationCoordinate2D]()

        steps.forEach { (step) in

            let stepCoordinates = step.coordinates

            if let lastAppended = coordinates.last,
                let firstToAppend = stepCoordinates.first,
                let lastToAppend = stepCoordinates.last {

                let lastAppendedPoint = MKMapPointForCoordinate(lastAppended)
                let firstToAppendPoint = MKMapPointForCoordinate(firstToAppend)
                let lastToAppendPoint = MKMapPointForCoordinate(lastToAppend)

                if MKMetersBetweenMapPoints(lastAppendedPoint, firstToAppendPoint) <
                    MKMetersBetweenMapPoints(lastAppendedPoint, lastToAppendPoint) {

                    coordinates.append(contentsOf: stepCoordinates)

                } else {

                    coordinates.append(contentsOf: stepCoordinates.reversed())

                }

            } else {

                coordinates.append(contentsOf: stepCoordinates)
            }

        }

        return coordinates
    }

    init(fromRecorrido recorrido: RecorridoDAO, fromLocation from: RouteLocationViewModel, toLocation to: RouteLocationViewModel) {
        time = Measurement(value: Double(recorrido.tiempo), unit: UnitDuration.minutes)
        distance = Measurement(value: Double(recorrido.travelledDistance), unit: UnitLength.meters)

        var steps: [RouteStep] = []

        recorrido.plan.forEach { (recorridoPaso) in
            var step: RouteStep

            switch recorridoPaso.type {
            case .startBiking:
                step = RouteStepBegin(recorridoPasoDAO: recorridoPaso)
            case .street, .startWalking, .finishWalking:
                step = RouteStepBike(recorridoPasoDAO: recorridoPaso)
            case .finishBiking:
                step = RouteStepEnd(recorridoPasoDAO: recorridoPaso)
            }

            steps.append(step)
        }

        self.steps = steps

        origin = USIGCoordinateHelper.shared().convertFromUSIG(x: recorrido.origen.x, y: recorrido.origen.y)
        destination = USIGCoordinateHelper.shared().convertFromUSIG(x: recorrido.destino.x, y: recorrido.destino.y)

        fromLocation = from.toRouteLocation()
        toLocation = to.toRouteLocation()
    }

}
