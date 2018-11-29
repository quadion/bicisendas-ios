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
        switch usigType {
        case .direccion:
            if let direccion = usigObject as? DireccionDAO {
                if let cruce = direccion.calleCruce {
                    return "\(direccion.calle.nombre) y \(cruce.nombre)"
                } else {
                    return "\(direccion.calle.nombre) \(direccion.altura)"
                }
            } else {
                fallthrough
            }
        default:
            return "\(usigType)"
        }
    }

    enum CodingKeys: String, CodingKey {
        case usigType
        case usigObject
    }

    init(usigType: USIGType, usigObject: USIGObject) {
        self.usigType = usigType
        self.usigObject = usigObject
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        usigType = try USIGType(rawValue: container.decode(String.self, forKey: .usigType))!
        switch (usigType) {
        case .calle:
            usigObject = try container.decode(CalleDAO.self, forKey: .usigObject)
        case .direccion:
            usigObject = try container.decode(DireccionDAO.self, forKey: .usigObject)
        case .punto:
            usigObject = try container.decode(PuntoDAO.self, forKey: .usigObject)
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(usigType, forKey: .usigType)
        switch (usigType) {
        case .calle:
            try container.encode(usigObject as! CalleDAO, forKey: .usigObject)
        case .direccion:
            try container.encode(usigObject as! DireccionDAO, forKey: .usigObject)
        case .punto:
            try container.encode(usigObject as! PuntoDAO, forKey: .usigObject)
        }
    }
}
