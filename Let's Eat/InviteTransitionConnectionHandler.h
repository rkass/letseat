//
//  InviteTransitionConnectionHandler.h
//  Let's Eat
//
//  Created by Ryan Kass on 4/4/14.
//  Copyright (c) 2014 Ryan Kass. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "InvitationsViewController.h"
#import "InviteViewController.h"
#import "CreateMealNavigationController.h"

@interface InviteTransitionConnectionHandler : NSObject
@property (strong, nonatomic) NSMutableData* responseData;
@property (strong, nonatomic) InvitationsViewController* ivc;
@property (strong, nonatomic) InviteViewController* invitevc;
@property (strong, nonatomic) CLLocation* myLocation;
@property (strong, nonatomic) NSString* segue;
@property (strong, nonatomic) UIAlertView* failedConnection;
@property (strong, nonatomic) CreateMealNavigationController* nav;
@property (strong, nonatomic) NSURLConnection* conn;
-(id)initWithInvitationsViewController:(InvitationsViewController*)ivcInput segueInput:(NSString*)segueInput;
-(id)initWithInvitateViewController:(InviteViewController*)ivcInput;
-(id)initWithNav:(CreateMealNavigationController*)cmInput;
+(Invitation*)loadInvitation:(NSDictionary*)resultsDictionary locationInput:(CLLocation*)locationInput;
@end
