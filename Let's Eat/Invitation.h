//
//  Invitation.h
//  Let's Eat
//
//  Created by Ryan Kass on 3/3/14.
//  Copyright (c) 2014 Ryan Kass. All rights reserved.
//

#import "LEViewController.h"

@interface Invitation : LEViewController
@property int num;
@property (strong, nonatomic) NSMutableArray* people;
@property (strong, nonatomic) NSDate* date;
@property (strong, nonatomic) NSString* message;
-(BOOL)passed;
- (id)init:(NSNumber*)numInput timeInput:(NSString*)timeInput peopleInput:(NSArray*)peopleInput messageInput:(NSString*)messageInput;
-(NSString*) displayPeople;
@end
