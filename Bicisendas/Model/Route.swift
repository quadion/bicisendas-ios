//
//  Route.swift
//  Bicisendas
//
//  Created by Pablo Bendersky on 12/10/2018.
//  Copyright © 2018 Pablo Bendersky. All rights reserved.
//

public class Route {

    public let time: Int
    public let distance: Int
    public let origin: CLLocationCoordinate2D
    public let destination: CLLocationCoordinate2D
    public let steps: [RouteStep]

    public var coordinates: [CLLocationCoordinate2D] {
        return steps.flatMap { $0.coordinates }
    }

    init(fromRecorrido recorrido: RecorridoDAO) {
        time = recorrido.tiempo
        distance = recorrido.travelledDistance

        var steps: [RouteStep] = []

        recorrido.plan.forEach { (recorridoPaso) in
            var step: RouteStep

            switch recorridoPaso.type {
            case .startBiking:
                step = RouteStepBegin(recorridoPasoDAO: recorridoPaso)
            case .street:
                step = RouteStepBike(recorridoPasoDAO: recorridoPaso)
            case .finishBiking:
                step = RouteStepEnd(recorridoPasoDAO: recorridoPaso)
            }

            steps.append(step)
        }

        self.steps = steps

        origin = USIGCoordinateHelper.shared().convertFromUSIG(x: recorrido.origen.x, y: recorrido.origen.y)
        destination = USIGCoordinateHelper.shared().convertFromUSIG(x: recorrido.destino.x, y: recorrido.destino.y)
    }

}
