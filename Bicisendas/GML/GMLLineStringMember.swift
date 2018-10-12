//
//  GMLLineString.swift
//  Bicisendas
//
//  Created by Pablo Bendersky on 12/10/2018.
//  Copyright © 2018 Pablo Bendersky. All rights reserved.
//

public struct GMLLineStringMember: Decodable {

    public let lineString: GMLLineString

    enum CodingKeys: String, CodingKey {
        case lineString = "gml:LineString"
    }

}
