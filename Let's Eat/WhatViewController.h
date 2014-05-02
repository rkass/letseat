//
//  WhatViewController.h
//  Let's Eat
//
//  Created by Ryan Kass on 2/25/14.
//  Copyright (c) 2014 Ryan Kass. All rights reserved.
//

#import "LEViewController.h"

@interface WhatViewController : LEViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>
@property (strong, nonatomic) NSMutableArray* wantItems;
-(void)collapseCategory:(NSString*)categoryInput;
-(void)expandCategory:(NSString*)categoryInput;

@end
