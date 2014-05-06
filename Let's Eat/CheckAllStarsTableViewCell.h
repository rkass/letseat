//
//  CheckAllStarsTableViewCell.h
//  Let's Eat
//
//  Created by Ryan Kass on 5/2/14.
//  Copyright (c) 2014 Ryan Kass. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WhatViewController;
@interface CheckAllStarsTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIButton *stateButton;
@property int state;
@property (strong, nonatomic) WhatViewController* wvc;
-(void)setWithState:(int)state vc:(WhatViewController*)vc;
@end
