//
//  RestaurantTableViewCell.h
//  Let's Eat
//
//  Created by Ryan Kass on 3/25/14.
//  Copyright (c) 2014 Ryan Kass. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Restaurant.h"
#import "InviteViewController.h"
@interface RestaurantTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *snippetImg;
@property (strong, nonatomic) IBOutlet UIImageView *ratingImg;
@property (strong, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) IBOutlet UILabel *address;
@property (strong, nonatomic) IBOutlet UILabel *votes;
@property (strong, nonatomic) IBOutlet UILabel *price;
@property (strong, nonatomic) IBOutlet UILabel *percentMatch;
@property int row;
@property bool oneRest;
@property (strong, nonatomic) IBOutlet UIButton *vote;
@property (strong, nonatomic) IBOutlet UILabel *types;
@property (strong, nonatomic) Restaurant* restaurant;
@property (strong, nonatomic) NSMutableData* responseData;
@property (strong, nonatomic) InviteViewController* ivc;
@property (strong, nonatomic) NSNumber* connector;
@property (strong, nonatomic) IBOutlet UIImageView *yelpCredit;
-(void)setWithRestaurant:(Restaurant*)restaurant rowInput:(int)rowInput ivcInput:(InviteViewController*)ivcInput oneRestInput:(BOOL)oneRestInput;
-(void)setNothingOpen;
@end
