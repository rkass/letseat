//
//  InviteTransitionConnectionHandler.m
//  Let's Eat
//
//  Created by Ryan Kass on 4/4/14.
//  Copyright (c) 2014 Ryan Kass. All rights reserved.
//

#import "InviteTransitionConnectionHandler.h"
#import "InviteViewController.h"
#import "JSONKit.h"
#import "Invitation.h"
#import "Restaurant.h"

@implementation InviteTransitionConnectionHandler
@synthesize segue, ivc, responseData;
-(id)initWithInvitationsViewController:(InvitationsViewController*)ivcInput segueInput:(NSString*)segueInput{
    self = [super init];
    self.ivc = ivcInput;
    self.responseData = [[NSMutableData alloc] initWithLength:0];
    self.segue = segueInput;
    return self;
}
-(id)initWithInvitateViewController:(InviteViewController*)ivcInput{
    self = [super init];
    self.invitevc = ivcInput;
    self.responseData = [[NSMutableData alloc] initWithLength:0];
    return self;
}
- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.responseData appendData:data];
}
- (void)connectionDidFinishLoading:(NSURLConnection*)connection
{
    NSDictionary *resultsDictionary = [self.responseData objectFromJSONData];
    if ([resultsDictionary[@"success"] boolValue]){
        NSLog(@"dict: %@", resultsDictionary);
        Invitation* i = [[Invitation alloc] init:resultsDictionary[@"invitation"][@"id"] timeInput:resultsDictionary[@"invitation"][@"time"] peopleInput:resultsDictionary[@"invitation"][@"people"] messageInput:resultsDictionary[@"invitation"][@"message"] iRespondedInput:[resultsDictionary[@"invitation"][@"iResponded"] boolValue] creatorIndexInput:resultsDictionary[@"invitation"][@"creatorIndex"] responseArrayInput:resultsDictionary[@"invitation"][@"responses"] centralInput:[resultsDictionary[@"invitation"][@"central"] boolValue] preferencesInput:resultsDictionary[@"invitation"][@"preferences"] scheduleTimeInput:resultsDictionary[@"invitation"][@"scheduleTime"] scheduledInput:[resultsDictionary[@"invitation"][@"scheduled"] boolValue] messagesArrayInput:resultsDictionary[@"invitation"][@"messages"]];
        for (NSMutableDictionary* rest in resultsDictionary[@"invitation"][@"restaurants"])
            [i.restaurants addObject:[[Restaurant alloc] init:rest[@"address"] nameInput:rest[@"name"] percentMatchInput:rest[@"percentMatch"] priceInput:rest[@"price"] ratingImgInput:rest[@"rating_img"] snippetImgInput:rest[@"snippet_img"] votesInput:rest[@"votes"] typesInput:rest[@"types_list"] iVotedInput:[rest[@"user_voted"] boolValue] urlInput:rest[@"url"] myLocationInput:self.ivc.myLocation invitationInput:i.num]];

        i.updatingRecommendations = [resultsDictionary[@"invitation"][@"updatingRecommendations"] integerValue];
        
        NSLog(@"id: %d", i.num);
        if (self.ivc){
            self.ivc.transitionInvitation = i;
            [self.ivc performSegueWithIdentifier:self.segue sender:self.ivc];
        }
        else{
            self.invitevc.invitation = i;
            [self.invitevc layoutView];
        }
    }
}
@end
