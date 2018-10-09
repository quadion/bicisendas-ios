//
//  RecorridoDAO.swift
//  Bicisendas
//
//  Created by Pablo Bendersky on 02/10/2018.
//  Copyright © 2018 Pablo Bendersky. All rights reserved.
//

public struct RecorridoDAO: Codable {

    public let tiempo: Int
    public let destino: USIGCoordinateString
    public let origen: USIGCoordinateString
    public let travelledDistance: Int

    enum CodingKeys: String, CodingKey {
        case tiempo
        case destino
        case origen
        case travelledDistance = "traveled_distance"
    }
}
