//
//  LoginViewController.h
//  Let's Eat
//
//  Created by Ryan Kass on 2/17/14.
//  Copyright (c) 2014 Ryan Kass. All rights reserved.
//

#import "ValidationViewController.h"
#import <FacebookSDK/FacebookSDK.h>
@class FacebookLoginViewManager;
@interface LoginViewController : ValidationViewController <UITextFieldDelegate, UITextViewDelegate, FBLoginViewDelegate>
@property (strong, nonatomic) IBOutlet UILabel *labia;
@property (strong, nonatomic) IBOutlet UIImageView *bluearrow;
@property (strong, nonatomic) IBOutlet UILabel *orme;
@property (strong, nonatomic) FBLoginView* fblv;
@end
