//
//  LEViewController.h
//  Let's Eat
//
//  Created by Ryan Kass on 2/17/14.
//  Copyright (c) 2014 Ryan Kass. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LEViewController : UIViewController
+ (void) setUserDefault:(NSString *)key data:(NSObject*) data;
- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error;
@end
