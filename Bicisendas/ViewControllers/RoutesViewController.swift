//
//  RoutesViewController.swift
//  Bicisendas
//
//  Created by Pablo Bendersky on 27/08/2018.
//  Copyright © 2018 Pablo Bendersky. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

class RoutesViewController: UIViewController {

    private var viewModel = RoutesViewModel()

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var dismissButton: UIBarButtonItem!

    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.isReady
            .bind(to: searchBar.rx.isUserInteractionEnabled)
            .disposed(by: disposeBag)

        viewModel.error
            .asDriver(onErrorJustReturn: nil)
            .filter { $0 != nil }
            .drive(onNext: showError(_:))
            .disposed(by: disposeBag)

        searchBar.rx.text.orEmpty
            .throttle(0.5, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .observeOn(MainScheduler.instance)
            .bind(to: viewModel.searchTerm)
            .disposed(by: disposeBag)

        dismissButton.rx.tap
            .bind(onNext: dismissTapped)
            .disposed(by: disposeBag)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let suggestions = segue.destination as? SuggestionsTableViewController {
            suggestions.viewModel = viewModel
        }
    }

    private func dismissTapped() {
        dismiss(animated: true, completion: nil)
    }

    private func showError(_ error: String?) {
        let alert = UIAlertController(title: NSLocalizedString("We are sorry!", comment: "Error searching route"),
                                      message: NSLocalizedString("We could not find a route from your location.", comment: "Error searching route"),
                                      preferredStyle: .alert)

        let dismissAction = UIAlertAction(title: NSLocalizedString("Dismiss", comment: "Dismiss"), style: .default) { [weak self] (_) in
            self?.dismiss(animated: true, completion: nil)
        }

        alert.addAction(dismissAction)

        present(alert, animated: true, completion: nil)
    }
}
