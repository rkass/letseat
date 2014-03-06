//
//  CreateMealNavigationController.h
//  Let's Eat
//
//  Created by Ryan Kass on 2/23/14.
//  Copyright (c) 2014 Ryan Kass. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateMealNavigationController : UINavigationController
@property (strong, nonatomic) UIViewController* homeViewController;
@property (strong, nonatomic) UIViewController* whenViewController;
@property (strong, nonatomic) UIViewController* whoViewController;
@property (strong, nonatomic) UIViewController* whereViewController;
@property BOOL creator;
@end
