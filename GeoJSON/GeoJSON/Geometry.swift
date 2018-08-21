//
//  Geometry.swift
//  GeoJSON
//
//  Created by Pablo Bendersky on 21/08/2018.
//  Copyright © 2018 Pablo Bendersky. All rights reserved.
//

public enum Geometry: Decodable {

    case point(longitude: Double, latitude: Double)

    enum PointCodingKeys: String, CodingKey {
        case coordinates
    }

    public init(from decoder: Decoder) throws {
        let childDecoder = try decoder.container(keyedBy: GeoJSONCodingKeys.self)

        let type = try childDecoder.decode(String.self, forKey: .type)

        guard type == "Point" else {
            throw EncodingError.invalidValue(type, EncodingError.Context(codingPath: decoder.codingPath,
                                                                         debugDescription: "Unsupported Geometry"))
        }

        let pointDecoder = try decoder.container(keyedBy: PointCodingKeys.self)
        var coordinatesDecoder = try pointDecoder.nestedUnkeyedContainer(forKey: .coordinates)

        let latitude = try coordinatesDecoder.decode(Double.self)
        let longitude = try coordinatesDecoder.decode(Double.self)

        self = .point(longitude: longitude, latitude: latitude)
    }
}
