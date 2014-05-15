//
//  NonScheduledTableViewCell.h
//  Let's Eat
//
//  Created by Ryan Kass on 5/15/14.
//  Copyright (c) 2014 Ryan Kass. All rights reserved.
//

#import <UIKit/UIKit.h>
@class InviteViewController;
@interface NonScheduledTableViewCell : UITableViewCell
@property (strong, nonatomic) InviteViewController* ivc;
@property (strong, nonatomic) IBOutlet UILabel *messageHeader;
@property (strong, nonatomic) IBOutlet UILabel *message;
-(void)setWithIVC:(InviteViewController*)ivcInput;
@end
