//
//  MKCoordinateSpan+Bicisendas.swift
//  Bicisendas
//
//  Created by Pablo Bendersky on 31/08/2018.
//  Copyright © 2018 Pablo Bendersky. All rights reserved.
//

import MapKit

extension MKCoordinateSpan {

    public static func cabaSpan() -> MKCoordinateSpan {
        return MKCoordinateSpan(latitudeDelta: 0.3, longitudeDelta: 0.2)
    }

}
