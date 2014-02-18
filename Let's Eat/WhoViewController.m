//
//  WhoViewController.m
//  Let's Eat
//
//  Created by Ryan Kass on 2/18/14.
//  Copyright (c) 2014 Ryan Kass. All rights reserved.
//

#import "WhoViewController.h"
#import "Server.h"
#import "User.h"

@interface WhoViewController ()

@end

@implementation WhoViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    [User getFriends:self];
    
}
- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSMutableData *d = [NSMutableData data];
    [d appendData:data];
    NSString *a = [[NSString alloc] initWithData:d encoding:NSASCIIStringEncoding];
    NSDictionary *responseDict = [Server JSONToDict:a];
    NSLog(@"responseDict %@", responseDict);/*
    if ([responseDict objectForKey:@"auth_token"] != 0)
    {
        self.user.auth_token = [responseDict objectForKey:@"auth_token"];
        self.user.username = [responseDict objectForKey:@"username"];
        [LEViewController setUserDefault:@"auth_token" data:self.user.auth_token];
        [LEViewController setUserDefault:@"username" data:self.user.username];
        [self performSegueWithIdentifier:@"signupToHome" sender:self];
    }
    else{
        self.duplicateUsernameAlert = [[UIAlertView alloc] initWithTitle:@"Oof" message:@"Username already taken." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        [self.duplicateUsernameAlert show];
    }*/
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
