//
//  BikeStandMarkerAnnotationView.swift
//  Bicisendas
//
//  Created by Pablo Bendersky on 21/08/2018.
//  Copyright © 2018 Pablo Bendersky. All rights reserved.
//

import UIKit

import MapKit

class BikeStandMarkerAnnotationView: MKMarkerAnnotationView {

    override var annotation: MKAnnotation? {
        willSet {
            if let cluster = newValue as? MKClusterAnnotation {
                glyphText = "\(cluster.memberAnnotations.count)"
                glyphImage = nil
            } else {
                glyphText = nil
                glyphImage = #imageLiteral(resourceName: "bikeStationIcon")
            }

            canShowCallout = true
            titleVisibility = .hidden
            markerTintColor = UIColor(named: "bikeStationColor")
        }
    }

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)

        clusteringIdentifier = "bikeStationClusterIdentifier"
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        clusteringIdentifier = "bikeStationClusterIdentifier"
    }

}
