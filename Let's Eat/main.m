                    //
//  main.m
//  Let's Eat
//
//  Created by Ryan Kass on 2/10/14.
//  Copyright (c) 2014 Ryan Kass. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AppDelegate.h"

int main(int argc, char * argv[])
{
    NSLog(@"In main");
    @autoreleasepool {
        NSLog(@"In auto release pool");
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
