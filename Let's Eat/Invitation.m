//
//  Invitation.m
//  Let's Eat
//
//  Created by Ryan Kass on 3/3/14.
//  Copyright (c) 2014 Ryan Kass. All rights reserved.
//

#import "Invitation.h"
#import "User.h"

@interface Invitation ()

@end

@implementation Invitation
@synthesize num, message, date, people;

- (id)init:(NSNumber*)numInput timeInput:(NSString*)timeInput peopleInput:(NSArray*)peopleInput messageInput:(NSString*)messageInput
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
    }
    return self;
}

-(NSMutableDictionary*)serialize{
    NSMutableDictionary* dict =
}

-(NSString*) displayPeople
{
    NSString* ret = @"";
    int count = 0;
    for (NSString* person in self.people){
        if (count == 0){
            ret = [ret stringByAppendingString:person];
            ret = [ret stringByAppendingString:@" invited"];
            if (!([[ret substringToIndex:3] isEqualToString:@"You"])){
                int more = [self.people count] - 2;
                NSString* morestr = [NSString stringWithFormat:@"%d others", more];
                NSString* completion = [@" you and " stringByAppendingString:morestr];
                ret = [ret stringByAppendingString:completion];
                return ret;
            }
            else if ([self.people count] == 1)
                return @"You alone";
            count += 1;
        }
        else{
            NSString* other = [NSString stringWithFormat:@" %@ and %d others", person, [self.people count] - 2];
            return [ret stringByAppendingString:other];
        }
    }
    return @"";
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
