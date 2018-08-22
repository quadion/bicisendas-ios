//
//  InvertedOnSelectionButton.swift
//  Bicisendas
//
//  Created by Pablo Bendersky on 22/08/2018.
//  Copyright © 2018 Pablo Bendersky. All rights reserved.
//

import UIKit

class ToggleBikeStationsButton: UIButton {

    override var isSelected: Bool {
        didSet {
            if isSelected {
                tintColor = UIColor.white
                backgroundColor = superview?.tintColor
            } else {
                tintColor = superview?.tintColor
                backgroundColor = UIColor.clear
            }
        }
    }

}
