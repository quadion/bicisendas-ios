//
//  GMLLineString.swift
//  Bicisendas
//
//  Created by Pablo Bendersky on 12/10/2018.
//  Copyright © 2018 Pablo Bendersky. All rights reserved.
//

public struct GMLLineString: Decodable {

    public let coordinates: [GMLCoordinateString]

    enum CodingKeys: String, CodingKey {
        case coordinates = "gml:coordinates"
    }

    public init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: CodingKeys.self)
        let coordinateString = try container.decode(String.self, forKey: .coordinates)

        let splittedString = coordinateString.split(separator: " ")

        self.coordinates = splittedString.map { try! GMLCoordinateString(withString: String($0)) }
    }

}
