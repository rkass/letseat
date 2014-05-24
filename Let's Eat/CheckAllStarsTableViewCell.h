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
@class InviteViewController;
@class WhoViewController;
@class InvitationsViewController;
@class TellFriendsViewController;
@class RestaurantViewController;
@interface CheckAllStarsTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIButton *stateButton;
@property int state;
@property (strong, nonatomic) WhoViewController* whovc;
@property (strong, nonatomic) WhatViewController* wvc;
@property (strong, nonatomic) InviteViewController* ivc;
@property (strong,nonatomic) InvitationsViewController* iivc;
@property (strong, nonatomic) PriceViewController* pvc;
@property (strong, nonatomic) RestaurantViewController* rvc;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) TellFriendsViewController* tfi;
-(void)setWithState:(int)state vc:(WhatViewController*)vc;
-(void)setWithPriceVC:(PriceViewController*)pvcInput;
-(void)setWithRVC:(RestaurantViewController*)rvcInput;
-(void)setWithInviteVC:(InviteViewController*)ivcInput;
-(void)setWithWhoVC:(WhoViewController*)whoInput;
-(void)setWithInvitationVC:(InvitationsViewController*)iivcInput;
-(void)setWithTellFriends:(TellFriendsViewController*)tfii;
-(void)generalSetup;
@end
