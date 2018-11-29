//
//  GMLFeature.swift
//  Bicisendas
//
//  Created by Pablo Bendersky on 12/10/2018.
//  Copyright © 2018 Pablo Bendersky. All rights reserved.
//

public struct GMLFeature: Decodable {

    let type: GMLType
    let point: GMLPoint?
    let multilineString: GMLMultilineString?

    enum CodingKeys: String, CodingKey {
        case type = "gml:type"
        case point = "gml:Point"
        case multilineString = "gml:MultiLineString"
    }
}
