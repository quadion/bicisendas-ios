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
import RxCocoa
import RxSwiftUtilities

class MapViewModel {

    /// MKMapRect of CABA, as obtained when initializing the map. We'll use it to check if
    /// directions are to be enabled, and to show an alert to the user.
    public let cabaMapRect = BehaviorRelay<MKMapRect?>(value: nil)

    /// Current visible MKMapRect. To be combined with CABA Map Rect so we can check if the mapa is centered
    /// in the area of interest.
    public let visibleMapRect = BehaviorRelay<MKMapRect?>(value: nil)

    public let showBikeStations = BehaviorSubject<Bool>(value: false)

    public let showStationsAction = PublishSubject<Void>()

    public let annotations = PublishSubject<[MKAnnotation]>()

    public let activityIndicator = ActivityIndicator()

    public let currentRoute = BehaviorSubject<Route?>(value: nil)

    public var currentRouteFrom: Observable<String> {
        return currentRoute
            .filter { $0 != nil }
            .map { [weak self] in
                guard let strongSelf = self else { return "" }

                return strongSelf.formatRouteLocation($0!.fromLocation)
            }
    }

    public var currentRouteTo: Observable<String> {
        return currentRoute
            .filter { $0 != nil }
            .map { [weak self] in
                guard let strongSelf = self else { return "" }

                return strongSelf.formatRouteLocation($0!.toLocation)
        }
    }

    public var duration: Observable<String> {
        return currentRoute
            .filter { $0 != nil }
            .map {
                let timeFormatter = MeasurementFormatter()
                timeFormatter.locale = Locale(identifier: "es_AR")
                timeFormatter.unitOptions = .naturalScale
                timeFormatter.unitStyle = .medium

                return timeFormatter.string(from: $0!.time)
            }
    }

    public var distance: Observable<String> {
        return currentRoute
            .filter { $0 != nil }
            .map {
                let distanceFormatter = MeasurementFormatter()
                distanceFormatter.locale = Locale(identifier: "es_AR")
                distanceFormatter.unitOptions = .naturalScale
                distanceFormatter.unitStyle = .medium

                return distanceFormatter.string(from: $0!.distance)
            }
    }

    public lazy var inCaba: Observable<Bool> = {
        return Observable.combineLatest(cabaMapRect, visibleMapRect)
            .map { rects in
                guard let caba = rects.0, let visible = rects.1 else { return true }

                return MKMapRectIntersectsRect(caba, visible)
            }
    }()

    private let disposeBag = DisposeBag()

    init() {
        setupBindings()
    }

    private func setupBindings() {
        showStationsAction.withLatestFrom(showBikeStations)
            .map { !$0 }
            .bind(to: showBikeStations)
            .disposed(by: disposeBag)

        showBikeStations.asObservable()
            .filter {
                $0
            }
            .flatMap({ [weak self] (show: Bool) -> Observable<FeatureCollection> in

                guard let strongSelf = self else { return Observable.just(FeatureCollection.empty()) }

                return BikeStationsOperation().rx
                    .perform()
                    .trackActivity(strongSelf.activityIndicator)
                    .catchError({ [weak self] (error) -> Observable<FeatureCollection> in
                        self?.showBikeStations.onNext(false)

                        return Observable.just(FeatureCollection.empty())
                    })
            })
            .map { featureCollection in
                return featureCollection.features.map { BikeStation(feature: $0) }
            }
            .bind(to: annotations)
            .disposed(by: disposeBag)
    }

    private func formatRouteLocation(_ routeLocation: RouteLocation) -> String {
        switch routeLocation {
        case .currentLocation:
            return "My Location"
        case .enteredLocation(let string):
            return string
        }
    }
}
