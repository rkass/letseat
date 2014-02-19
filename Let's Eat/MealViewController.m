//
//  MealViewController.m
//  Let's Eat
//
//  Created by Ryan Kass on 2/18/14.
//  Copyright (c) 2014 Ryan Kass. All rights reserved.
//

#import "MealViewController.h"
#import "WhoViewController.h"
#import "User.h"


@interface MealViewController ()

@end

@implementation MealViewController

@synthesize when, dateHolder;

- (void)viewDidLoad
{
    [super viewDidLoad];





    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"whenToWho"] || [[segue identifier] isEqualToString:@"whoToWhen" ])
    {
        if (self.when)
        {

            self.dateHolder = self.when.date;
        }
 

        MealViewController *nextView = [segue destinationViewController];
        nextView.dateHolder = self.dateHolder;

    }

}




@end
