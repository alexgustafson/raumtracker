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

    locationManager = [CLLocationManager new];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.activityType = CLActivityTypeFitness;
    [locationManager startUpdatingLocation];

    motionManager = [CMMotionManager new];


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
