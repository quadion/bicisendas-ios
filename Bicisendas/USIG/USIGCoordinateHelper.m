//
//  USIGCoordinateHelper.m
//  Bicisendas
//
//  Created by Pablo Bendersky on 27/09/2018.
//  Copyright © 2018 Pablo Bendersky. All rights reserved.
//

#import "USIGCoordinateHelper.h"

@import CoreLocation;

@import SwiftProjection;

@interface USIGCoordinateHelper ()

- (void)initProg4;

@end

@implementation USIGCoordinateHelper

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initProg4];
    }
    return self;
}

- (void)initProg4 {

}

- (CLLocationCoordinate2D)convertFromUSIGX:(double)x y:(double)y {

    PJ_CONTEXT *context = proj_context_create();
    pj_ctx_set_fileapi(context, get_bundle_fileapi());

    // For some reason, if we use the default proj_create, it will try to enter in cs2cs
    // compatibility mode, and fail for us (even though cs2cs works fine!).
    // By adding the internal parameter, we break that mode (see pj_cs2cs_emulation_setup
    // to understand why it works).
    PJ *src = proj_create(context, "+break_cs2cs_recursion +proj=tmerc +lat_0=-34.6297166 +lon_0=-58.4627 +k_0=0.999998 +x_0=100000 +y_0=100000 +ellps=intl +towgs84=-148,136,90,0,0,0,0 +units=m +no_defs");
    PJ *dst = proj_create(context, "+init=epsg:4326");

    double xTransform[] = { x };
    double yTransform[] = { y };

    pj_transform(src, dst, 1, 0, xTransform, yTransform, NULL);

    pj_free(src);
    pj_free(dst);

    proj_context_destroy(context);

    return CLLocationCoordinate2DMake(yTransform[0] * (double)RAD_TO_DEG, xTransform[0] * (double)RAD_TO_DEG);
}

@end
