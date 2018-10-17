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

    public var coordinates: [CLLocationCoordinate2D] {
        return [origin, destination]
    }

    private static let coordinateHelper = USIGCoordinateHelper()

    init(fromRecorrido recorrido: RecorridoDAO) {
        time = recorrido.tiempo
        distance = recorrido.travelledDistance

        origin = Route.coordinateHelper.convertFromUSIG(x: recorrido.origen.x, y: recorrido.origen.y)
        destination = Route.coordinateHelper.convertFromUSIG(x: recorrido.destino.x, y: recorrido.destino.y)
    }

}
