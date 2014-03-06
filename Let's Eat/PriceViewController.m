//
//  PriceViewController.m
//  Let's Eat
//
//  Created by Ryan Kass on 2/27/14.
//  Copyright (c) 2014 Ryan Kass. All rights reserved.
//

#import "PriceViewController.h"
#import "WhereViewController.h"
#import "WhoViewController.h"
#import "WhenViewController.h"
#import "WhatViewController.h"
#import "InviteViewController.h"
#import "CreateMealNavigationController.h"
#import "User.h"
#import "JSONKit.h"

@interface PriceViewController ()
@property (strong, nonatomic) IBOutlet UISlider *slider;
@property (strong, nonatomic) IBOutlet UILabel *label;
@property (strong, nonatomic) IBOutlet UITextView *myUITextView;

@end

@implementation PriceViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Price";
    self.label.text = @"$";
    self.myUITextView.delegate = self;
    self.myUITextView.text = @"Include an optional message with your invitation";
    self.myUITextView.textColor = [UIColor lightGrayColor];
    CreateMealNavigationController* cmnc = (CreateMealNavigationController*) self.navigationController;
    if (!cmnc.creator)
        [self.myUITextView removeFromSuperview];

}
- (IBAction)valueChanged:(id)sender {
    if (self.slider.value < 1)
        self.label.text = @"$";
    else if (self.slider.value < 2)
        self.label.text = @"$$";
    else if (self.slider.value < 3)
        self.label.text = @"$$$";
    else if (self.slider.value < 4)
        self.label.text = @"$$$$";
    else if (self.slider.value < 5)
        self.label.text = @"$$$$$";
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UIView * txt in self.view.subviews){
        if (([txt isKindOfClass:[UITextField class]] || [txt isKindOfClass:[UITextView class]]) && [txt isFirstResponder]) {
            [txt resignFirstResponder];
        }
    }
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        [self createInvitation:textView];
        return YES;
    }

    return textView.text.length + (text.length - range.length) <= 140;
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"Include an optional message with your invitation"]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor]; //optional
    }
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"Include an optional message with your invitation";
        textView.textColor = [UIColor lightGrayColor]; //optional
    }
    [textView resignFirstResponder];
}

-(NSMutableDictionary*)getPreferences{
    NSMutableDictionary* ret = [[NSMutableDictionary alloc] init];
    int startingIndex = [[self.navigationController viewControllers] count] - 3;
    WhereViewController* wherevc = (WhereViewController*)[[self.navigationController viewControllers] objectAtIndex:startingIndex];
    [ret setObject:[NSString stringWithFormat:@"%f,%f", wherevc.myLocation.coordinate.latitude, wherevc.myLocation.coordinate.longitude]  forKey:@"location"];
    WhatViewController* whatvc = (WhatViewController*)[[self.navigationController viewControllers] objectAtIndex:startingIndex + 1];
    [ret setObject:whatvc.wantItems forKey:@"foodList"];
    [ret setObject:[NSNumber numberWithInt:floor(self.slider.value)] forKey:@"price"];
    return ret;
}

-(NSMutableDictionary*)getCreatorPreferences{
    NSMutableDictionary* ret = [self getPreferences];
    WhenViewController* whenvc = (WhenViewController*) [self.navigationController.viewControllers objectAtIndex:1];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"cccc, MMM d, hh:mm aa"];
    [ret setObject:[dateFormat stringFromDate:whenvc.when.date] forKey:@"date"];
    WhoViewController* whovc = (WhoViewController*)[self.navigationController.viewControllers objectAtIndex:2];
    NSMutableArray* numbers = [[NSMutableArray alloc] init];
    for (NSMutableDictionary* dict in whovc.friends){
        if ([dict[@"checked"]  isEqual: @YES]){
            for (NSString* number in dict[@"numbers"])
                [numbers addObject:number];
        }
    }
    [ret setObject:numbers forKey:@"numbers"];
    NSString* message = @"";
    if (![self.myUITextView.text  isEqualToString: @"Include an optional message with your invitation"])
        message = self.myUITextView.text;
    [ret setObject:message forKey:@"message"];
    return ret;
}
- (IBAction)createInvitation:(id)sender {
    CreateMealNavigationController* cmnc = (CreateMealNavigationController*) self.navigationController;
    if (cmnc.creator)
        [User createInvitation:[self getCreatorPreferences] source:self];
        
    else{
        InviteViewController* ivc = (InviteViewController*)[self.navigationController viewControllers][[[self.navigationController viewControllers] count] -4];
        [User respondYes:ivc.invitation.num preferences:[self getPreferences] source:self];
    }
}

- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSDictionary *resultsDictionary = [data objectFromJSONData];
    if ([resultsDictionary[@"success"] isEqual: @YES]){
        [self performSegueWithIdentifier:@"priceToHome" sender:self];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
