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

    var converter: USIGCoordinateHelper!

    override func setUp() {
        converter = USIGCoordinateHelper()
    }

    func testLavalle1625ToLatLong() {
        // Lavalle 1625 is 106728.370109, 102913.336526 in USIG

        let location = converter.convertFromUSIG(x: 106728.370109, y: 102913.336526)

        XCTAssertEqual(location.latitude, -34.60298633785443)
        XCTAssertEqual(location.longitude, -58.38994744519263)
    }

    func testLavalle1625ToUSIG() {
        let coordinate = CLLocationCoordinate2D(latitude: -34.60298633785443, longitude: -58.38994744519263)

        let punto = converter.convertToUSIG(coordinate: coordinate)

        XCTAssertEqual(punto.x, 106728.37020590133)
        XCTAssertEqual(punto.y, 102913.33643775557)
    }

}
