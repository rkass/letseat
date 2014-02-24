//
//  HomeViewController.m
//  Let's Eat
//
//  Created by Ryan Kass on 2/13/14.
//  Copyright (c) 2014 Ryan Kass. All rights reserved.
//

#import "HomeViewController.h"
#import "CreateMealNavigationController.h"


@interface HomeViewController ()
@property (strong, nonatomic) UIViewController* whenViewController;
@end

@implementation HomeViewController
@synthesize whenViewController;

- (void)viewDidLoad
{
    
    [super viewDidLoad];

    
}

- (IBAction)createNewMeal:(id)sender {
    CreateMealNavigationController* nav = (CreateMealNavigationController*) [self navigationController];
    [nav pushViewController:nav.whenViewController animated:YES];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
