//
//  WhenViewController.m
//  Let's Eat
//
//  Created by Ryan Kass on 2/18/14.
//  Copyright (c) 2014 Ryan Kass. All rights reserved.
//

#import "WhenViewController.h"

@interface WhenViewController ()

@end

@implementation WhenViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    if (self.dateHolder)
    {
        
        self.when.date = self.dateHolder;
    }
    
    self.when.minimumDate = [NSDate date];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
