//
//  USIGCoordinateTransformer.swift
//  Bicisendas
//
//  Created by Pablo Bendersky on 26/09/2018.
//  Copyright © 2018 Pablo Bendersky. All rights reserved.
//

import SwiftProjection

class USIGCoordinateTransformer {

    // From https://github.com/oskosk/mapabuenosaires-to-latlng/blob/master/src/mapabuenosaires-to-latlng.js
    private static let transformation = "+proj=tmerc +lat_0=-34.6297166 +lon_0=-58.4627 +k=0.9999980000000001 +x_0=100000 +y_0=100000 +ellps=intl +towgs84=-148,136,90,0,0,0,0 +units=m +no_defs"

    private let usigProjection: Projection!
    private let mapsProjection: Projection!

    init() {
        self.usigProjection = try! Projection(projString: USIGCoordinateTransformer.transformation)
        self.mapsProjection = try! Projection(identifier: "epsg:4326")
//        self.mapsProjection = try! Projection(projString: "+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs")
    }

    public func convertToUSIG(coordinate: ConvertibleCoordinate) -> ConvertibleCoordinate {
        let fromMap = try! mapsProjection.inverse!.transform(coordinate: coordinate)
        return try! self.usigProjection.inverse!.transform(coordinate: fromMap)
    }

    public func convertFromUSIG(coordinate: ConvertibleCoordinate) -> ConvertibleCoordinate {
        return try! self.usigProjection.transform(coordinate: coordinate)
    }

    public func convertFromUSIG(x: Double, y: Double) -> (Double, Double) {

        var pipeline = try! usigProjection.asPipeline()
        pipeline = try! pipeline.appendStep(projection: mapsProjection)

        let coordinate = ProjectionCoordinate(u: x, v: y)

        let converted = try! pipeline.transform(coordinate: coordinate)

        return (converted.u, converted.v)
    }
}
