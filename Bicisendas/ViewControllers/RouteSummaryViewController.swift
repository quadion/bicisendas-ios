//
//  RouteSummaryViewController.swift
//  Bicisendas
//
//  Created by Pablo Bendersky on 17/10/2018.
//  Copyright © 2018 Pablo Bendersky. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

class RouteSummaryViewController: UIViewController {

    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var fromToStackView: UIStackView!
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var toLabel: UILabel!
    @IBOutlet weak var durationDistanceStackView: UIStackView!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!

    var viewModel: MapViewModel!

    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        setStackViewSpacings()
        bindUI()
    }

    private func setStackViewSpacings() {
        fromToStackView.setCustomSpacing(20, after: fromLabel)
        durationDistanceStackView.setCustomSpacing(20, after: durationLabel)
    }

    private func bindUI() {
        clearButton.rx.tap
            .map { nil }
            .bind(to: viewModel.currentRoute)
            .disposed(by: disposeBag)

        viewModel.currentRouteFrom
            .bind(to: fromLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.currentRouteTo
            .bind(to: toLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.duration
            .bind(to: durationLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.distance
            .bind(to: distanceLabel.rx.text)
            .disposed(by: disposeBag)
    }
}
