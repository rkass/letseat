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
#import "LEViewController.h"

@implementation InviteTransitionConnectionHandler

@synthesize segue, ivc, responseData;
-(id)initWithInvitationsViewController:(InvitationsViewController*)ivcInput segueInput:(NSString*)segueInput{
    self = [super init];
    self.ivc = ivcInput;
    self.responseData = [[NSMutableData alloc] initWithLength:0];
    self.segue = segueInput;
    //NSLog(@"ivcs location: %@", self.ivc.myLocation);
    //self.myLocation = self.ivc.myLocation;
    return self;
}
-(id)initWithNav:(CreateMealNavigationController*)cmInput{
    self = [super init];
    self.nav = cmInput;
    self.responseData = [[NSMutableData alloc] initWithLength:0];
    return self;
}
-(id)initWithInvitateViewController:(InviteViewController*)ivcInput{
    self = [super init];
    self.invitevc = ivcInput;
    self.responseData = [[NSMutableData alloc] initWithLength:0];
    //self.myLocation = self.invitevc.myLocation;
    return self;
}
- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.responseData appendData:data];
}

+(Invitation*)loadInvitation:(NSDictionary*)resultsDictionary locationInput:(CLLocation*)locationInput
{
    Invitation* i = [[Invitation alloc] init:resultsDictionary[@"invitation"][@"id"] timeInput:resultsDictionary[@"invitation"][@"time"] peopleInput:resultsDictionary[@"invitation"][@"people"] messageInput:resultsDictionary[@"invitation"][@"message"] iRespondedInput:[resultsDictionary[@"invitation"][@"iResponded"] boolValue] creatorIndexInput:resultsDictionary[@"invitation"][@"creatorIndex"] responseArrayInput:resultsDictionary[@"invitation"][@"responses"] centralInput:[resultsDictionary[@"invitation"][@"central"] boolValue] preferencesInput:resultsDictionary[@"invitation"][@"preferences"] scheduleTimeInput:resultsDictionary[@"invitation"][@"scheduleTime"] scheduledInput:[resultsDictionary[@"invitation"][@"scheduled"] boolValue] messagesArrayInput:resultsDictionary[@"invitation"][@"messages"]];
    for (NSMutableDictionary* rest in resultsDictionary[@"invitation"][@"restaurants"]){
        [i.restaurants addObject:[[Restaurant alloc] init:rest[@"address"] nameInput:rest[@"name"] percentMatchInput:rest[@"percentMatch"] priceInput:rest[@"price"] ratingImgInput:rest[@"rating_img"] snippetImgInput:rest[@"snippet_img"] votesInput:rest[@"votes"] typesInput:rest[@"types_list"] iVotedInput:[rest[@"user_voted"] boolValue] urlInput:rest[@"url"] myLocationInput:LEViewController.myLocation invitationInput:i.num]];
    }
    
    i.updatingRecommendations = [resultsDictionary[@"invitation"][@"updatingRecommendations"] integerValue];
    return i;
    
}
- (void)connectionDidFinishLoading:(NSURLConnection*)connection
{
    NSDictionary *resultsDictionary = [self.responseData objectFromJSONData];
    if ([resultsDictionary[@"success"] boolValue]){
        
        
        Invitation* i = [InviteTransitionConnectionHandler loadInvitation:resultsDictionary locationInput:self.myLocation];
        [LEViewController setUserDefault:@"mealsPressed" data:[NSNumber numberWithBool:i.scheduled]];
        NSLog(@"id: %d", i.num);
        if (self.nav){
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            InviteViewController* iv = (InviteViewController*)[storyboard instantiateViewControllerWithIdentifier:@"Invite"];
            iv.invitation = i;
            iv.restsPressed = NO;
            [self.nav pushViewController:iv animated:NO];
        }
        else if (self.ivc){
            self.ivc.transitionInvitation = i;
            [self.ivc performSegueWithIdentifier:self.segue sender:self.ivc];
        }
        else{
            self.invitevc.invitation = i;
            [self.invitevc layoutView];
            NSLog(@"laying out view... with invitation scheduled %hhd", self.invitevc.invitation.scheduled);
        }
    }
}
@end
