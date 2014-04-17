//
//  LocationHandler.h
//  raumtracker
//
//  Created by Alex Gustafson on 15/04/14.
//  Copyright (c) 2014 Alex Gustafson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreMotion/CoreMotion.h>

@interface LocationHandler : NSObject <CLLocationManagerDelegate>
{
    CLLocationManager *locationManager;
    CMMotionManager *motionManager;
}

+ (LocationHandler *)sharedInstance;
+ (BOOL)permissionsAvailable;
- (void)initialize;

@end
