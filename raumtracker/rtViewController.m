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

    locationHandler = [LocationHandler sharedInstance];
    [locationHandler initialize];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.

}

@end