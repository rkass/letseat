//
//  InvitationsViewController.h
//  Let's Eat
//
//  Created by Ryan Kass on 3/3/14.
//  Copyright (c) 2014 Ryan Kass. All rights reserved.
//

#import "LEViewController.h"

@interface InvitationsViewController : LEViewController <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) NSMutableArray* passedInvitations;
@property (strong, nonatomic) NSMutableArray* upcomingInvitations;
@property (strong, nonatomic) IBOutlet UITableView *invitationsTable;
- (void) saveInvitations;
@end
