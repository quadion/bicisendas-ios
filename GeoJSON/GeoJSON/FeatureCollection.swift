//
//  FeatureCollection.swift
//  GeoJSON
//
//  Created by Pablo Bendersky on 21/08/2018.
//  Copyright © 2018 Pablo Bendersky. All rights reserved.
//

public struct FeatureCollection: Decodable {

    public private(set) var features: [Feature]

    enum CodingKeys: String, CodingKey {
        case features
    }

    public init(from decoder: Decoder) throws {
        let child = try decoder.container(keyedBy: GeoJSONCodingKeys.self)
        let type = try child.decode(String.self, forKey: .type)

        guard type == "FeatureCollection" else { throw NSError() }

        let myDecoder = try decoder.container(keyedBy: CodingKeys.self)
        features = try myDecoder.decode([Feature].self, forKey: .features)
    }

    private init() {
        features = []
    }

    public static func empty() -> FeatureCollection {
        return FeatureCollection()
    }
}
