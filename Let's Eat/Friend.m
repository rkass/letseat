//
//  Friend.m
//  Let's Eat
//
//  Created by Ryan Kass on 2/19/14.
//  Copyright (c) 2014 Ryan Kass. All rights reserved.
//

#import "Friend.h"

@implementation Friend

@synthesize displayName, phoneNumbers;

- (Friend*) init:(NSString*)name numbers:(NSArray*)numbers
{
    
    self = [super init];
    self.displayName = name;
    self.phoneNumbers = numbers;
    return self;
}



@end
