//
//  WhatViewController.h
//  Let's Eat
//
//  Created by Ryan Kass on 2/25/14.
//  Copyright (c) 2014 Ryan Kass. All rights reserved.
//

#import "LEViewController.h"
@class FoodTypeTableViewCell;
@class CheckAllStarsTableViewCell;

@interface WhatViewController : LEViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UIGestureRecognizerDelegate>
@property (strong, nonatomic) NSMutableArray* wantItems;
-(void)collapseCategory:(NSString*)categoryInput;
-(void)expandCategory:(NSString*)categoryInput;
-(void)updateFoodTypesTable:(NSMutableArray*)addIndices editIndices:(NSMutableArray*)editIndices removeIndices:(NSMutableArray*)removeIndices;
-(void)ratingPressed:(FoodTypeTableViewCell*)cell;
@property (strong, nonatomic) NSMutableArray* foodTypes;
-(void)statePressed:(int)s;
@end
