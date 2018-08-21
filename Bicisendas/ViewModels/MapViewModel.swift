//
//  MapViewModel.swift
//  Bicisendas
//
//  Created by Pablo Bendersky on 21/08/2018.
//  Copyright © 2018 Pablo Bendersky. All rights reserved.
//

import MapKit

import GeoJSON

import RxSwift

class MapViewModel {

    public let showStationsAction = PublishSubject<Void>()

    private let bikeStations: Observable<FeatureCollection>

    public let annotations: Observable<[MKAnnotation]>

    init() {
        bikeStations = BikeStationsOperation().rx.perform()

        annotations = showStationsAction.withLatestFrom(bikeStations)
            .map { featureCollection in
                return featureCollection.features.map { BikeStation(feature: $0) }
            }
    }

}
