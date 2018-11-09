//
//  MKMapView+Bicisendas.swift
//  Bicisendas
//
//  Created by Pablo Bendersky on 09/11/2018.
//  Copyright © 2018 Pablo Bendersky. All rights reserved.
//

import MapKit

extension MKMapView {

    public func removeAnnotations<T: MKAnnotation>(ofType typeToRemove: T.Type) {

        annotations.filter { $0 is T }.forEach { removeAnnotation($0) }

    }

}
