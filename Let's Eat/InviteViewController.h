//
//  InviteViewController.h
//  Let's Eat
//
//  Created by Ryan Kass on 3/4/14.
//  Copyright (c) 2014 Ryan Kass. All rights reserved.
//

#import "LEViewController.h"
#import "Invitation.h"
#import "InvitationsViewController.h"
#import <CoreLocation/CoreLocation.h>
@class InviteViewController;
@class NonScheduledTableViewCell;
@interface InviteViewController : LEViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, CLLocationManagerDelegate>
@property (strong, nonatomic) Invitation* invitation;
@property bool voteChanged;
@property bool scheduled;
@property (strong, nonatomic) NSMutableArray* restaurantsArr;
@property (strong, nonatomic) CLLocation* myLocation;
@property (strong, nonatomic) IBOutlet UILabel *date;
@property (strong, nonatomic) UIActivityIndicatorView* inviteSpinner;
@property (strong, nonatomic) InviteTransitionConnectionHandler* invtrans;
@property BOOL restsPressed;
@property BOOL wereDone;
- (void) layoutView;
- (void) saveRests;
-(void) recall;
@end
