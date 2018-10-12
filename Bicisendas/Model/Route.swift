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

    init(fromRecorrido recorrido: RecorridoDAO) {
        time = recorrido.tiempo
        distance = recorrido.travelledDistance
    }

}
