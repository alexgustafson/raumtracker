//
//  LocationHandler.m
//  raumtracker
//
//  Created by Alex Gustafson on 15/04/14.
//  Copyright (c) 2014 Alex Gustafson. All rights reserved.
//

#import "LocationHandler.h"

@implementation LocationHandler

+(LocationHandler *)sharedInstance
{
    //singleton setup
    static LocationHandler *_sharedInstance = nil;

    static dispatch_once_t oncePredicate;

    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[LocationHandler alloc] init];
    });
    return _sharedInstance;
}

+(BOOL)permissionsAvailable{
    if(![CLLocationManager locationServicesEnabled])
    {
        NSLog(@"Location Services not Enabled");
        return NO;
    }

    if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted ||
            [CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied)
    {
        NSLog(@"Location Services not Permitted");
        return NO;
    }

    return YES;
}

-(void)initialize {

    self.locationManager = [CLLocationManager new];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.activityType = CLActivityTypeFitness;


    self.motionManager = [CMMotionManager new];
    self.motionManager.showsDeviceMovementDisplay = YES;
    self.motionManager.deviceMotionUpdateInterval = 1.0 / 5.0;

    if (!self.motionManager.accelerometerAvailable) {
        NSLog(@"No Accelerometer Available");
        return;
    }

    self.motionManager.accelerometerUpdateInterval = 1.0 / 5.0;
    [self.motionManager startAccelerometerUpdates];


    dataManager = [[rtNetDataManager alloc] init];
    [dataManager initialize];

    dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.S";

    acceleration_x = [NSNumber numberWithDouble:0.0];
    acceleration_y = [NSNumber numberWithDouble:0.0];
    acceleration_z = [NSNumber numberWithDouble:0.0];


}

- (void)pollAccel
{
    CMAccelerometerData *dat = self.motionManager.accelerometerData;
    CMRotationMatrix r = self.motionManager.deviceMotion.attitude.rotationMatrix;
    //self.motionManager.deviceMotion.
    CMAcceleration acc = dat.acceleration;

    acceleration_x = [NSNumber numberWithDouble:self.motionManager.deviceMotion.userAcceleration.x ];
    acceleration_y = [NSNumber numberWithDouble:self.motionManager.deviceMotion.userAcceleration.y ];
    acceleration_z = [NSNumber numberWithDouble:self.motionManager.deviceMotion.userAcceleration.z ];

    if (now == nil) {
        now = [NSDate dateWithTimeIntervalSinceNow:self.motionManager.deviceMotion.timestamp];
    }


    attitude = [
            NSMutableArray arrayWithObjects:
                [NSNumber numberWithDouble:r.m11],
                [NSNumber numberWithDouble:r.m12],
                [NSNumber numberWithDouble:r.m13],
                [NSNumber numberWithDouble:r.m21],
                [NSNumber numberWithDouble:r.m22],
                [NSNumber numberWithDouble:r.m23],
                [NSNumber numberWithDouble:r.m31],
                [NSNumber numberWithDouble:r.m32],
                [NSNumber numberWithDouble:r.m33], nil
    ];

    if(rtData)
    {
        rtData[@"data"] = attitude;
        NSDate *timestamp = [NSDate dateWithTimeInterval:self.motionManager.deviceMotion.timestamp sinceDate:now];
        rtData[@"timestamp"] = [dateFormatter stringFromDate:timestamp];



        [dataManager postJsonData:[dataManager dictToJSON:rtData]];


    }
}

- (void)startTracker {



    NSUUID *uuid = [[NSUUID alloc] init];
    session_key = [uuid UUIDString];

    [self.locationManager startUpdatingLocation];
    [self.motionManager startDeviceMotionUpdatesUsingReferenceFrame:CMAttitudeReferenceFrameXTrueNorthZVertical];
    self.motionTimer = [NSTimer scheduledTimerWithTimeInterval:self.motionManager.accelerometerUpdateInterval
                                                        target:self
                                                      selector:@selector(pollAccel)
                                                      userInfo:nil
                                                       repeats:YES];

    NSDictionary *session_data =  @{
                    @"timestamp" : [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:[NSDate date]]],
                    @"session_key"  : session_key,
            };

    [dataManager postSessionData:[dataManager dictToJSON:session_data]];
}

- (void)stopTracker {
    [self.locationManager stopUpdatingLocation];
    [self.motionManager startDeviceMotionUpdates];
    [self.motionTimer invalidate];
    self.motionTimer = nil;
}


- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation * loc = locations.lastObject;
    CLLocationAccuracy hAcc = loc.horizontalAccuracy;
    CLLocationAccuracy vAcc = loc.verticalAccuracy;

    NSLog(@"h-acc: %f  lat:  %f   lon:   %f   alt: %f",
            hAcc,
            loc.coordinate.latitude,
            loc.coordinate.longitude,
            loc.altitude);



    if(attitude)
    {
        rtData = [NSMutableDictionary dictionaryWithDictionary:
                @{
                @"timestamp" : [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:loc.timestamp ]],
                @"latitude"  : [NSNumber numberWithFloat:loc.coordinate.latitude],
                @"longitude" : [NSNumber numberWithFloat:loc.coordinate.longitude],
                @"altitude"  : [NSNumber numberWithFloat:loc.altitude],
                @"acceleration_x" : acceleration_x,
                @"acceleration_y" : acceleration_y,
                @"acceleration_z" : acceleration_z,
                @"session_key"  : session_key,
        }];

        rtData[@"data"] = attitude;

    }
}



@end
