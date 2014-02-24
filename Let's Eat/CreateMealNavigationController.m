//
//  CreateMealNavigationController.m
//  Let's Eat
//
//  Created by Ryan Kass on 2/23/14.
//  Copyright (c) 2014 Ryan Kass. All rights reserved.
//

#import "CreateMealNavigationController.h"
#import "HomeViewController.h"
#import "WhenViewController.h"
#import "WhoViewController.h"


@interface CreateMealNavigationController ()

@end

@implementation CreateMealNavigationController
@synthesize whoViewController, whenViewController, whereViewController;
- (void)viewDidLoad
{

    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.whenViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"whenView"];
    [self.whenViewController view];
    self.whoViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"whoView"];
     self.whereViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"whereView"];
   // self.whenViewController = [[WhenViewController alloc] init];
   //[self.whenViewController view];
  //  [self.whoViewController view];
    //self.whoViewController.view.alpha = 0;
    //[self.view addSubview:self.whoViewController.view];
    //[self addsubView:self.whoViewController.view];
  //  [self addSubview:self.whoViewController.view];
   // [self setViewControllers:@[self.homeViewController] animated:NO];
  //  [self pushViewController:self.homeViewController animated:NO];
    self.navigationBarHidden = NO;
    
    
    
    //NSArray *stack = [NSArray arrayWithObjects:homeViewController, whenViewController, whoViewController, nil];
    //self.viewControllers = stack;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
