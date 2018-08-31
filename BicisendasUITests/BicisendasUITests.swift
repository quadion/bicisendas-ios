//
//  BicisendasUITests.swift
//  BicisendasUITests
//
//  Created by Pablo Bendersky on 31/08/2018.
//  Copyright © 2018 Pablo Bendersky. All rights reserved.
//

import XCTest

class BicisendasUITests: XCTestCase {

    private var app: XCUIApplication!

    override func setUp() {
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        app = XCUIApplication()
        setupSnapshot(app)
        app.launch()
    }

    func testCaptureScreenshots() {
        let springboard = XCUIApplication(bundleIdentifier: "com.apple.springboard")
        let allowBtn = springboard.buttons["Allow"]
        if allowBtn.exists {
            allowBtn.tap()
        }

        sleep(1)

        snapshot("01Map")

        app.buttons["bikeStationIcon"].tap()

        snapshot("02ClusteredBikeStations")

        app.maps.element.pinch(withScale: 2, velocity: 0.5)

        sleep(1)

        snapshot("03ZoomedIn")
    }

}
