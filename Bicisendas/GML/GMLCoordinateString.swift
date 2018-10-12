//
//  GMLCoordinate.swift
//  Bicisendas
//
//  Created by Pablo Bendersky on 12/10/2018.
//  Copyright © 2018 Pablo Bendersky. All rights reserved.
//

public struct GMLCoordinateString: Decodable {

    public let x: Double
    public let y: Double

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let coordinateString = try container.decode(String.self)

        try self.init(withString: coordinateString)
    }

    public init(withString string: String) throws {
        let splittedString = string.split(separator: ",")

        x = Double(splittedString[0])!
        y = Double(splittedString[1])!
    }
}
