//
//  USIGCoordinateHelper.h
//  Bicisendas
//
//  Created by Pablo Bendersky on 27/09/2018.
//  Copyright © 2018 Pablo Bendersky. All rights reserved.
//

@import CoreLocation;

NS_ASSUME_NONNULL_BEGIN

@interface USIGCoordinateHelper : NSObject

- (CLLocationCoordinate2D)convertFromUSIGX:(double)x y:(double)y;

@end

NS_ASSUME_NONNULL_END
