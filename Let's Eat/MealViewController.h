//
//  MealViewController.h
//  Let's Eat
//
//  Created by Ryan Kass on 2/18/14.
//  Copyright (c) 2014 Ryan Kass. All rights reserved.
//

#import "LEViewController.h"


@interface MealViewController : LEViewController
@property (strong, nonatomic) IBOutlet UIDatePicker * when;
@property (strong, nonatomic) NSDate* dateHolder;
-(NSArray *)getContacts;
- (void) prepareForTransition;
//- (void) loadFromTransition;
@end
