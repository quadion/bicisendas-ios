//
//  File.swift
//  Bicisendas
//
//  Created by Pablo Bendersky on 21/08/2018.
//  Copyright © 2018 Pablo Bendersky. All rights reserved.
//

import MapKit

import GeoJSON

class BikeStation: NSObject, MKAnnotation {

    private var feature: Feature

    public var coordinate: CLLocationCoordinate2D

    public var title: String? {
        guard let stationName = feature.properties["Nombre"] as? String else { return nil }

        return stationName
    }

    init(feature: Feature) {
        self.feature = feature

        switch feature.geometry {
        case .point(let latitude, let longitude):
            self.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
    }
}
