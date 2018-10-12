//
//  GMLPoint.swift
//  Bicisendas
//
//  Created by Pablo Bendersky on 12/10/2018.
//  Copyright © 2018 Pablo Bendersky. All rights reserved.
//

public struct GMLPoint: Decodable {

    public let coordinates: GMLCoordinateString

    enum CodingKeys: String, CodingKey {
        case coordinates = "gml:coordinates"
    }

}
