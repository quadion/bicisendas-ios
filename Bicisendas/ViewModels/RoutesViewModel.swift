//
//  RoutesViewModel.swift
//  Bicisendas
//
//  Created by Pablo Bendersky on 18/09/2018.
//  Copyright © 2018 Pablo Bendersky. All rights reserved.
//

import CoreLocation

import RxSwift
import RxCocoa

class RoutesViewModel {

    public var isReady = BehaviorRelay<Bool>(value: false)

    public var searchTerm = PublishSubject<String>()

    public var newResults = BehaviorRelay<Void>(value: Void())

    // TODO: This should be changed to an enum where we resolve the location on tap.
    public var fromLocation = BehaviorRelay<USIGContainer?>(value: nil)

    public var toLocation = BehaviorRelay<USIGContainer?>(value: nil)

    /// Emits a new value when we have found a pathway
    public var currentRoute = BehaviorRelay<Route?>(value: nil)

    public var resultsCount: Int {
        get {
            return completionResults.value.count
        }
    }

    private var completionResults = BehaviorRelay<[CompletionResultViewModel]>(value: [])

    private var usigWrapper = USIGWrapper()

    private let coordinateHelper = USIGCoordinateHelper()

    private let locationManager = CLLocationManager()

    private let disposeBag = DisposeBag()

    init() {
        usigWrapper.isReady
            .bind(to: isReady)
            .disposed(by: disposeBag)

        searchTerm
            .bind(to: usigWrapper.searchTerm)
            .disposed(by: disposeBag)

        usigWrapper.suggestions
            .map { (usigContainers) in
                usigContainers.map { CompletionResultViewModel(usigContainer: $0) }
            }
            .bind(to: completionResults)
            .disposed(by: disposeBag)

        completionResults
            .map { _ in
                return Void()
            }
            .bind(to: newResults)
            .disposed(by: disposeBag)

        initLocation()
        bindSearch()
        bindResults()
    }

    // TODO: This is wrong. We should resolve the user's location on search, not on init.
    private func initLocation() {
        if let location = locationManager.location {

            let usigCoordinate = coordinateHelper.convertToUSIG(coordinate: location.coordinate)

            let punto = PuntoDAO(coordX: usigCoordinate.x, coordY: usigCoordinate.y)

            let usigFrom = USIGContainer(usigType: .punto, usigObject: punto)

            fromLocation.accept(usigFrom)
        }
    }

    private func bindSearch() {
        Observable.combineLatest(fromLocation, toLocation)
            .filter { $0.0 != nil && $0.1 != nil }
            .subscribe(onNext: { [weak self] in
                guard
                    let strongSelf = self,
                    let from = $0.0, let to = $0.1 else { return }

                strongSelf.usigWrapper.directions(from: from, to: to)
            })
            .disposed(by: disposeBag)
    }

    private func bindResults() {
        usigWrapper.pathWay
            .filter { $0 != nil }
            .map { Route(fromRecorrido: $0!) }
            .bind(to: currentRoute)
            .disposed(by: disposeBag)
    }

    public func resultViewModel(atIndex index: Int) -> CompletionResultViewModel {
        return completionResults.value[index]
    }

}
