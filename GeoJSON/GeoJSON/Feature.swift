//
//  Feature.swift
//  GeoJSON
//
//  Created by Pablo Bendersky on 21/08/2018.
//  Copyright © 2018 Pablo Bendersky. All rights reserved.
//

public struct Feature: Decodable {

    public private(set) var geometry: Geometry
    public private(set) var id: String
    public private(set) var properties: [String: Any]

    enum CodingKeys: String, CodingKey {
        case geometry
        case id
        case properties
    }

    public init(from decoder: Decoder) throws {
        let keyedDecoder = try decoder.container(keyedBy: CodingKeys.self)

        geometry = try keyedDecoder.decode(Geometry.self, forKey: .geometry)
        id = try keyedDecoder.decode(String.self, forKey: .id)
        properties = try keyedDecoder.decode(Dictionary<String, Any>.self, forKey: .properties)
    }
}
