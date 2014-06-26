//
//  InvitationsConnectionHandler.h
//  Let's Eat
//
//  Created by Ryan Kass on 4/1/14.
//  Copyright (c) 2014 Ryan Kass. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "InvitationsViewController.h"
@class NoConnectionAlertDelegate;
@interface InvitationsConnectionHandler : NSObject <UIAlertViewDelegate>

@property (strong, nonatomic) NSMutableData* responseData;
@property (strong, nonatomic) InvitationsViewController* ivc;
@property bool meals;
@property (strong, nonatomic) NoConnectionAlertDelegate* noConnectionAppDelegate;
@property (strong, nonatomic) UIAlertView* failedConnection;
-(id)initWithInvitationsViewController:(InvitationsViewController*)ivcInput;

@end
