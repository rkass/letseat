//
//  User.h
//  Let's Eat
//
//  Created by Ryan Kass on 2/13/14.
//  Copyright (c) 2014 Ryan Kass. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

/*
 Sends new account credentials to the server and saves new data in
 user defaults.
 Index 0 is a bool for if account creation was successful.
 Index 1 carries an error message.
 */
@property (strong, nonatomic) NSString *auth_token;
@property (strong, nonatomic) NSString *username;
+ (void)createAccount:(NSString *)phoneNumber usernameAttempt:(NSString *)usernameAttempt password:(NSString *)password source:(NSObject*)source;
+ (void)login:(NSString *)usernameAttempt password:(NSString *)password source:(NSObject*)source;
+(NSArray *)getContacts;
+ (void) getFriends:(NSObject *) source;
+ (void) createInvitation:(NSMutableDictionary*)preferences source:(NSObject*)source;
+ (void) getInvitations:(NSObject *) source;
+ (NSString*)contactNameForNumber:(NSString*)phoneNumber;
+ (void) respondNo:(int)num message:(NSString*)message source:(NSObject*)source;
+ (void) respondYes:(int)num preferences:(NSMutableDictionary*)preferences source:(NSObject*)source;
+ (void) getNonFriends:(NSObject *) source;
+ (void) getRestaurants:(int)num source:(NSObject*)source;
+ (void) castVote:(NSMutableDictionary*)dict source:(NSObject*)source;
+ (void) castUnvote:(NSMutableDictionary*)dict source:(NSObject*)source;
-(User *)init;

@end
