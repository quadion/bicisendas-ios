//
//  SuggestionTableViewCell.swift
//  Bicisendas
//
//  Created by Pablo Bendersky on 20/09/2018.
//  Copyright © 2018 Pablo Bendersky. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

class SuggestionTableViewCell: UITableViewCell {

    public var cellDisposeBag = DisposeBag()

    public var directionsAction = PublishSubject<SuggestionTableViewCell>()

    @IBOutlet weak var directionsButton: UIButton!

    public func updateWith(viewModel: CompletionResultViewModel) {
        self.textLabel?.text = viewModel.title
        self.directionsButton.isHidden = viewModel.shouldHideDirections

        self.directionsButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let strongSelf = self else { return }

                strongSelf.directionsAction.onNext(strongSelf)
            })
            .disposed(by: cellDisposeBag)
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        self.directionsButton.isHidden = true

        self.cellDisposeBag = DisposeBag()
    }

}
