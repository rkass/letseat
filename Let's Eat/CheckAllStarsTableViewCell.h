//
//  CheckAllStarsTableViewCell.h
//  Let's Eat
//
//  Created by Ryan Kass on 5/2/14.
//  Copyright (c) 2014 Ryan Kass. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WhatViewController;
@class PriceViewController;
@interface CheckAllStarsTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIButton *stateButton;
@property int state;
@property (strong, nonatomic) WhatViewController* wvc;
@property (strong, nonatomic) PriceViewController* pvc;
-(void)setWithState:(int)state vc:(WhatViewController*)vc;
-(void)setWithPriceVC:(PriceViewController*)pvcInput;
@end
