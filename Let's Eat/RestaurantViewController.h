//
//  RestaurantViewController.h
//  Let's Eat
//
//  Created by Ryan Kass on 3/26/14.
//  Copyright (c) 2014 Ryan Kass. All rights reserved.
//

#import "LEViewController.h"
#import "Restaurant.h"
@interface RestaurantViewController : LEViewController <UIWebViewDelegate>
@property (strong, nonatomic) Restaurant* restaurant;
@end
