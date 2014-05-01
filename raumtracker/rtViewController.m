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
    if([LocationHandler permissionsAvailable])
    {
        locationHandler = [LocationHandler sharedInstance];
        [locationHandler initialize];

    }

    glView = [[rtOpenGlView alloc] initWithFrame:CGRectMake(100,100,50,50)];
    [self.view addSubview:glView];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.

}

@end