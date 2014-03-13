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
#import "WhatViewController.h"
#import "InviteViewController.h"
#import "CreateMealNavigationController.h"
#import "User.h"
#import "JSONKit.h"
#import "Graphics.h"

@interface PriceViewController ()


@property (strong, nonatomic) IBOutlet UIImageView *white;
@property (strong, nonatomic) UIButton *thumb1;
@property (strong, nonatomic) IBOutlet UIImageView *sliderBackdrop;
@property (strong, nonatomic) IBOutlet UISwitch *locSwitch;
@property (strong, nonatomic) UIImageView* sliderFill;
@property (strong, nonatomic) UIButton *thumb2;
@property (strong, nonatomic) IBOutlet UILabel *ppp;
@property CGRect sliderPosition;
@property float sliderMaxX;
@property float sliderMinX;
@property (strong, nonatomic) IBOutlet UITextField *locationField;
@property float sliderMin;
@property float sliderMax;
@end

@implementation PriceViewController

@synthesize white, thumb1, thumb2, sliderBackdrop, sliderPosition, sliderMaxX, sliderMinX, sliderMax, sliderMin, sliderFill, ppp, locSwitch, locationField;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Price";
    self.locSwitch.onTintColor = [Graphics colorWithHexString:@"ffa500"];
    self.locationField.delegate = self;
   // self.myUITextView.delegate = self;
   // self.myUITextView.text = @"Include an optional message with your invitation";
   // self.myUITextView.textColor = [UIColor lightGrayColor];
    CreateMealNavigationController* cmnc = (CreateMealNavigationController*) self.navigationController;
    if (!cmnc.creator){}
      //  [self.myUITextView removeFromSuperview];
    UIImage *backImg = [UIImage imageNamed:@"BackBrownCarrot"];
    //UIImage* homeImg = [Graphics makeThumbnailOfSize:bigImage size:CGSizeMake(37,22)];
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    back.bounds = CGRectMake( 0, 0, backImg.size.width, backImg.size.height );
    [back setImage:backImg forState:UIControlStateNormal];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:back];
    [back addTarget:self action:@selector(backPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = backItem;
    UIImage *bigImage = [UIImage imageNamed:@"Home"];
    UIImage* homeImg = [Graphics makeThumbnailOfSize:bigImage size:CGSizeMake(30,30)];
    UIButton *home = [UIButton buttonWithType:UIButtonTypeCustom];
    home.bounds = CGRectMake( 0, 0, homeImg.size.width, homeImg.size.height );
    [home setImage:homeImg forState:UIControlStateNormal];
    UIBarButtonItem *homeItem = [[UIBarButtonItem alloc] initWithCustomView:home];
    [home addTarget:self action:@selector(homePressed:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = homeItem;
    self.view.backgroundColor = [Graphics colorWithHexString:@"f5f0df"];
    
    UIImage *thumb = [UIImage imageNamed:@"Thumb"];
    self.sliderMaxX = self.sliderBackdrop.frame.origin.x + self.sliderBackdrop.frame.size.width - thumb.size.width/2;
    self.sliderMinX = self.sliderBackdrop.frame.origin.x - thumb.size.width/2;
    self.thumb1 = [[UIButton alloc] initWithFrame:CGRectMake(self.sliderMinX, self.sliderBackdrop.frame.origin.y + self.sliderBackdrop.frame.size.height/2 - thumb.size.height/2,thumb.size.width, thumb.size.height)];
    self.sliderMin = self.sliderMinX;
    self.sliderMax = self.sliderMaxX;
    [self.thumb1 setImage:thumb forState:UIControlStateNormal];
    self.thumb2 = [[UIButton alloc] initWithFrame:CGRectMake(self.sliderMaxX, self.sliderBackdrop.frame.origin.y + self.sliderBackdrop.frame.size.height/2 - thumb.size.height/2 ,thumb.size.width, thumb.size.height)];
    [self.thumb2 setImage:thumb forState:UIControlStateNormal];
    
    UIImage *sliderFillImg = [UIImage imageNamed:@"SliderFill"];
    self.sliderFill = [[UIImageView alloc] initWithImage:sliderFillImg];
    [self.thumb1 addTarget:self action:@selector(wasDragged:withEvent:)
     forControlEvents:UIControlEventTouchDragInside];
    [self.thumb2 addTarget:self action:@selector(wasDragged:withEvent:)
          forControlEvents:UIControlEventTouchDragInside];
    self.locationField.hidden = YES;
    [self setPppText];
    [self setSliderFillFrame];
    [self.view addSubview:self.sliderFill];
    [self.view addSubview:self.thumb2];
    [self.view addSubview:self.thumb1];
    [self.view bringSubviewToFront:self.thumb1];
    [self.view bringSubviewToFront:self.thumb2];
    [self.view sendSubviewToBack:self.white];


}

-(void) setPppText{
    int min = roundf((self.sliderMin - self.sliderMinX) / (self.sliderMaxX - self.sliderMinX) * 60) + 10;
    int max = roundf((self.sliderMax - self.sliderMinX) / (self.sliderMaxX - self.sliderMinX) * 60) + 10;
    self.ppp.text = [NSString stringWithFormat:@"$%d - $%d", min, max];
    
}

- (void)wasDragged:(UIButton *)button withEvent:(UIEvent *)event
{
	// get the touch
	UITouch *touch = [[event touchesForView:button] anyObject];
    
	// get delta
	CGPoint point = [touch locationInView:nil];
    float x = point.x;
    if (x < self.sliderMinX + (button.imageView.image.size.width/2))
        x = self.sliderMinX + (button.imageView.image.size.width/2);
    else if (x > self.sliderMaxX + (button.imageView.image.size.width/2))
        x = self.sliderMaxX + (button.imageView.image.size.width/2);
    button.center = CGPointMake(x, button.center.y);
    if (self.thumb2.frame.origin.x < self.thumb1.frame.origin.x){
        self.sliderMin = self.thumb2.frame.origin.x;
        self.sliderMax = self.thumb1.frame.origin.x;
    }
    else {
        self.sliderMin = self.thumb1.frame.origin.x;
        self.sliderMax = self.thumb2.frame.origin.x;
    }
    [self setSliderFillFrame];
    [self setPppText];

}
- (IBAction)switchToggled:(id)sender {
    if (self.locSwitch.on)
        self.locationField.hidden = YES;
    else
        self.locationField.hidden = NO;
}

-(void)setSliderFillFrame
{
    [self.sliderFill setFrame:CGRectMake(self.sliderMin, self.sliderBackdrop.frame.origin.y, self.sliderMax-self.sliderMin + self.thumb2.imageView.image.size.width/2, self.sliderBackdrop.frame.size.height)];
}

-(void)homePressed:(UIBarButtonItem*)sender{
    [self.navigationController popToRootViewControllerAnimated:YES];
    self.navigationController.navigationBarHidden = YES;
}
-(void)backPressed:(UIBarButtonItem*)sender{
    [self.navigationController popViewControllerAnimated:YES];
    
    
}

/*
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
*/
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UIView * txt in self.view.subviews){
        if (([txt isKindOfClass:[UITextField class]] || [txt isKindOfClass:[UITextView class]]) && [txt isFirstResponder]) {
            [txt resignFirstResponder];
        }
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
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
- (IBAction)donePressed:(id)sender {
    [self.locationField resignFirstResponder];
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
   // [ret setObject:[NSNumber numberWithInt:floor(self.slider.value)] forKey:@"price"];
    return ret;
}

-(NSMutableDictionary*)getCreatorPreferences{
    NSMutableDictionary* ret = [self getPreferences];
   // WhenViewController* whenvc = (WhenViewController*) [self.navigationController.viewControllers objectAtIndex:1];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"cccc, MMM d, hh:mm aa"];
  //  [ret setObject:[dateFormat stringFromDate:whenvc.when.date] forKey:@"date"];
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
   // if (![self.myUITextView.text  isEqualToString: @"Include an optional message with your invitation"])
      //  message = self.myUITextView.text;
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
