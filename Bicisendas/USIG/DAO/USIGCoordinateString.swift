//
//  USIGCoordinateString.swift
//  Bicisendas
//
//  Created by Pablo Bendersky on 03/10/2018.
//  Copyright © 2018 Pablo Bendersky. All rights reserved.
//

public struct USIGCoordinateString: Codable {

    private let x: Double
    private let y: Double

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let coordinateString = try container.decode(String.self)

        let splittedString = coordinateString.split(separator: ",")

        x = Double(splittedString[0])!
        y = Double(splittedString[1])!
    }
}
