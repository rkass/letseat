//
//  ValidationViewController.m
//  Let's Eat
//
//  Created by Ryan Kass on 2/19/14.
//  Copyright (c) 2014 Ryan Kass. All rights reserved.
//

#import "ValidationViewController.h"
#import "Server.h"

@interface ValidationViewController ()
@property (strong, nonatomic) UIAlertView *duplicateUsername;
@property (strong, nonatomic) UIAlertView *failedLoginAlert;
@end

@implementation ValidationViewController
@synthesize username, password;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (alertView == self.duplicateUsername)
        [self.username becomeFirstResponder];
    
}

- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSMutableData *d = [NSMutableData data];
    [d appendData:data];
    NSString *a = [[NSString alloc] initWithData:d encoding:NSASCIIStringEncoding];
    NSDictionary *responseDict = [Server JSONToDict:a];
    if ([responseDict objectForKey:@"auth_token"])
    {
        [LEViewController setUserDefault:@"auth_token" data:[responseDict objectForKey:@"auth_token"]];
        [LEViewController setUserDefault:@"phone_number" data:[responseDict objectForKey:@"phone_number"]];

        if ([[responseDict objectForKey:@"request"]isEqualToString:@"sign_up" ]){
            [self performSegueWithIdentifier:@"signupToHome" sender:self];
        }
        else if ([[responseDict objectForKey:@"request" ] isEqualToString:@"login" ]){
            [self performSegueWithIdentifier:@"loginToHome" sender:self];
        }
        
    }
    else if ([[responseDict objectForKey:@"request" ] isEqualToString: @"sign_up"]){
        self.duplicateUsername = [[UIAlertView alloc] initWithTitle:@"Oof" message:@"Username already taken." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        [self.duplicateUsername show];
        [self.username becomeFirstResponder];
    }
    else if ([[responseDict objectForKey:@"request"] isEqualToString:@"login"]){;
        self.failedLoginAlert = [[UIAlertView alloc] initWithTitle:@"Oof" message:@"Invalid login credentials." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        [self.failedLoginAlert show];
    }
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSLog(@"prepared");
    //[[UIApplication sharedApplication] keyWindow].rootViewController = segue.destinationViewController;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
