//
//  FacebookLoginViewManager.m
//  Let's Eat
//
//  Created by Ryan Kass on 7/29/14.
//  Copyright (c) 2014 Ryan Kass. All rights reserved.
//

#import "FacebookLoginViewManager.h"
#import "User.h"
#import "LEViewController.h"
#import "LoginViewController.h"
@implementation FacebookLoginViewManager

+ (id)sharedManager {
    static FacebookLoginViewManager *fblvm= nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        fblvm = [[self alloc] init];
    });
    return fblvm;
}
- (id)init {
    if (self = [super init]) {
        self.fblv = [[FBLoginView alloc] initWithReadPermissions:@[@"user_friends"]];
        self.fblv.delegate = self;
    }
    return self;
}
- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user {
    NSLog(@"user id %@", user.id);
    NSLog(@"user name %@", user.name);
    if ([self.currVC isKindOfClass:[LoginViewController class]]){
        [self.currVC loadingScreen];
        [User createAccountFB:user.id source:self.currVC];
    }
}
- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView {
    NSLog(@"niggas logged in");
}
- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView {
    NSLog(@"niggas logged out");
}
- (void)loginView:(FBLoginView *)loginView handleError:(NSError *)error {
    NSLog(@"some facebook error shit happened");
}

@end
