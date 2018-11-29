//
//  TipoRecorridoPaso.swift
//  Bicisendas
//
//  Created by Pablo Bendersky on 17/10/2018.
//  Copyright © 2018 Pablo Bendersky. All rights reserved.
//

public enum TipoRecorridoPaso: String, Codable {
    case startBiking = "StartBiking"
    case street = "Street"
    case finishBiking = "FinishBiking"
    case startWalking = "StartWalking"
    case finishWalking = "FinishWalking"
}
