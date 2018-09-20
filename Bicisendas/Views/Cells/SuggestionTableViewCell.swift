//
//  SuggestionTableViewCell.swift
//  Bicisendas
//
//  Created by Pablo Bendersky on 20/09/2018.
//  Copyright © 2018 Pablo Bendersky. All rights reserved.
//

import UIKit

class SuggestionTableViewCell: UITableViewCell {

    public func updateWith(viewModel: CompletionResultViewModel) {
        self.textLabel?.text = viewModel.title
    }

}
