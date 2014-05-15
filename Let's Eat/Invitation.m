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
@synthesize num, message, date, people, iResponded, creatorIndex, responseArray, central, preferences, scheduleTime, scheduled, restaurants, updatingRecommendations;

- (id)init:(NSNumber*)numInput timeInput:(NSString*)timeInput peopleInput:(NSArray*)peopleInput messageInput:(NSString*)messageInput iRespondedInput:(BOOL)iRespondedInput creatorIndexInput:(NSNumber*)creatorIndexInput responseArrayInput:(NSArray*)responseArrayInput centralInput:(BOOL)centralInput preferencesInput:(NSArray*)preferencesInput scheduleTimeInput:(NSString *)scheduleTimeInput scheduledInput:(BOOL)scheduledInput messagesArrayInput:(NSMutableArray *)messagesArrayInput
{
    self = [super init];
    if (self){
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];

        [dateFormatter setDateFormat:@"EEE, dd MMM yyyy H:m:s"];
        self.date = [dateFormatter dateFromString:timeInput];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
        self.scheduleTime = [dateFormatter dateFromString:scheduleTimeInput];
        self.people = [[NSMutableArray alloc] init];
        for (NSString* person in peopleInput){
            [self.people addObject:[User contactNameForNumber:person]];
        }
        self.num = [numInput integerValue];
        self.message = messageInput;
        self.iResponded = iRespondedInput;
        self.central = centralInput;
        NSLog(@"creator index input: %@", creatorIndexInput);
        self.creatorIndex = [creatorIndexInput integerValue];
        self.responseArray = [responseArrayInput mutableCopy];
        self.messagesArray = [messagesArrayInput mutableCopy];
        self.preferences = [preferencesInput mutableCopy];
        //NSLog(@"preferences: %@", self.preferences);
      //  [self decidePreferences];
       // NSLog(@"preferences: %@", self.preferences);
        self.scheduled = scheduledInput;
        self.restaurants = [[NSMutableArray alloc] init];
    }
    return self;
}
-(void)decidePreferences{
    NSMutableArray* p = [[NSMutableArray alloc] init];
    int cnt = 0;
    while (cnt < self.preferences.count){
        if (self.preferences[cnt] && (self.preferences[cnt] != nil) && (!([self.preferences[cnt] isKindOfClass:[NSArray class]])))
    
        
        {
        
            [p addObject:[[self.preferences[cnt] keysSortedByValueUsingComparator:^NSComparisonResult(id obj1, id obj2){
            return [obj1 compare:obj2];
            }] subarrayWithRange:NSMakeRange(0, 5) ]];
        }
        else
            [p addObject:[[NSMutableArray alloc] init]];
        cnt += 1;
    }
    self.preferences = [p mutableCopy];
}
- (NSString*)creator
{
    return self.people[self.creatorIndex];
}

-(NSMutableDictionary*)serialize{
    
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[NSNumber numberWithInt:self.num] forKey:@"num"];
    [dict setObject:self.date forKey:@"date"];
    [dict setObject:self.scheduleTime forKey:@"scheduleTime"];
    [dict setObject:self.people forKey:@"people"];
    [dict setObject:self.message forKey:@"message"];
    [dict setObject:[NSNumber numberWithBool:self.iResponded] forKey:@"iResponded"];
    [dict setObject:[NSNumber numberWithBool:self.central] forKey:@"central"];
    [dict setObject:[NSNumber numberWithInt:self.creatorIndex] forKey:@"creatorIndex"];
    [dict setObject:self.responseArray forKey:@"responseArray"];
    [dict setObject:self.messagesArray forKey:@"messagesArray"];
    [dict setObject:self.preferences forKey:@"preferences"];
    [dict setObject:[NSNumber numberWithBool:self.scheduled] forKey:@"scheduled"];
    return dict;
}

-(NSData*)serializeToData{
    
    return [NSKeyedArchiver archivedDataWithRootObject:[self serialize]];
}

