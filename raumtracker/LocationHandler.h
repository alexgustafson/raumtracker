//
//  LocationHandler.h
//  raumtracker
//
//  Created by Alex Gustafson on 15/04/14.
//  Copyright (c) 2014 Alex Gustafson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


@interface LocationHandler : NSObject <CLLocationManagerDelegate>
{
    CLLocationManager *locationManager;
}

+ (LocationHandler *)sharedInstance;
+ (BOOL)permissionsAvailable;
- (void)initialize;

@end
