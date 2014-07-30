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
#import "FacebookLoginViewManager.h"
@interface LoginViewController ()
@property (strong, nonatomic) IBOutlet UITextField *username;
@property (strong, nonatomic) UIAlertView *phoneAlert;
@property (strong, nonatomic) IBOutlet UITextField *password;
@property (strong, nonatomic) IBOutlet UIButton *enter;
@property (strong, nonatomic) IBOutlet UIButton *registerButton;
@property (strong, nonatomic) UIAlertView *usernameAlert;
@property (strong, nonatomic) IBOutlet UITextView *phoneNumberTextView;
@property (strong, nonatomic) UIAlertView *passwordAlert;
@property (strong, nonatomic) User *user;
@property (strong, nonatomic) NSMutableData *d;

@end

@implementation LoginViewController
@synthesize username, password, enter;

- (void)viewDidLoad
{

    [super viewDidLoad];
    //[self.view setBackgroundColor:[UIColor colorWithPatternImage:GET_IMG(@"bg")]];
    [self.phoneNumberTextView setBackgroundColor:[UIColor colorWithPatternImage:GET_IMG(@"input")]];
    [self.phoneNumberTextView setDelegate:self];
    [self.phoneNumberTextView setText:@"Phone Number"];
    [self.phoneNumberTextView setTextColor:[UIColor lightGrayColor]];
    [self displayRegister];
    self.d = [[NSMutableData alloc] initWithLength:0];
    [LEViewController setUserDefault:@"getFriends" data:[NSNumber numberWithInt:0] ];
    [LEViewController setUserDefault:@"noConnectionAlertShowing" data:[NSNumber numberWithInteger:0]];
	// Do any additional setup after loading the view.
     self.view.backgroundColor = [UIColor whiteColor];
    [FacebookLoginViewManager sharedManager].currVC = self;
    self.fblv = [FacebookLoginViewManager sharedManager].fblv;
    // Align the button in the center horizontally
    self.fblv.frame = CGRectOffset(self.fblv.frame, (self.view.center.x - (self.fblv.frame.size.width / 2)), 400);
    [self.view addSubview:self.fblv];
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        [self.labia setHidden:YES];
        [self.bluearrow setHidden:YES];
        [self.orme setHidden:YES];
        [self.registerButton setHidden:YES];
        [self.phoneNumber setHidden:YES];
        [self.phoneNumberTextView setHidden:YES];
    }
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
}
-(void)dismissKeyboard {
    [self.phoneNumberTextView resignFirstResponder];
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if (textView == self.phoneNumberTextView){
        NSString *newString = [textView.text stringByReplacingCharactersInRange:range withString:text];
        NSArray *components = [newString componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]];
        NSString *decimalString = [components componentsJoinedByString:@""];
        
        NSUInteger length = decimalString.length;
        BOOL hasLeadingOne = length > 1 && [decimalString characterAtIndex:0] == '1';
        
        if (length == 0 || (length > 10 && !hasLeadingOne) || (length > 11)) {
            textView.text = decimalString;
            [self displayRegister];
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
        
        textView.text = formattedString;
        [self displayRegister];
        return NO;
        
    }
    [self displayRegister];
    return YES;
}
- (NSString*)getRawNumber
{
    return [[[[self.phoneNumberTextView.text stringByReplacingOccurrencesOfString:@"(" withString:@""]stringByReplacingOccurrencesOfString:@")" withString:@""] stringByReplacingOccurrencesOfString:@"-" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""];
}
- (BOOL)validatePhoneNumber
{
    NSString *rawNumber = [self getRawNumber];
    return ([rawNumber length] == 10 && (![[NSString stringWithFormat:@"%C",[rawNumber characterAtIndex:0]]isEqualToString:@"1"])) || ([rawNumber length] == 11 && [[NSString stringWithFormat:@"%C",[rawNumber characterAtIndex:0]]isEqualToString:@"1"]);
}
- (IBAction)registerPressed:(id)sender {
    if (![self validatePhoneNumber])
    {
        self.phoneAlert = [[UIAlertView alloc] initWithTitle:@"Oof" message:@"Please enter a valid phone number." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [self.phoneAlert show];
        return;
    }
    else{
        NSNumber* requests = [[NSUserDefaults standardUserDefaults] objectForKey:@"requests"];
        [LEViewController setUserDefault:@"requests" data:[NSNumber numberWithInt:[requests intValue] + 1]];
        if ([requests intValue] < 100){
       [User createAccount:[self getRawNumber] usernameAttempt:@"" password:@"" source:self];
        [self.phoneNumberTextView resignFirstResponder];
            [self loadingScreen];}
    }
    
}
-(void)connectionDidFinishLoading:(NSURLConnection*)connection{

    [self unloadScreen];
    NSDictionary* resultsDictionary = JSONTodict(self.d);
    self.d = [[NSMutableData alloc] initWithLength:0];
    NSLog(@"resultsDictionary: %@", resultsDictionary);
    if ([resultsDictionary[@"request"] isEqualToString:@"sign_upfb"]){
        [LEViewController setUserDefault:@"username" data:resultsDictionary[@"username"]];
        [LEViewController setUserDefault:@"auth_token" data:resultsDictionary[@"auth_token"]];
        NSLog(@"setting facebook id user default");
        [LEViewController setUserDefault:@"facebook_id" data:resultsDictionary[@"facebook_id"]];
        [self performSegueWithIdentifier:@"loginToHome" sender:self];
    }
    else{
        [LEViewController setUserDefault:@"username" data:resultsDictionary[@"username"]];
        UIAlertView* av = [[UIAlertView alloc] initWithTitle:@"We sent you a text" message:@"Click the link in the text to validate your phone number" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [av show];
    }

}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [self.d appendData:data];
}
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (alertView == self.phoneAlert)
        [self.phoneNumber becomeFirstResponder];
}

- (void)displayRegister
{

    if (self.phoneNumberTextView.text.length && (!([self.phoneNumberTextView.text isEqualToString: @"Phone Number"])))
       [self.registerButton setHidden:NO];
    else
        [self.registerButton setHidden:YES];
}
-(void)textViewDidBeginEditing:(UITextView *)textView{
    if ([textView.text isEqualToString:@"Phone Number"])
        textView.text = @"";
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
