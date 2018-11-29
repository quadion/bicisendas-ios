//
//  GMLParsingTests.swift
//  BicisendasTests
//
//  Created by Pablo Bendersky on 12/10/2018.
//  Copyright © 2018 Pablo Bendersky. All rights reserved.
//

import XCTest

import XMLParsing

@testable import Bicisendas

class GMLParsingTests: XCTestCase {

    func testPointParsing() {

        let gmlPoint = "<gml:feature><gml:type>bike</gml:type><gml:Point srsName=\"EPSG:97433\"><gml:coordinates>106733.162123603644432,102905.398639636201551</gml:coordinates></gml:Point></gml:feature>"

        let gmlFeature = feature(fromString: gmlPoint)

        XCTAssertEqual(gmlFeature.type, GMLType.bike)
        XCTAssertEqual(gmlFeature.point?.coordinates.x, 106733.162123603644432)
        XCTAssertEqual(gmlFeature.point?.coordinates.y, 102905.398639636201551)
    }

    func testMultilineStringParsingSingleLineStringMember() {
        let gmlMultiline = "<gml:feature><gml:type>Ciclovía</gml:type><gml:fid>13118501600</gml:fid><gml:MultiLineString srsName=\"EPSG:97433\"><gml:lineStringMember><gml:LineString><gml:coordinates>106772.839764332675259,102910.603138869148097 106766.557982706406619,103045.029723088809988</gml:coordinates></gml:LineString></gml:lineStringMember></gml:MultiLineString></gml:feature>"

        let gmlFeature = feature(fromString: gmlMultiline)

        XCTAssertEqual(gmlFeature.type, GMLType.ciclovia)
        XCTAssertNotNil(gmlFeature.multilineString)
        XCTAssertEqual(gmlFeature.multilineString?.lineStringMembers.count, 1)
    }

    func testMultilineStringParsingManyLineStringMembers() {
        let gmlMultiline = "<gml:feature><gml:type>Ciclovía</gml:type><gml:fid>2106016011679</gml:fid><gml:MultiLineString srsName=\"EPSG:97433\"><gml:lineStringMember><gml:LineString><gml:coordinates>106766.557982706406619,103045.029723088809988 106754.160077221735264,103043.443747955781873 106641.07114346131857,103035.154201324738096</gml:coordinates></gml:LineString></gml:lineStringMember><gml:lineStringMember><gml:LineString><gml:coordinates>106641.07114346131857,103035.154201324738096 106616.40031916598673,103033.341595805541147 106604.174276945530437,103032.513416916510323</gml:coordinates></gml:LineString></gml:lineStringMember><gml:lineStringMember><gml:LineString><gml:coordinates>106604.174276945530437,103032.513416916510323 106485.538700453267666,103024.481643897481263</gml:coordinates></gml:LineString></gml:lineStringMember><gml:lineStringMember><gml:LineString><gml:coordinates>106485.538700453267666,103024.481643897481263 106465.87547474418534,103023.145619820628781 106359.809670737275155,103016.824820116191404 106347.068026405511773,103015.801330114365555</gml:coordinates></gml:LineString></gml:lineStringMember><gml:lineStringMember><gml:LineString><gml:coordinates>106347.068026405511773,103015.801330114365555 106227.752800201371429,103006.222713351657148 106215.651753401471069,103005.277350381205906</gml:coordinates></gml:LineString></gml:lineStringMember><gml:lineStringMember><gml:LineString><gml:coordinates>106215.651753401471069,103005.277350381205906 106203.128849617438391,103004.292923291155603 106079.51688238317729,103002.667224591379636</gml:coordinates></gml:LineString></gml:lineStringMember><gml:lineStringMember><gml:LineString><gml:coordinates>106079.51688238317729,103002.667224591379636 105956.967370253914851,103001.057156869763276 105943.905422426469158,103000.791460182124865</gml:coordinates></gml:LineString></gml:lineStringMember><gml:lineStringMember><gml:LineString><gml:coordinates>105943.905422426469158,103000.791460182124865 105843.26123949677276,102998.744032830523793 105831.957028179182089,102998.798651802906534</gml:coordinates></gml:LineString></gml:lineStringMember><gml:lineStringMember><gml:LineString><gml:coordinates>105831.957028179182089,102998.798651802906534 105723.399096498280414,103000.094851104251575</gml:coordinates></gml:LineString></gml:lineStringMember><gml:lineStringMember><gml:LineString><gml:coordinates>105723.399096498280414,103000.094851104251575 105609.474142725113779,103011.648597044462804 105594.771626448462484,103013.507842138307751</gml:coordinates></gml:LineString></gml:lineStringMember><gml:lineStringMember><gml:LineString><gml:coordinates>105594.771626448462484,103013.507842138307751 105488.861948853431386,103026.90534375597781 105476.893694910439081,103028.327115102059906</gml:coordinates></gml:LineString></gml:lineStringMember><gml:lineStringMember><gml:LineString><gml:coordinates>105476.893694910439081,103028.327115102059906 105365.601432924449909,103041.513652013469255</gml:coordinates></gml:LineString></gml:lineStringMember></gml:MultiLineString></gml:feature>"

        let gmlFeature = feature(fromString: gmlMultiline)

        XCTAssertEqual(gmlFeature.type, GMLType.ciclovia)
        XCTAssertNotNil(gmlFeature.multilineString)
        XCTAssertEqual(gmlFeature.multilineString?.lineStringMembers.count, 12)
    }

    func testMultilineStringWithMultipleCoordinates() {
        let gml = "<gml:feature><gml:type>Ciclovía</gml:type><gml:fid>2106016011679</gml:fid><gml:MultiLineString srsName=\"EPSG:97433\"><gml:lineStringMember><gml:LineString><gml:coordinates>106766.557982706406619,103045.029723088809988 106754.160077221735264,103043.443747955781873 106641.07114346131857,103035.154201324738096</gml:coordinates></gml:LineString></gml:lineStringMember></gml:MultiLineString></gml:feature>"

        let gmlFeature = feature(fromString: gml)

        XCTAssertEqual(gmlFeature.multilineString?.lineStringMembers.first?.lineString.coordinates.count, 3)
    }

    func testFinishPath() {
        let gml = "<gml:feature><gml:type>end</gml:type><gml:Point srsName=\"EPSG:97433\"><gml:coordinates>98947.387759299890604,108063.893492999603041</gml:coordinates></gml:Point></gml:feature>"

        let gmlFeature = feature(fromString: gml)

        XCTAssertNotNil(gmlFeature)
    }

    private func feature(fromString string: String) -> GMLFeature {
        let data = string.data(using: .utf8)!

        let gmlFeature = try? XMLDecoder().decode(GMLFeature.self, from: data)

        return gmlFeature!
    }

}
