//
//  ViewController.swift
//  Bicisendas
//
//  Created by Pablo Bendersky on 10/08/2018.
//  Copyright © 2018 Pablo Bendersky. All rights reserved.
//

import UIKit

import MapKit

class ViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!

    fileprivate var bikePathsRenderer: MKTileOverlayRenderer!

    private let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        requestLocationPermission()

        mapView.centerCoordinate = CLLocationCoordinate2D(latitude: -34.6052088, longitude: -58.4811313)
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: -34.6052088, longitude: -58.45),
                                        span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
        mapView.setRegion(region, animated: true)
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .followWithHeading

        let overlay = BiciTileOverlay(urlTemplate: "https://tiles1.usig.buenosaires.gob.ar/mapcache/tms/1.0.0/ciclovias_caba_3857@GoogleMapsCompatible/{z}/{x}/{y}.png")

        overlay.minimumZ = 9
        overlay.maximumZ = 18

        bikePathsRenderer = MKTileOverlayRenderer(overlay: overlay)

        mapView.add(overlay, level: .aboveLabels)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func requestLocationPermission() {
        locationManager.requestWhenInUseAuthorization()
    }
}

class BiciTileOverlay: MKTileOverlay {

    override func url(forTilePath path: MKTileOverlayPath) -> URL {
        let flippedY = (1 << path.z) - path.y - 1

        let tileUrl = "https://tiles1.usig.buenosaires.gob.ar/mapcache/tms/1.0.0/ciclovias_caba_3857@GoogleMapsCompatible/\(path.z)/\(path.x)/\(flippedY).png"

        return URL(string: tileUrl)!
    }

}

extension ViewController: MKMapViewDelegate {

    public func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {

        return bikePathsRenderer
    }

}
