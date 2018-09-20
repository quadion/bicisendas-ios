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

    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.isReady
            .bind(to: searchBar.rx.isUserInteractionEnabled)
            .disposed(by: disposeBag)

        searchBar.rx.text.orEmpty
            .throttle(0.5, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .observeOn(MainScheduler.instance)
            .bind(to: viewModel.searchTerm)
            .disposed(by: disposeBag)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let suggestions = segue.destination as? SuggestionsTableViewController {
            suggestions.viewModel = viewModel
        }
    }

}
