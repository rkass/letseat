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
- (NSArray *)createAccount:(NSString *)phoneNumber username:(NSString *)username password:(NSString *)password;
-(User *)init;

@end
