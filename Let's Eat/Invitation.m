//
//  Invitation.m
//  Let's Eat
//
//  Created by Ryan Kass on 3/3/14.
//  Copyright (c) 2014 Ryan Kass. All rights reserved.
//

#import "Invitation.h"
#import "User.h"
#import "NSDate-Utilities.h"

@interface Invitation ()

@end

@implementation Invitation
@synthesize num, message, date, people, iResponded, creatorIndex, responseArray;

- (id)init:(NSNumber*)numInput timeInput:(NSString*)timeInput peopleInput:(NSArray*)peopleInput messageInput:(NSString*)messageInput iRespondedInput:(BOOL)iRespondedInput creatorIndexInput:(NSNumber*)creatorIndexInput responseArrayInput:(NSArray*)responseArrayInput
{
    self = [super init];
    if (self){
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"EEE, dd MMM yyyy H:m:s"];
        self.date = [dateFormatter dateFromString:timeInput];
        self.people = [[NSMutableArray alloc] init];
        for (NSString* person in peopleInput){
            [self.people addObject:[User contactNameForNumber:person]];
        }
        self.num = [numInput integerValue];
        self.message = messageInput;
        self.iResponded = iRespondedInput;
        self.creatorIndex = [creatorIndexInput integerValue];
        self.responseArray = [responseArrayInput mutableCopy];
    }
    return self;
}

- (NSString*)creator
{
    return self.people[self.creatorIndex];
}

-(NSMutableDictionary*)serialize{
    
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[NSNumber numberWithInt:self.num] forKey:@"num"];
    [dict setObject:self.date forKey:@"date"];
    [dict setObject:self.people forKey:@"people"];
    [dict setObject:self.message forKey:@"message"];
    [dict setObject:[NSNumber numberWithBool:self.iResponded] forKey:@"iResponded"];
    [dict setObject:[NSNumber numberWithInt:self.creatorIndex] forKey:@"creatorIndex"];
    [dict setObject:self.responseArray forKey:@"responseArray"];
    return dict;
}

-(id)initWithDict:(NSMutableDictionary*)dict
{
    self = [super init];
    if (self){
        self.num = [dict[@"num"] intValue];
        self.date = dict[@"date"];
        self.people = dict[@"people"];
        self.message = dict[@"message"];
        self.iResponded = [dict[@"iResponded"] boolValue];
        self.creatorIndex = [dict[@"creatorIndex"] intValue];
        self.responseArray = [dict[@"responseArray"] mutableCopy];
    }
    return self;
}

/*
 Returns an Array of Three Arrays
 Index 0: People Going
 Index 1: People Undecided
 Index 2: People Not going
 List does not include creator
 */
- (NSMutableArray*) generateResponsesArrays{
    NSMutableArray* going = [[NSMutableArray alloc] init];
    NSMutableArray* undecided = [[NSMutableArray alloc] init];
    NSMutableArray* notGoing = [[NSMutableArray alloc] init];
    int count = 0;
    for (NSString* person in self.people)
    {
        if ([self.responseArray[count] isEqualToString:@"yes"])
            [going addObject:person];
        else if ([self.responseArray[count] isEqualToString:@"undecided"])
            [undecided addObject:person];
        else
            [notGoing addObject:person];
        count += 1;
    }
    NSMutableArray* ret = [[NSMutableArray alloc] init];
    [ret addObject:going];
    [ret addObject:undecided];
    [ret addObject:notGoing];
    return ret;
}

-(NSString*) displayPeople
{
    NSString* creator = self.people[self.creatorIndex];
    if ([creator isEqualToString:@"You"]){
        if ([self.people count] == 1)
            return @"Just You";
        NSString* otherPerson;
        for (NSString* person in self.people){
            if (![person isEqualToString:@"You"])
                otherPerson = person;
        }
        if ([self.people count] == 2)
            return [NSString stringWithFormat:@"You invited %@", otherPerson];
        if ([self.people count] == 3)
            return [NSString stringWithFormat:@"You invited %@ and one other", otherPerson];
        return [NSString stringWithFormat:@"You invited %@ and %u others", otherPerson, [self.people count] - 2];
    }
    if ([self.people count] == 2)
        return [NSString stringWithFormat:@"%@ invited You", creator];
    if ([self.people count] == 3)
        return [NSString stringWithFormat:@"%@ invited You and one other", creator];
    return [NSString stringWithFormat:@"%@ invited You and %u others", creator, [self.people count] - 2];

}


-(BOOL) respondedNo
{
    return [self.responseArray[ [self.people indexOfObject:@"You"] ] isEqualToString:@"no"];
}


- (NSString*) dateToString
{
    if ([self.date isToday] || [self.date isTomorrow]){
        NSString* starter = @"Today at ";
        if ([self.date isTomorrow])
            starter = @"Tomorrow at ";
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"hh:mm aa"];
        return [NSString stringWithFormat:@"%@%@", starter, [dateFormat stringFromDate:self.date]];
    }
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"cccc, MMM d, hh:mm aa"];
    return [dateFormat stringFromDate:self.date];
}

- (BOOL) passed
{
    NSDate* today = [NSDate date];
    if([today compare: self.date] == NSOrderedDescending)
        return YES;
    return NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
