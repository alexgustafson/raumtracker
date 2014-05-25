//
//  rtViewController.m
//  raumtracker
//
//  Created by Alex Gustafson on 08/03/14.
//  Copyright (c) 2014 Alex Gustafson. All rights reserved.
//

#import "rtViewController.h"

@interface rtViewController ()

@end

@implementation rtViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    cameraView = [[rtCameraView alloc] initWithFrame:CGRectMake(10,10,self.view.bounds.size.width - 20 , self.view.bounds.size.height - 20)];
    [cameraView initialize];
    [self.view addSubview:cameraView];
    [cameraView startCameraPreview];

    glView = [[rtOpenGlView alloc] initWithFrame:CGRectMake(10,10,self.view.bounds.size.width - 20 , self.view.bounds.size.height - 20)];
    [self.view addSubview:glView];

    if([LocationHandler permissionsAvailable])
    {
        locationHandler = [LocationHandler sharedInstance];
        [locationHandler initialize];
        [locationHandler startTracker];

    }
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationPortrait;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.

}

-(BOOL)shouldAutorotate {
    return NO;
}




@end