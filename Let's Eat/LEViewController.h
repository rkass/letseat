//
//  LEViewController.h
//  Let's Eat
//
//  Created by Ryan Kass on 2/17/14.
//  Copyright (c) 2014 Ryan Kass. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
@interface LEViewController : UIViewController <CLLocationManagerDelegate>

+ (void) setUserDefault:(NSString *)key data:(NSObject*) data;
+ (CLLocation*) myLocation;
+ (void) setLocation:(CLLocation*)locationInput;
- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error;
@end
