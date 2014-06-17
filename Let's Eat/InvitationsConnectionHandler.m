//
//  InvitationsConnectionHandler.m
//  Let's Eat
//
//  Created by Ryan Kass on 4/1/14.
//  Copyright (c) 2014 Ryan Kass. All rights reserved.
//

#import "InvitationsConnectionHandler.h"
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
    NSDictionary *resultsDictionary = JSONTodict(self.responseData);
    NSMutableArray* upcoming;
    NSMutableArray* passed;
    if ([resultsDictionary[@"call"] isEqualToString:@"get_meals"]){
      //  NSLog(@"meals");
        upcoming = self.ivc.upcomingMeals;
        passed = self.ivc.passedMeals;
    }
    else{
        upcoming = self.ivc.upcomingInvitations;
        passed = self.ivc.passedInvitations;
    }
    @synchronized(self.ivc.tableLock){
        self.ivc.tableLock = [NSNumber numberWithInt:[self.ivc.tableLock integerValue] + 1];
        [upcoming removeAllObjects];
        [passed removeAllObjects];
        NSLog(@"res dict: %@", resultsDictionary);
        for (NSMutableDictionary* dict in resultsDictionary[@"invitations"]){
            NSLog(@"dict %@", dict );
            Invitation* i = [[Invitation alloc] init:dict[@"id"] timeInput:dict[@"time"] peopleInput:dict[@"people"] messageInput:dict[@"message"] iRespondedInput:[dict[@"iResponded"] boolValue] creatorIndexInput:dict[@"creatorIndex"] responseArrayInput:dict[@"responses"] centralInput:[dict[@"central"] boolValue] preferencesInput:dict[@"preferences"] scheduleTimeInput:dict[@"scheduleTime"] scheduledInput:[dict[@"scheduled"] boolValue] messagesArrayInput:dict[@"messages"]];
            [upcoming addObject:i];
        }
        [self.ivc syncInvitations:[resultsDictionary[@"call"] isEqualToString:@"get_meals"]];
        if ([resultsDictionary[@"call"] isEqualToString:@"get_meals"]){
            [self.ivc.mealsTable reloadData];
        }
        else{
            [self.ivc.invitationsTable reloadData];
        }
        if ([self.ivc.tableLock integerValue] == 2){
            self.ivc.tableLock = [NSNumber numberWithInt:0];
            [self.ivc.spinner stopAnimating];
        }
        
    }

}


- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.responseData appendData:data];
}



@end
