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

@interface PriceViewController ()
@property (strong, nonatomic) IBOutlet UISlider *slider;
@property (strong, nonatomic) IBOutlet UILabel *label;
@property (strong, nonatomic) IBOutlet UITextView *myUITextView;
@property BOOL creator;

@end

@implementation PriceViewController

@synthesize creator;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Price";
    self.label.text = @"$";
    self.myUITextView.delegate = self;
    self.myUITextView.text = @"Include an optional message with your invitation";
    self.myUITextView.textColor = [UIColor lightGrayColor];
    self.creator = YES;
    if ([[self.navigationController.viewControllers objectAtIndex:1] isKindOfClass:[WhereViewController class]])
    {
        [self.myUITextView removeFromSuperview];
        self.creator = NO;
    }
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
    else
        self.label.text = @"$$$$$";
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UIView * txt in self.view.subviews){
        if (([txt isKindOfClass:[UITextField class]] || [txt isKindOfClass:[UITextView class]]) && [txt isFirstResponder]) {
            [txt resignFirstResponder];
        }
    }
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    NSLog(@"here");
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
    int startingIndex = 1;
    if (self.creator)
        startingIndex = 3;
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
    [ret setObject:whenvc.when.date forKey:@"date"];
    WhoViewController* whovc = (WhoViewController*)[self.navigationController.viewControllers objectAtIndex:2];
    NSMutableArray* numbers = [[NSMutableArray alloc] init];
    for (NSMutableDictionary* dict in whovc.friends){
        for (NSString* number in dict[@"numbers"])
            [numbers addObject:number];
    }
    [ret setObject:numbers forKey:@"numbers"];
    return ret;
}
- (IBAction)createInvitation:(id)sender {
    if (self.creator){
        NSMutableDictionary* creatorPreferences = [self getCreatorPreferences];
        
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    [self createInvitation:textField];
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
