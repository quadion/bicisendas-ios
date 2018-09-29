//
//  USIGCoordinateHelper.h
//  Bicisendas
//
//  Created by Pablo Bendersky on 27/09/2018.
//  Copyright © 2018 Pablo Bendersky. All rights reserved.
//

@import CoreLocation;

NS_ASSUME_NONNULL_BEGIN

typedef struct {
    double x;
    double y;
} USIGCoordinate;

@interface USIGCoordinateHelper : NSObject

- (CLLocationCoordinate2D)convertFromUSIGX:(double)x y:(double)y
  NS_SWIFT_NAME(convertFromUSIG(x:y:));
- (USIGCoordinate)convertToUSIG:(CLLocationCoordinate2D)location
  NS_SWIFT_NAME(convertToUSIG(coordinate:));

@end

NS_ASSUME_NONNULL_END