-(NSString*) preferencesForPerson:(NSString*)person
{
    NSString* ret = @"";
    int count = 1;
    person = [person stringByReplacingOccurrencesOfString:@" (creator)" withString:@""];
    if ((self.preferences[[self.people indexOfObject:person]]) == (id)[NSNull null])
        return @"";
    int index = [self.people indexOfObject:((NSString*)person)];
    for (NSString* foodType in self.preferences[index]){
        if (count == [self.preferences[[self.people indexOfObject:person]] count])
            ret = [ret stringByAppendingString:[NSString stringWithFormat:@"%@",  foodType]];
        else
            ret = [ret stringByAppendingString:[NSString stringWithFormat:@"%@, ", foodType]];
        count += 1;
    }
    return ret;
}

-(NSString*) messagesForPerson:(NSString*)person{
    person = [person stringByReplacingOccurrencesOfString:@" (creator)" withString:@""];
    if (([self.people indexOfObject:person] == NSNotFound) || (self.messagesArray[[self.people indexOfObject:person]]) == (id)[NSNull null])
        return @"";
    return self.messagesArray[[self.people indexOfObject:person]];
}

-(NSString*) responseForPerson:(NSString*)person{
    person = [person stringByReplacingOccurrencesOfString:@" (creator)" withString:@""];
    if ((self.responseArray[[self.people indexOfObject:person]]) == (id)[NSNull null])
        return @"";
    return self.responseArray[[self.people indexOfObject:person]];
}

-(id)initWithDict:(NSMutableDictionary*)dict
{
    self = [super init];
    if (self){
        self.num = [dict[@"num"] intValue];
        self.date = dict[@"date"];
        self.scheduleTime = dict[@"scheduleTime"];
        self.people = dict[@"people"];
        self.message = dict[@"message"];
        self.iResponded = [dict[@"iResponded"] boolValue];
        self.central = [dict[@"central"] boolValue];
        self.creatorIndex = [dict[@"creatorIndex"] intValue];
        self.responseArray = [dict[@"responseArray"] mutableCopy];
        self.preferences = [dict[@"preferences"] mutableCopy];
        self.scheduled = [dict[@"scheduled"] boolValue];
        self.messagesArray = [dict[@"messagesArray"] mutableCopy];
    }
    return self;
}

-(id)initWithData:(NSData*)data
{
    return [self initWithDict:[NSKeyedUnarchiver unarchiveObjectWithData:data]];
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
        if ([self.responseArray[count] isEqualToString:@"yes"]){
            if (count == self.creatorIndex)
                [going addObject:[person stringByAppendingString:@" (creator)"]];
            else
                [going addObject:person];
        }

        else if ([self.responseArray[count] isEqualToString:@"undecided"])
            [undecided addObject:person];
        else
            [notGoing addObject:person];
        count += 1;
    }
    if ([undecided count] == 0)
        [undecided addObject:@"(None)"];
    if ([notGoing count] == 0)
        [notGoing addObject:@"(None)"];
    NSMutableArray* ret = [[NSMutableArray alloc] init];
    [ret addObject:going];
    [ret addObject:undecided];
    [ret addObject:notGoing];
    return ret;
}

-(NSString*) displayPeople
{
    NSString* creator = [self.people[self.creatorIndex] componentsSeparatedByString:@" "][0];
    if ([creator isEqualToString:@"You"]){
        if ([self.people count] == 1)
            return @"Just You";
        NSString* otherPerson;
        for (NSString* person in self.people){
            if (![person isEqualToString:@"You"])
                otherPerson = [person componentsSeparatedByString:@" "][0];
        }
        if ([self.people count] == 2)
            return [NSString stringWithFormat:@"You invited %@", otherPerson];
        if ([self.people count] == 3)
            return [NSString stringWithFormat:@"You invited %@ and 1 other", otherPerson];
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
-(BOOL) needToRespondToDate
{
    return ([self.creator isEqualToString:@"You"] || self.central);
}

- (NSString*) dateToString
{
    if ([self.date isToday] || [self.date isTomorrow]){
        NSString* starter = @"Today at ";
        if ([self.date isTomorrow])
            starter = @"Tomorrow at ";
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"h:mm aa"];
        return [NSString stringWithFormat:@"%@%@", starter, [dateFormat stringFromDate:self.date]];
    }
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"cccc, MMM d, h:mm aa"];
    return [dateFormat stringFromDate:self.date];
}

- (BOOL) passed
{
    return [self.date isInPast];

}

-(BOOL) passedScheduleTime{
    return [self.scheduleTime isInPast];
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
