//
//  PriceViewController.m
//  Let's Eat
//
//  Created by Ryan Kass on 2/27/14.
//  Copyright (c) 2014 Ryan Kass. All rights reserved.
//

#import "PriceViewController.h"
#import "WhereViewController.h"

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
    if ([[self.navigationController.viewControllers objectAtIndex:1] isKindOfClass:[WhereViewController class]])
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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
