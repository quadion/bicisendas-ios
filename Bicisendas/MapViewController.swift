//
//  ViewController.swift
//  Bicisendas
//
//  Created by Pablo Bendersky on 10/08/2018.
//  Copyright © 2018 Pablo Bendersky. All rights reserved.
//

import UIKit

import MapKit

import RxSwift
import RxCocoa

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var buttonContainerStackView: UIStackView!
    @IBOutlet weak var buttonContainerBackgroundView: UIVisualEffectView!
    @IBOutlet weak var warningButton: UIButton!
    @IBOutlet weak var bikeStationsButton: UIButton!

    var userTrackingButton: MKUserTrackingButton!
    var compassButton: MKCompassButton!

    fileprivate var bikePathsRenderer: MKTileOverlayRenderer!

    private let locationManager = CLLocationManager()

    private let viewModel = MapViewModel()

    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        registerMapViewAnnotations()

        buttonContainerBackgroundView.layer.cornerRadius = 5

        locationManager.delegate = self

        requestLocationPermission()

        mapView.centerCoordinate = CLLocationCoordinate2D(latitude: -34.6052088, longitude: -58.4811313)
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: -34.6052088, longitude: -58.45),
                                        span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
        mapView.setRegion(region, animated: true)
        mapView.showsCompass = false

        userTrackingButton = MKUserTrackingButton(mapView: mapView)
        userTrackingButton.translatesAutoresizingMaskIntoConstraints = false

        updateButtons(forLocationServicesEnabled: CLLocationManager.locationServicesEnabled())

        buttonContainerStackView.addArrangedSubview(userTrackingButton)

        compassButton = MKCompassButton(mapView: mapView)
        compassButton.compassVisibility = .adaptive

        view.addSubview(compassButton)

        compassButton.translatesAutoresizingMaskIntoConstraints = false
        compassButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        compassButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -20).isActive = true

        let overlay = BiciTileOverlay(urlTemplate: "https://tiles1.usig.buenosaires.gob.ar/mapcache/tms/1.0.0/ciclovias_caba_3857@GoogleMapsCompatible/{z}/{x}/{y}.png")

        overlay.minimumZ = 9
        overlay.maximumZ = 18

        bikePathsRenderer = MKTileOverlayRenderer(overlay: overlay)

        mapView.add(overlay, level: .aboveRoads)

        bindUI()
    }

    private func registerMapViewAnnotations() {
        mapView.register(BikeStandMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        mapView.register(BikeStandMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier)
    }

    private func bindUI() {
        bikeStationsButton.rx.tap
            .bind(to: viewModel.showStationsAction)
            .disposed(by: disposeBag)

        viewModel.annotations
            .subscribe(onNext: { [weak self] (annotations) in

                guard let strongSelf = self else { return }

                strongSelf.mapView.removeAnnotations(strongSelf.mapView.annotations)
                strongSelf.mapView.addAnnotations(annotations)

            }, onError: { (error) in
                print(error)
            })
            .disposed(by: disposeBag)
    }

    private func requestLocationPermission() {
        locationManager.requestWhenInUseAuthorization()
    }

    fileprivate func updateButtons(forLocationServicesEnabled locationServicesEnabled: Bool) {
        userTrackingButton.isHidden = !locationServicesEnabled
        warningButton.isHidden = locationServicesEnabled
    }

    @IBAction func warningButtonTapped(_ sender: Any) {
        let alertController = UIAlertController(title: NSLocalizedString("Location Disabled",
                                                                         comment: "Location Disabled Alert Title"),
                                                message: NSLocalizedString("Please enable access to your Location for this app to allow us to track you on the map.", comment: "Location Disabled Alert Text"),
                                                preferredStyle: .alert)

        let cancelAction = UIAlertAction(title: NSLocalizedString("Later", comment: "Location Disabled Alert Cancel Action"),
                                         style: .cancel,
                                         handler: nil)
        alertController.addAction(cancelAction)

        let settingsAction = UIAlertAction(title: NSLocalizedString("Go to Settings", comment: "Location Disabled Alert Settings Action"),
                                           style: .default) { (_) in

            guard let settingsURL = URL(string: UIApplicationOpenSettingsURLString) else { return }

            UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
        }

        alertController.addAction(settingsAction)

        present(alertController, animated: true, completion: nil)
    }
}

class BiciTileOverlay: MKTileOverlay {

    override func url(forTilePath path: MKTileOverlayPath) -> URL {
        let flippedY = (1 << path.z) - path.y - 1

        let tileUrl = "https://tiles1.usig.buenosaires.gob.ar/mapcache/tms/1.0.0/ciclovias_caba_3857@GoogleMapsCompatible/\(path.z)/\(path.x)/\(flippedY).png"

        return URL(string: tileUrl)!
    }

}

extension MapViewController: MKMapViewDelegate {

    public func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {

        return bikePathsRenderer
    }

//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//
//        guard !annotation.isKind(of: MKUserLocation.self) else { return nil }
//
//        guard let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "bikeStation", for: annotation)
//            as? MKMarkerAnnotationView else { fatalError("MapView not configured properly") }
//
//        annotationView.annotation = annotation
//
//        if let cluster = annotation as? MKClusterAnnotation {
//            annotationView.glyphText = "\(cluster.memberAnnotations.count)"
//            annotationView.glyphImage = nil
//        } else {
//            annotationView.glyphText = nil
//            annotationView.glyphImage = UIImage(named: "bikeStationIcon")
//        }
//
//        annotationView.canShowCallout = true
//        annotationView.titleVisibility = .hidden
//        annotationView.markerTintColor = UIColor(named: "bikeStationColor")
//
//        return annotationView
//    }

}

extension MapViewController: CLLocationManagerDelegate {

    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        let locationAvailable = (status == .authorizedAlways || status == .authorizedWhenInUse)

        updateButtons(forLocationServicesEnabled: locationAvailable)
    }
}
