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
import RxSwiftUtilities

class MapViewModel {

    public let showBikeStations = BehaviorSubject<Bool>(value: false)

    public let showStationsAction = PublishSubject<Void>()

    public let annotations = PublishSubject<[MKAnnotation]>()

    public let activityIndicator = ActivityIndicator()

    public let currentRoute = BehaviorSubject<Route?>(value: nil)

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
}
