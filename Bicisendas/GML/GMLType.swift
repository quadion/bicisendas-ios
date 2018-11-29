//
//  GMLType.swift
//  Bicisendas
//
//  Created by Pablo Bendersky on 12/10/2018.
//  Copyright © 2018 Pablo Bendersky. All rights reserved.
//

public enum GMLType: String, Decodable {

    case bike = "bike"
    case ciclovia = "Ciclovía"
    case preferentialLane = "Carril preferencial"
    case end = "end"

    case marker = "marker"
    case walk = "walk"

}
