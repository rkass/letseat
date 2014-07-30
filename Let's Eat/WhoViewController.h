//
//  WhoViewController.h
//  Let's Eat
//
//  Created by Ryan Kass on 2/18/14.
//  Copyright (c) 2014 Ryan Kass. All rights reserved.
//
#import "LEViewController.h"
#import <FacebookSDK/FacebookSDK.h>
@class CheckAllStarsTableViewCell;
@class ProgressBarDelegate;
@class ProgressBarTableViewCell;
@class FacebookLoginViewManager;
@interface WhoViewController : LEViewController  <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property (strong, nonatomic) NSMutableArray *friends;
@end
