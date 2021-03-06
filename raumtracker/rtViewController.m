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
    cameraView = [[rtCameraView alloc] initWithFrame:CGRectMake(0,0,self.view.bounds.size.width  , self.view.bounds.size.height )];
    [cameraView initialize];
    [self.view addSubview:cameraView];
    [cameraView startCameraPreview];

    glView = [[rtOpenGlView alloc] initWithFrame:CGRectMake(0,0,self.view.bounds.size.width  , self.view.bounds.size.height )];
    [self.view addSubview:glView];

    if([LocationHandler permissionsAvailable])
    {
        locationHandler = [LocationHandler sharedInstance];
        [locationHandler initialize];
        [locationHandler startTracker];

    }

    UIButton * btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame = CGRectMake(100, 100, 200, 50);
    [btn setTitle:@"Capture Image" forState:UIControlStateNormal];
    [self.view addSubview:btn];
    [btn addTarget:self
               action:@selector(takePhoto:)
     forControlEvents:UIControlEventTouchUpInside];
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

- (IBAction)takePhoto:(id)sender {
    [cameraView captureImage];
}


@end