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
#import "rtNetDataManager.h"

@interface LocationHandler : NSObject <CLLocationManagerDelegate>
{
    NSMutableDictionary *rtData;
    NSMutableArray *attitude;
    NSDate *now;
    rtNetDataManager *dataManager;
    NSDateFormatter *dateFormatter;
    NSString *session_key;

}

@property CLLocationManager *locationManager;
@property CMMotionManager *motionManager;
@property NSTimer *motionTimer;

+ (LocationHandler *)sharedInstance;
+ (BOOL)permissionsAvailable;
- (void)initialize;
- (void)pollAccel;

-(void)startTracker;
-(void)stopTracker;

@end
