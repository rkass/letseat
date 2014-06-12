//
//  InvitationsConnectionHandler.h
//  Let's Eat
//
//  Created by Ryan Kass on 4/1/14.
//  Copyright (c) 2014 Ryan Kass. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "InvitationsViewController.h"

@interface InvitationsConnectionHandler : NSObject

@property (strong, nonatomic) NSMutableData* responseData;
@property (strong, nonatomic) InvitationsViewController* ivc;
@property bool meals;

-(id)initWithInvitationsViewController:(InvitationsViewController*)ivcInput;

@end
