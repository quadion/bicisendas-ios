//
//  BicisendasUITests.swift
//  BicisendasUITests
//
//  Created by Pablo Bendersky on 31/08/2018.
//  Copyright © 2018 Pablo Bendersky. All rights reserved.
//

import XCTest

class BicisendasUITests: XCTestCase {

    override func setUp() {
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        let app = XCUIApplication()
        setupSnapshot(app)
        app.launch()
    }

    func testCaptureScreenshots() {
        let springboard = XCUIApplication(bundleIdentifier: "com.apple.springboard")
        let allowBtn = springboard.buttons["Allow"]
        if allowBtn.exists {
            allowBtn.tap()
        }

        snapshot("01Map")
    }

}
