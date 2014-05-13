//
//  PriceViewController.h
//  Let's Eat
//
//  Created by Ryan Kass on 2/27/14.
//  Copyright (c) 2014 Ryan Kass. All rights reserved.
//

#import "LEViewController.h"

#import <CoreLocation/CoreLocation.h>
@class CheckAllStarsTableViewCell;
@class ProgressBarDelegate;
@class ProgressBarTableViewCell;
@class FinalStepTableViewCell;
@interface PriceViewController : LEViewController <UITextFieldDelegate, CLLocationManagerDelegate, UIScrollViewDelegate, UITextViewDelegate, UITableViewDataSource, UITableViewDelegate>

@end
