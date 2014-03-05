//
//  LoginViewController.m
//  Let's Eat
//
//  Created by Ryan Kass on 2/17/14.
//  Copyright (c) 2014 Ryan Kass. All rights reserved.
//

#import "LoginViewController.h"
#import "User.h"
#import "Server.h"

@interface LoginViewController ()
@property (strong, nonatomic) IBOutlet UITextField *username;
@property (strong, nonatomic) IBOutlet UITextField *password;
@property (strong, nonatomic) IBOutlet UIButton *enter;
@property (strong, nonatomic) UIAlertView *usernameAlert;
@property (strong, nonatomic) UIAlertView *passwordAlert;
@property (strong, nonatomic) User *user;
@end

@implementation LoginViewController
@synthesize username, password, enter;

- (void)viewDidLoad
{

    [super viewDidLoad];
    self.username.delegate = self;
    self.password.delegate = self;
    self.enter.hidden = YES;
    [self.username becomeFirstResponder];
    self.password.secureTextEntry = YES;
    [self.username addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.password addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.enter addTarget:self action:@selector (enterPressed:) forControlEvents:UIControlEventTouchDown];
	// Do any additional setup after loading the view.
}
- (BOOL)validateUsername
{
    return [username.text length] != 0;
}
-(BOOL)validatePassword
{
    return [password.text length] != 0;
}

-(void)enterPressed:(UIButton *)button
{
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
    [User login:self.username.text password:self.password.text source:self];
    
}

- (void)textFieldDidChange:(UITextField *)textField
{
    if ([self.username.text length] && [self.password.text length]){
        self.enter.hidden = NO;
    }
    else{
        self.enter.hidden = YES;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if (textField == username) {
        [password becomeFirstResponder];
    }
    else if (textField == password){
        [self enterPressed:enter];
    }
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end