//
//  RoutesViewController.swift
//  Bicisendas
//
//  Created by Pablo Bendersky on 27/08/2018.
//  Copyright © 2018 Pablo Bendersky. All rights reserved.
//

import UIKit
import WebKit

class RoutesViewController: UIViewController {

    private var usigWrapper = USIGWrapper()

    @IBOutlet weak var textField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func searchTapped(_ sender: Any) {
        usigWrapper.suggestions(for: textField.text!)
    }
}
