//
//  RouteEndpoint.swift
//  Bicisendas
//
//  Created by Pablo Bendersky on 09/11/2018.
//  Copyright © 2018 Pablo Bendersky. All rights reserved.
//

import MapKit

public class RouteEndpoint: NSObject, MKAnnotation {

    public enum EndpointType {
        case begin
        case end
    }

    public let endpointType: EndpointType
    public let coordinate: CLLocationCoordinate2D

    init(endpointType: EndpointType, coordinate: CLLocationCoordinate2D) {
        self.endpointType = endpointType
        self.coordinate = coordinate
    }

}
