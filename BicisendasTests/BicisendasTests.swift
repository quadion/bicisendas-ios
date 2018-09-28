//
//  BicisendasTests.swift
//  BicisendasTests
//
//  Created by Pablo Bendersky on 26/09/2018.
//  Copyright © 2018 Pablo Bendersky. All rights reserved.
//

import XCTest

@testable import Bicisendas

class CoordinatesTests: XCTestCase {

    func testLavalle1625() {
        // Lavalle 1625 is 106728.370109, 102913.336526 in USIG

        let converter = USIGCoordinateHelper()

        let location = converter.convert(fromUSIGX: 106728.370109, y: 102913.336526)

        XCTAssertEqual(location.latitude, -34.60298633785489)
        XCTAssertEqual(location.longitude, -58.38994744519263)
    }

}
