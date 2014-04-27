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

    if (!self.motionManager.accelerometerAvailable) {
        NSLog(@"No Accelerometer Available");
        return;
    }

    self.motionManager.accelerometerUpdateInterval = 1.0 / 30.0;
    [self.motionManager startAccelerometerUpdates];
    self.motionTimer = [NSTimer scheduledTimerWithTimeInterval:self.motionManager.accelerometerUpdateInterval
                                                   target:self
                                                 selector:@selector(pollAccel:)
                                                 userInfo:nil
                                                  repeats:YES];
}

- (void)pollAccel
{
    CMAccelerometerData *dat = self.motionManager.accelerometerData;
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
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {

}

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading {

}


@end
