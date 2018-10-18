//
//  RouteLocationViewModel.swift
//  Bicisendas
//
//  Created by Pablo Bendersky on 17/10/2018.
//  Copyright © 2018 Pablo Bendersky. All rights reserved.
//

/// This enum represents different locations we can use to search routes for.
enum RouteLocationViewModel {
    case currentLocation // Current location
    case usigObject(container: USIGContainer) // A location as returned by USIG

    public func toRouteLocation() -> RouteLocation {
        switch self {
        case .currentLocation:
            return .currentLocation
        case .usigObject(let container):
            return .enteredLocation(container.description)
        }
    }
}
