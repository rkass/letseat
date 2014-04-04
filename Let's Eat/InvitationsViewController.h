//
//  InvitationsViewController.h
//  Let's Eat
//
//  Created by Ryan Kass on 3/3/14.
//  Copyright (c) 2014 Ryan Kass. All rights reserved.
//

#import "LEViewController.h"
#import "Invitation.h"
#import <CoreLocation/CoreLocation.h>
@interface InvitationsViewController : LEViewController <UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate>
@property (strong, nonatomic) NSMutableArray* passedInvitations;
@property (strong, nonatomic) NSMutableArray* upcomingInvitations;
@property (strong, nonatomic) NSMutableArray* passedMeals;
@property (strong, nonatomic) NSMutableArray* upcomingMeals;
@property (strong, nonatomic) IBOutlet UITableView *invitationsTable;
@property (strong, nonatomic) IBOutlet UITableView* mealsTable;
@property (strong, nonatomic) Invitation* transitionInvitation;
@property bool scheduled;
- (void) saveInvitations;
@property (strong, nonatomic) NSNumber* canDoWork;
@property (strong, nonatomic) CLLocation* myLocation;
- (void) syncInvitations:(bool)meals;
@end
