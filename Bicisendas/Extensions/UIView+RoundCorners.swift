//
//  UIView+RoundCorners.swift
//  Bicisendas
//
//  Created by Pablo Bendersky on 21/11/2018.
//  Copyright © 2018 Pablo Bendersky. All rights reserved.
//

import UIKit

extension UIView {

    public func roundCorners(_ cornerRadius: CGFloat) {
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = true
    }

}
