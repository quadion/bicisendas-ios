//
//  BikeStationsOperation.swift
//  Bicisendas
//
//  Created by Pablo Bendersky on 21/08/2018.
//  Copyright © 2018 Pablo Bendersky. All rights reserved.
//

import GeoJSON

import RxSwift

class BikeStationsOperation: NetworkOperation {

    typealias ResultType = FeatureCollection

    public var url: String {
        return "https://epok.buenosaires.gob.ar/getGeoLayer/?categoria=estaciones_de_bicicletas&formato=geojson&srid=4326"
    }

}

extension BikeStationsOperation: ReactiveCompatible { }
