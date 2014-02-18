//
//  User.m
//  Let's Eat
//
//  Created by Ryan Kass on 2/13/14.
//  Copyright (c) 2014 Ryan Kass. All rights reserved.
//

#import "User.h"
#import "Server.h"

@implementation User

@synthesize auth_token, username;
-(User *) init
{
    self = [super init];
    if (!self) return nil;
    return self;
}

- (void) createAccount:(NSString *)phoneNumber usernameAttempt:(NSString *)usernameAttempt password:(NSString *)password source:(NSObject *)source
{
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:phoneNumber, @"phoneNumber", usernameAttempt, @"username", password, @"password", nil];
    Server *server = [[Server alloc] init];
    [server postRequest:@"register" data:dict source:source];

}

- (void)login:(NSString *)usernameAttempt password:(NSString *)password source:(NSObject*)source
{
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:usernameAttempt, @"username", password, @"password", nil];
    Server *server = [[Server alloc] init];
    [server postRequest:@"sign_in" data:dict source:source];
    
}


@end
