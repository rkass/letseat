//
//  InviteTransitionConnectionHandler.m
//  Let's Eat
//
//  Created by Ryan Kass on 4/4/14.
//  Copyright (c) 2014 Ryan Kass. All rights reserved.
//

#import "InviteTransitionConnectionHandler.h"
#import "InviteViewController.h"
#import "Invitation.h"
#import "Restaurant.h"
#import "LEViewController.h"
#import "AppDelegate.h"
#import "NoConnectionAlertDelegate.h"
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
    NSLog(@"creatorIndex in: %@", resultsDictionary);
    Invitation* i = [[Invitation alloc] init:resultsDictionary[@"invitation"][@"id"] timeInput:resultsDictionary[@"invitation"][@"time"] peopleInput:resultsDictionary[@"invitation"][@"people"] messageInput:resultsDictionary[@"invitation"][@"message"] iRespondedInput:[resultsDictionary[@"invitation"][@"iResponded"] boolValue] creatorIndexInput:resultsDictionary[@"invitation"][@"creatorIndex"] responseArrayInput:resultsDictionary[@"invitation"][@"responses"] centralInput:[resultsDictionary[@"invitation"][@"central"] boolValue] preferencesInput:resultsDictionary[@"invitation"][@"preferences"] scheduleTimeInput:resultsDictionary[@"invitation"][@"scheduleTime"] scheduledInput:[resultsDictionary[@"invitation"][@"scheduled"] boolValue] messagesArrayInput:resultsDictionary[@"invitation"][@"messages"]];
    for (NSMutableDictionary* rest in resultsDictionary[@"invitation"][@"restaurants"]){
        [i.restaurants addObject:[[Restaurant alloc] init:rest[@"address"] nameInput:rest[@"name"] percentMatchInput:rest[@"percent_match"] priceInput:rest[@"price"] ratingImgInput:rest[@"rating_img"] snippetImgInput:rest[@"snippet_img"] votesInput:rest[@"votes"] typesInput:rest[@"types_list"] iVotedInput:[rest[@"user_voted"] boolValue] urlInput:rest[@"url"] myLocationInput:LEViewController.myLocation invitationInput:i.num]];
           NSLog(@"types %@", rest[@"types_list"]);
    }
 
    i.updatingRecommendations = [resultsDictionary[@"invitation"][@"updatingRecommendations"] integerValue];
    return i;
    
}
- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"noConnectionAlertShowing"] integerValue] == 0){
        [LEViewController setUserDefault:@"noConnectionAlertShowing" data:[NSNumber numberWithInteger:1]];
        self.noConnectionAppDelegate = [[NoConnectionAlertDelegate alloc] init];
        self.failedConnection = [[UIAlertView alloc] initWithTitle:@"Oof" message:@"Couldn't connect to the server.  Check your connection and try again." delegate:self.noConnectionAppDelegate cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [self.failedConnection show];
        if (self.ivc)
            [self.ivc unloadScreen];
        else if (self.invitevc)
            [self.invitevc unloadScreen];
        
    }
}
  /*
    LEViewController* lvc;
    if (self.ivc)
        lvc = self.ivc;
    else if (self.invitevc)
        lvc = self.invitevc;
    if ((!self.conn || (self.conn != connection)) && (!lvc.alertShowing)){
        self.failedConnection = [[UIAlertView alloc] initWithTitle:@"Oof" message:@"Couldn't connect to the server.  Check your connection and try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        if (self.ivc)
            [self.ivc unloadScreen];
        else if (self.invitevc)
            [self.invitevc unloadScreen];
        lvc.alertShowing = YES;
        [self.failedConnection show];

    }
    self.conn = connection;
   */

- (void)connectionDidFinishLoading:(NSURLConnection*)connection
{
    NSLog(@"conn finsihed hheerrre");
    NSDictionary *resultsDictionary = JSONTodict(self.responseData);
    self.responseData = [[NSMutableData alloc] initWithLength:0];
    LEViewController* lvc = self.ivc;
    if (!lvc)
        lvc = self.invitevc;
    badLogin(resultsDictionary, lvc);
    NSLog(@"results dict %@", resultsDictionary);
    if ([resultsDictionary[@"success"] boolValue]){
        
        
        Invitation* i = [InviteTransitionConnectionHandler loadInvitation:resultsDictionary locationInput:self.myLocation];
        [LEViewController setUserDefault:@"mealsPressed" data:[NSNumber numberWithBool:i.scheduled]];
        NSLog(@"id: %d", i.num);
        if (self.delegate){
            NSLog(@"inside this one");
            [self.delegate.blocker removeFromSuperview];
        }
        if (self.nav){
            NSLog(@"this one no");
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            InviteViewController* iv = (InviteViewController*)[storyboard instantiateViewControllerWithIdentifier:@"Invite"];
            iv.invitation = i;
            iv.restsPressed = NO;
            [self.nav pushViewController:iv animated:NO];
        }
        else if (self.ivc){
            NSLog(@"actually this one");
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
