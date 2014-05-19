//
//  HomeViewController.h
//  Let's Eat
//
//  Created by Ryan Kass on 2/13/14.
//  Copyright (c) 2014 Ryan Kass. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LEViewController.h"
@class CheckAllStarsTableViewCell;
@interface HomeViewController : LEViewController <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UIDatePicker *date;
@end
