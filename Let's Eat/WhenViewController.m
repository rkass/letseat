//
//  WhenViewController.m
//  Let's Eat
//
//  Created by Ryan Kass on 2/18/14.
//  Copyright (c) 2014 Ryan Kass. All rights reserved.
//

#import "WhenViewController.h"
#import "CreateMealNavigationController.h"

@interface WhenViewController ()
@property (strong, nonatomic) IBOutlet UIDatePicker * when;
@end

@implementation WhenViewController


- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"When";
    self.when.minimumDate = [NSDate date];

}
- (IBAction)whoPressed:(id)sender {
    CreateMealNavigationController* nav = (CreateMealNavigationController*) [self navigationController];
    [nav pushViewController:nav.whoViewController animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
