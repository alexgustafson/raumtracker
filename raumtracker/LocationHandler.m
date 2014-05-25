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
    [self.locationManager startUpdatingLocation];

    self.motionManager = [CMMotionManager new];
    self.motionManager.showsDeviceMovementDisplay = YES;
    self.motionManager.deviceMotionUpdateInterval = 1.0 / 5.0;
    [self.motionManager startDeviceMotionUpdatesUsingReferenceFrame:CMAttitudeReferenceFrameXTrueNorthZVertical];

    if (!self.motionManager.accelerometerAvailable) {
        NSLog(@"No Accelerometer Available");
        return;
    }

    self.motionManager.accelerometerUpdateInterval = 1.0 / 5.0;
    [self.motionManager startAccelerometerUpdates];
    self.motionTimer = [NSTimer scheduledTimerWithTimeInterval:self.motionManager.accelerometerUpdateInterval
                                                   target:self
                                                 selector:@selector(pollAccel)
                                                 userInfo:nil
                                                  repeats:YES];

    dataManager = [[rtNetDataManager alloc] init];
    [dataManager initialize];

    dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.S";


}

- (void)pollAccel
{
    CMAccelerometerData *dat = self.motionManager.accelerometerData;
    CMRotationMatrix r = self.motionManager.deviceMotion.attitude.rotationMatrix;
    //self.motionManager.deviceMotion.
    CMAcceleration acc = dat.acceleration;
    CGFloat x = acc.x;
    CGFloat y = acc.y;
    CGFloat z = acc.z;

    CGFloat accu = 0.08;
    if (fabs(x) <accu && fabs(y) < accu && fabs(z) < accu)
    {
        NSLog(@"x: %f  y:  %f   z:   %f ",
                x,
                y,
                z);
    }

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

        // source: http://www.codetuition.com/ios-tutorials/convert-nsdictionary-or-nsarray-to-json-nsstring-and-vice-versa/
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:rtData options:0 error:&error];
        if(!jsonData) {
            NSLog(@"JSON error: %@", error);
        }else{
            //NSString *JsonString = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
            //NSLog(@"json output %@", JsonString);
        }

        [dataManager postJsonData:jsonData];


    }



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
        }];

        rtData[@"data"] = attitude;

    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {

}

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading {

}


@end
