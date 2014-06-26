//
//  NoConnectionAlertDelegate.m
//  Let's Eat
//
//  Created by Ryan Kass on 6/26/14.
//  Copyright (c) 2014 Ryan Kass. All rights reserved.
//

#import "NoConnectionAlertDelegate.h"
#import "LEViewController.h"
@implementation NoConnectionAlertDelegate


- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    [LEViewController setUserDefault:@"noConnectionAlertShowing" data:[NSNumber numberWithInteger:0]];
}
@end
