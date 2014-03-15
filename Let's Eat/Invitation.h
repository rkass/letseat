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
@property int creatorIndex;
@property (strong, nonatomic) NSMutableArray* people;
@property (strong, nonatomic) NSDate* date;
@property (strong, nonatomic) NSString* message;
@property (strong, nonatomic) NSMutableArray* responseArray;
@property BOOL iResponded;
-(BOOL)passed;
- (id)init:(NSNumber*)numInput timeInput:(NSString*)timeInput peopleInput:(NSArray*)peopleInput messageInput:(NSString*)messageInput iRespondedInput:(BOOL)iRespondedInput creatorIndexInput:(NSNumber*)creatorIndexInput responseArrayInput:(NSArray*)responseArrayInput;
-(NSString*) displayPeople;
-(id)initWithDict:(NSMutableDictionary*)dict;
-(NSMutableDictionary*)serialize;
-(NSString*)creator;
- (NSMutableArray*) generateResponsesArrays;
- (NSString*) dateToString;
-(BOOL) respondedNo;
-(BOOL) needToRespondToDate;
@end
