//
//  FacebookLoginViewManager.h
//  Let's Eat
//
//  Created by Ryan Kass on 7/29/14.
//  Copyright (c) 2014 Ryan Kass. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>
@class LoginViewController;
@class User;
@class LEViewController;
@interface FacebookLoginViewManager : NSObject <FBLoginViewDelegate>
@property (strong, nonatomic) FBLoginView* fblv;
@property (strong, nonatomic) LEViewController* currVC;
+ (FacebookLoginViewManager*)sharedManager;

@end
