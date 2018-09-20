//
//  SuggestionsTableViewController.swift
//  Bicisendas
//
//  Created by Pablo Bendersky on 18/09/2018.
//  Copyright © 2018 Pablo Bendersky. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

class SuggestionsTableViewController: UITableViewController {

    private let disposeBag = DisposeBag()

    var viewModel: RoutesViewModel! {
        didSet {
            bindViewModel()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(SuggestionTableViewCell.self, forCellReuseIdentifier: "SuggestionCell")
    }

    private func bindViewModel() {
        viewModel.newResults
            .subscribe(onNext: tableView.reloadData)
            .disposed(by: disposeBag)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.resultsCount
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SuggestionCell", for: indexPath) as? SuggestionTableViewCell else {
            fatalError("Cell in \(#function) not of class SuggestionTableViewCell")
        }

        cell.updateWith(viewModel: viewModel.resultViewModel(atIndex: indexPath.row))

        return cell
    }
}
