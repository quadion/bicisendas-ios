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

    private var usigWrapper = USIGWrapper()

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        usigWrapper.isReady
            .bind(to: searchButton.rx.isEnabled)
            .disposed(by: disposeBag)

        searchButton.rx.tap
            .withLatestFrom(textField.rx.text.orEmpty)
            .bind(to: usigWrapper.searchTerm)
            .disposed(by: disposeBag)

        usigWrapper.suggestions
            .subscribe(onNext: { (suggestions) in
                print("👍 \(suggestions)")
            })
            .disposed(by: disposeBag)
    }

    @IBAction func searchTapped(_ sender: Any) {
        usigWrapper.suggestions(for: textField.text!)
    }
}
