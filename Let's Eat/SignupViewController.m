	//
//  LoginViewController.m
//  Let's Eat
//
//  Created by Ryan Kass on 2/13/14.
//  Copyright (c) 2014 Ryan Kass. All rights reserved.
//

#import "SignupViewController.h"
#import "User.h"
#import "Server.h"

@interface SignupViewController ()
@property (strong, nonatomic) IBOutlet UITextField *phoneNumber;
@property (strong, nonatomic) IBOutlet UIButton *enter;
@property (strong, nonatomic) UIAlertView *phoneAlert;
@property (strong, nonatomic) UIAlertView *usernameAlert;
@property (strong, nonatomic) UIAlertView *passwordAlert;

@property (strong, nonatomic) User *user;
@end

@implementation SignupViewController

@synthesize phoneNumber, username, password, enter, user;

- (void)viewDidLoad
{
    /*TODO
     Resign first responder when background touched
     Validate phone number
     */
    [super viewDidLoad];

    self.phoneNumber.delegate = self;
    self.username.delegate = self;
    self.password.delegate = self;
    [self.phoneNumber becomeFirstResponder];
    self.password.secureTextEntry = YES;
    self.enter.hidden = YES;
    [self.username addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.password addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.enter addTarget:self action:@selector (enterPressed:) forControlEvents:UIControlEventTouchDown];
    
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == phoneNumber){
        NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        NSArray *components = [newString componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]];
        NSString *decimalString = [components componentsJoinedByString:@""];
    
        NSUInteger length = decimalString.length;
        BOOL hasLeadingOne = length > 1 && [decimalString characterAtIndex:0] == '1';
    
        if (length == 0 || (length > 10 && !hasLeadingOne) || (length > 11)) {
            textField.text = decimalString;
            return NO;
        }
    
        NSUInteger index = 0;
        NSMutableString *formattedString = [NSMutableString string];
    
        if (hasLeadingOne) {
            [formattedString appendString:@"1 "];
            index += 1;
        }
    
        if (length - index > 3) {
            NSString *areaCode = [decimalString substringWithRange:NSMakeRange(index, 3)];
            [formattedString appendFormat:@"(%@) ",areaCode];
            index += 3;
        }
    
        if (length - index > 3) {
            NSString *prefix = [decimalString substringWithRange:NSMakeRange(index, 3)];
            [formattedString appendFormat:@"%@-",prefix];
            index += 3;
        }
    
        NSString *remainder = [decimalString substringFromIndex:index];
        [formattedString appendString:remainder];
    
        textField.text = formattedString;
    
        return NO;
    }
    return YES;
}

- (BOOL)validateUsername
{
    return [username.text length] != 0;
}
- (NSString*)getRawNumber
{
    return [[[[phoneNumber.text stringByReplacingOccurrencesOfString:@"(" withString:@""]stringByReplacingOccurrencesOfString:@")" withString:@""] stringByReplacingOccurrencesOfString:@"-" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""];
}
- (BOOL)validatePhoneNumber
{
    NSString *rawNumber = [self getRawNumber];
    return ([rawNumber length] == 10 && (![[NSString stringWithFormat:@"%C",[rawNumber characterAtIndex:0]]isEqualToString:@"1"])) || ([rawNumber length] == 11 && [[NSString stringWithFormat:@"%C",[rawNumber characterAtIndex:0]]isEqualToString:@"1"]);
}
-(BOOL)validatePassword
{
    return [password.text length] != 0;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if (textField == phoneNumber) {
        [username becomeFirstResponder];
    } else if (textField == username) {
        [password becomeFirstResponder];
    }
    else if (textField == password){
        [self enterPressed:enter];
    }
    return YES;
}
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (alertView == self.phoneAlert)
        [self.phoneNumber becomeFirstResponder];
    else if (alertView == self.usernameAlert)
        [self.username becomeFirstResponder];
    else if (alertView == self.passwordAlert)
        [self.password becomeFirstResponder];
}
-(void)enterPressed:(UIButton *)button
{
    if (![self validatePhoneNumber])
    {
        self.phoneAlert = [[UIAlertView alloc] initWithTitle:@"Oof" message:@"Please enter a valid phone number." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        [self.phoneAlert show];
        return;
    }
    if (![self validateUsername])
    {
        self.usernameAlert = [[UIAlertView alloc] initWithTitle:@"Oof" message:@"Please enter a username." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        [self.usernameAlert show];
        return;
    }
    if (![self validatePassword])
    {
        self.passwordAlert = [[UIAlertView alloc] initWithTitle:@"Oof" message:@"Please enter a password." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        [self.passwordAlert show];
        return;
    }
    [User createAccount:[self getRawNumber] usernameAttempt:self.username.text password:self.password.text source:self];
    
}/*
- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSMutableData *d = [NSMutableData data];
    [d appendData:data];
    NSString *a = [[NSString alloc] initWithData:d encoding:NSASCIIStringEncoding];
    NSDictionary *responseDict = [Server JSONToDict:a];
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
    }
}

*/
- (void)textFieldDidChange:(UITextField *)textField
{
    if ([self.username.text length] && [self.password.text length] && [self.phoneNumber.text length]){
        self.enter.hidden = NO;
    }
    else{
        self.enter.hidden = YES;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
