//
//  MealViewController.h
//  Let's Eat
//
//  Created by Ryan Kass on 2/18/14.
//  Copyright (c) 2014 Ryan Kass. All rights reserved.
//

#import "LEViewController.h"


@interface MealViewController : LEViewController

@property (strong, nonatomic) NSDate* dateHolder;
@property (strong, nonatomic) IBOutlet UIDatePicker * when;


@end
