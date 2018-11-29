//
//  DireccionDAO.swift
//  Bicisendas
//
//  Created by Pablo Bendersky on 29/08/2018.
//  Copyright © 2018 Pablo Bendersky. All rights reserved.
//

public class DireccionDAO: USIGObject, Codable {

    public var tipo: TipoDireccionDAO
    public var calle: CalleDAO
    public var altura: Int
    public var calleCruce: CalleDAO?

    enum CodingKeys: String, CodingKey {
        case tipo
        case calle
        case altura
        case calleCruce = "calle_cruce"
    }
}
