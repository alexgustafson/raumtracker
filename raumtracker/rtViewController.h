//
//  rtViewController.h
//  raumtracker
//
//  Created by Alex Gustafson on 08/03/14.
//  Copyright (c) 2014 Alex Gustafson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocationHandler.h"

@interface rtViewController : UIViewController
{
    LocationHandler* locationHandler;
}

@end