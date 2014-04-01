//
//  InvitationsConnectionHandler.m
//  Let's Eat
//
//  Created by Ryan Kass on 4/1/14.
//  Copyright (c) 2014 Ryan Kass. All rights reserved.
//

#import "InvitationsConnectionHandler.h"
#import "JSONKit.h"
#import "Invitation.h"

@implementation InvitationsConnectionHandler
@synthesize ivc, responseData;

-(id)initWithInvitationsViewController:(InvitationsViewController*)ivcInput{
    self = [super init];
    self.ivc = ivcInput;
    self.responseData = [[NSMutableData alloc] initWithLength:0];
    return self;
}

- (void)connectionDidFinishLoading:(NSURLConnection*)connection
{
    NSDictionary *resultsDictionary = [self.responseData objectFromJSONData];
    NSMutableArray* upcoming;
    NSMutableArray* passed;
    if ([resultsDictionary[@"meals"] boolValue]){
        NSLog(@"meals");
        upcoming = self.ivc.upcomingMeals;
        passed = self.ivc.passedMeals;
    }
    else{
        NSLog(@"not meals");
        NSLog(@"%@", resultsDictionary);
        upcoming = self.ivc.upcomingInvitations;
        passed = self.ivc.passedInvitations;
    }
    [upcoming removeAllObjects];
    [passed removeAllObjects];
    for (NSMutableDictionary* dict in resultsDictionary[@"invitations"]){
        Invitation* i = [[Invitation alloc] init:dict[@"id"] timeInput:dict[@"time"] peopleInput:dict[@"people"] messageInput:dict[@"message"] iRespondedInput:[dict[@"iResponded"] boolValue] creatorIndexInput:dict[@"creatorIndex"] responseArrayInput:dict[@"responses"] centralInput:[dict[@"central"] boolValue] preferencesInput:dict[@"preferences"] scheduleTimeInput:dict[@"scheduleTime"]];
        [upcoming addObject:i];
    }
    @synchronized(self.ivc.canDoWork){
        //if (self.ivc.canDoWork.intValue == 1)
            [self.ivc syncInvitations:[resultsDictionary[@"meals"] boolValue]];
        if ([resultsDictionary[@"meals"] boolValue])
            [self.ivc.mealsTable reloadData];
        else
            [self.ivc.invitationsTable reloadData];
        self.ivc.canDoWork = [NSNumber numberWithInt:1];
    }

}

- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.responseData appendData:data];
}



@end
