//
//  PuntoDAO.swift
//  Bicisendas
//
//  Created by Pablo Bendersky on 25/09/2018.
//  Copyright © 2018 Pablo Bendersky. All rights reserved.
//

import CoreLocation

public class PuntoDAO: USIGObject, Codable {

    public var coordX: Double
    public var coordY: Double

    enum CodingKeys: String, CodingKey {
        case coordX = "x"
        case coordY = "y"
    }

    init(coordX: Double, coordY: Double) {
        self.coordX = coordX
        self.coordY = coordY
    }
}
