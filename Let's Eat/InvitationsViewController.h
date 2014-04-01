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
@property (strong, nonatomic) NSMutableArray* passedMeals;
@property (strong, nonatomic) NSMutableArray* upcomingMeals;
@property (strong, nonatomic) IBOutlet UITableView *invitationsTable;
@property (strong, nonatomic) IBOutlet UITableView* mealsTable;
@property bool scheduled;
- (void) saveInvitations;
@property (strong, nonatomic) NSNumber* canDoWork;
- (void) syncInvitations:(bool)meals;
@end
