//
//  LEViewController.m
//  Let's Eat
//
//  Created by Ryan Kass on 2/17/14.
//  Copyright (c) 2014 Ryan Kass. All rights reserved.
//

#import "LEViewController.h"

@interface LEViewController ()
@property (strong, nonatomic) UIAlertView *failedConnection;
@end

@implementation LEViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    self.failedConnection = [[UIAlertView alloc] initWithTitle:@"Oof" message:@"Couldn't connect to the server.  Check your connection and try again." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
    [self.failedConnection show];
}

+ (void) setUserDefault:(NSString *)key data:(NSString *) data
{
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
