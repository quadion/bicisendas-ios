//
//  USIGBase.swift
//  Bicisendas
//
//  Created by Pablo Bendersky on 03/09/2018.
//  Copyright © 2018 Pablo Bendersky. All rights reserved.
//

class USIGContainer: Codable, CustomStringConvertible {
    var usigType: USIGType
    var usigObject: USIGObject

    var description: String {
        return "\(usigType)"
    }

    enum CodingKeys: String, CodingKey {
        case usigType
        case usigObject
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        usigType = try USIGType(rawValue: container.decode(String.self, forKey: .usigType))!
        switch (usigType) {
        case .calle:
            usigObject = try container.decode(CalleDAO.self, forKey: .usigObject)
        case .direccion:
            usigObject = try container.decode(DireccionDAO.self, forKey: .usigObject)
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(usigType, forKey: .usigType)
    }
}
