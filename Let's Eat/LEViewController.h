//
//  LEViewController.h
//  Let's Eat
//
//  Created by Ryan Kass on 2/17/14.
//  Copyright (c) 2014 Ryan Kass. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
@class NoConnectionAlertDelegate;
@interface LEViewController : UIViewController <CLLocationManagerDelegate>

+ (void) setUserDefault:(NSString *)key data:(NSObject*) data;
+ (CLLocation*) myLocation;
+ (void) setMyLocation:(CLLocation*)locationInput;
- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error;
-(void)loadingScreen;
-(void)unloadScreen;
-(void)initializeTimer;
@property (strong, nonatomic) UIView* fadeout;
@property (strong, nonatomic) UIView* blacky;
@property (strong, nonatomic) UIActivityIndicatorView* loadingIndicator;
@property (strong, nonatomic) UILabel* loadingLabel;
@property (strong, nonatomic) NoConnectionAlertDelegate* noConnectionAlertDelegate;
@property (strong, nonatomic) NSTimer* timeoutTimer;
@property bool alertShowing;
@end
