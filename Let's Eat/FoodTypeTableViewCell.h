//
//  FoodTypeTableViewCell.h
//  Let's Eat
//
//  Created by Ryan Kass on 5/1/14.
//  Copyright (c) 2014 Ryan Kass. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WhatViewController;
@interface FoodTypeTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIButton *expandCollapseButton;
@property (strong, nonatomic) IBOutlet UILabel *foodTypeLabel;
@property (strong, nonatomic) IBOutlet UIButton *ratingButton;
@property BOOL category;
@property int stars;
@property BOOL expanded;
@property (strong, nonatomic) WhatViewController* wvc;
-(void)setLayout:(NSMutableDictionary*)input vc:(WhatViewController*)vc;
@end
