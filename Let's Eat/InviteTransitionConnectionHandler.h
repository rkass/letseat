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

@interface InviteTransitionConnectionHandler : NSObject
@property (strong, nonatomic) NSMutableData* responseData;
@property (strong, nonatomic) InvitationsViewController* ivc;
@property (strong, nonatomic) InviteViewController* invitevc;
@property (strong, nonatomic) NSString* segue;
-(id)initWithInvitationsViewController:(InvitationsViewController*)ivcInput segueInput:(NSString*)segueInput;
-(id)initWithInvitateViewController:(InviteViewController*)ivcInput;
@end
