//
//  RestaurantViewController.h
//  Let's Eat
//
//  Created by Ryan Kass on 3/26/14.
//  Copyright (c) 2014 Ryan Kass. All rights reserved.
//

#import "LEViewController.h"
#import "Restaurant.h"
@class CheckAllStarsTableViewCell;
@interface RestaurantViewController : LEViewController <UIWebViewDelegate, UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) Restaurant* restaurant;
@property (strong, nonatomic) IBOutlet UIWebView *yelpView;
@end
