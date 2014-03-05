//
//  InviteViewController.h
//  Let's Eat
//
//  Created by Ryan Kass on 3/4/14.
//  Copyright (c) 2014 Ryan Kass. All rights reserved.
//

#import "LEViewController.h"
#import "Invitation.h"

@interface InviteViewController : LEViewController <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) Invitation* invitation;
@end
