//
//  RouteEndpointAnnotationView.swift
//  Bicisendas
//
//  Created by Pablo Bendersky on 09/11/2018.
//  Copyright © 2018 Pablo Bendersky. All rights reserved.
//

import UIKit

import MapKit

class RouteEndpointAnnotationView: MKMarkerAnnotationView {

    override var annotation: MKAnnotation? {
        willSet {

            if let routeEndpoint = newValue as? RouteEndpoint {

                switch routeEndpoint.endpointType {
                case .begin:
                    markerTintColor = UIColor(named: "routeBeginColor")!
                case .end:
                    markerTintColor = UIColor(named: "routeEndColor")!
                }
            }

            displayPriority = .required
            canShowCallout = false
            titleVisibility = .hidden
        }
    }

}
