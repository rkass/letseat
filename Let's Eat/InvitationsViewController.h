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
@class CheckAllStarsTableViewCell;
@class InvitationsConnectionHandler;
@class InviteTransitionConnectionHandler;
@interface InvitationsViewController : LEViewController <UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate>
@property (strong, nonatomic) NSMutableArray* passedInvitations;
@property (strong, nonatomic) NSMutableArray* upcomingInvitations;
@property (strong, nonatomic) NSMutableArray* passedMeals;
@property (strong, nonatomic) NSMutableArray* upcomingMeals;
@property (strong, nonatomic) IBOutlet UITableView *invitationsTable;
@property (strong, nonatomic) IBOutlet UITableView* mealsTable;
@property (strong, nonatomic) Invitation* transitionInvitation;
@property (strong, nonatomic) UIActivityIndicatorView* spinner;
@property (strong, nonatomic) NSNumber* tableLock;
@property (strong, nonatomic) InvitationsConnectionHandler* invConnHandler1;
@property (strong, nonatomic) InvitationsConnectionHandler* invConnHandler2;
@property (strong, nonatomic) InviteTransitionConnectionHandler* ivtch;
@property bool scheduled;
- (void) saveInvitations;
@property (strong, nonatomic) NSNumber* canDoWork;
-(void) refreshView;
- (void) syncInvitations:(bool)meals;
@end
