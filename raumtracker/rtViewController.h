//
//  rtViewController.h
//  raumtracker
//
//  Created by Alex Gustafson on 08/03/14.
//  Copyright (c) 2014 Alex Gustafson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocationHandler.h"
#import "rtOpenGlView.h"
#import "rtCameraView.h"

@interface rtViewController : UIViewController
{
    LocationHandler* locationHandler;
    rtOpenGlView* glView;
    rtCameraView *cameraView;
    
}

- (IBAction)takePhoto:(id)sender;

@end