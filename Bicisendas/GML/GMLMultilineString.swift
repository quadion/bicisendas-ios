//
//  GMLMultilineString.swift
//  Bicisendas
//
//  Created by Pablo Bendersky on 12/10/2018.
//  Copyright © 2018 Pablo Bendersky. All rights reserved.
//

public struct GMLMultilineString: Decodable {

    public let lineStringMembers: [GMLLineStringMember]

    enum CodingKeys: String, CodingKey {
        case lineStringMembers = "gml:lineStringMember"
    }
}
