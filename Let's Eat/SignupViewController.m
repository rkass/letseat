	//
//  LoginViewController.m
//  Let's Eat
//
//  Created by Ryan Kass on 2/13/14.
//  Copyright (c) 2014 Ryan Kass. All rights reserved.
//

#import "SignupViewController.h"
#import "User.h"

@interface SignupViewController ()
@property (strong, nonatomic) IBOutlet UITextField *phoneNumber;
@property (strong, nonatomic) IBOutlet UITextField *username;
@property (strong, nonatomic) IBOutlet UITextField *password;
@property (strong, nonatomic) IBOutlet UIButton *enter;
@end

@implementation SignupViewController

@synthesize phoneNumber;
@synthesize username;
@synthesize password;
@synthesize enter;

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
- (BOOL)validatePhoneNumber
{
    NSString *rawNumber = [[[[phoneNumber.text stringByReplacingOccurrencesOfString:@"(" withString:@""]stringByReplacingOccurrencesOfString:@")" withString:@""] stringByReplacingOccurrencesOfString:@"-" withString:@""]
        stringByReplacingOccurrencesOfString:@" " withString:@""];
    return ([rawNumber length] == 10) || ([rawNumber length] == 11 && [rawNumber characterAtIndex:0] == 1);
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

-(void)enterPressed:(UIButton *)button
{
    [self validatePhoneNumber];
    User* user = [[User alloc] init];
    [user createAccount:self.phoneNumber.text username:self.username.text password:self.password.text];
    
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
