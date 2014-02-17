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

-(User *) init
{
    self = [super init];
    if (!self) return nil;
    return self;
}

- (NSArray *) createAccount:(NSString *)phoneNumber username:(NSString *)username password:(NSString *)password
{
    NSLog(@"Creating account with phone number: %@ and password %@", phoneNumber, password);
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:phoneNumber, @"phoneNumber", username, @"username", password, @"password", nil];
    Server *server = [[Server alloc] init];
    [server postRequest:@"register" data:dict];
    
    NSArray * arr = [NSArray arrayWithObjects:@"X", @"y", nil];
    return arr;
}

@end
