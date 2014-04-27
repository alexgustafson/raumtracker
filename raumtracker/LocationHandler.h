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

}

@property CLLocationManager *locationManager;
@property CMMotionManager *motionManager;
@property NSTimer *motionTimer;

+ (LocationHandler *)sharedInstance;
+ (BOOL)permissionsAvailable;
- (void)initialize;
- (void)pollAccel;

@end
