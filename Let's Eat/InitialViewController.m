//
//  ViewController.m
//  Let's Eat
//
//  Created by Ryan Kass on 2/10/14.
//  Copyright (c) 2014 Ryan Kass. All rights reserved.
//

#import "InitialViewController.h"
#import "HomeViewController.h"

@interface InitialViewController ()

@end

@implementation InitialViewController

- (void)viewDidLoad
{

    /*TODO
     handle checking if user is logged in in app delegate
     */
    [super viewDidLoad];
    if ([[NSUserDefaults standardUserDefaults] stringForKey:@"auth_token"])
        [self performSelector:@selector(loadHomeViewController) withObject:nil afterDelay:0.0];

}

-(void)loadHomeViewController
{
    [self performSegueWithIdentifier:@"initialToHome" sender:self];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
