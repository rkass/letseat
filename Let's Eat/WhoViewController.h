//
//  WhoViewController.h
//  Let's Eat
//
//  Created by Ryan Kass on 2/18/14.
//  Copyright (c) 2014 Ryan Kass. All rights reserved.
//

#import "MealViewController.h"

@interface WhoViewController : MealViewController  <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet NSArray* friends;

@end
