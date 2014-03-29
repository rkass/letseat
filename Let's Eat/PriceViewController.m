//
//  PriceViewController.m
//  Let's Eat
//
//  Created by Ryan Kass on 2/27/14.
//  Copyright (c) 2014 Ryan Kass. All rights reserved.
//

#import "PriceViewController.h"
#import "HomeViewController.h"
#import "WhoViewController.h"
#import "WhatViewController.h"
#import "InviteViewController.h"
#import "CreateMealNavigationController.h"
#import "NMRangeSlider.h"
#import "User.h"
#import "JSONKit.h"
#import "Graphics.h"
#import "Invitation.h"


@interface PriceViewController ()
@property (strong, nonatomic) IBOutlet UISlider *slidePiece;


@property (strong, nonatomic) IBOutlet UILabel *currLocLabel;
@property int minPrice;
@property int maxPrice;
@property (strong, nonatomic) IBOutlet UIImageView *white2;
@property (strong, nonatomic) IBOutlet UILabel *whereLabel;
@property (strong, nonatomic) IBOutlet UIImageView *white;
@property (strong, nonatomic) UIButton *thumb1;
@property (strong, nonatomic) IBOutlet UIButton *submit;
@property (strong, nonatomic) IBOutlet UIScrollView *scroller;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *indicator2;
@property (strong, nonatomic) IBOutlet UIImageView *whiteBorder;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *indicator;
@property (strong, nonatomic) IBOutlet UITextField *myUITextField;
@property (strong, nonatomic) IBOutlet UIImageView *sliderBackdrop;
@property (strong, nonatomic) IBOutlet UIImageView *locValidator;
@property (strong, nonatomic) IBOutlet UIButton *central;
@property (strong, nonatomic) IBOutlet UIButton *byMe;
@property (strong, nonatomic) IBOutlet UIStepper *stepper;
@property bool switchTicked;
@property (strong, nonatomic) CLLocation* myLocation;
@property (strong, nonatomic) IBOutlet UISwitch *locSwitch;
@property (strong, nonatomic) UIImageView* sliderFill;
@property (strong, nonatomic) UIButton *thumb2;
@property (strong, nonatomic) IBOutlet UILabel *ppp;
@property CGRect sliderPosition;
@property (strong, nonatomic) IBOutlet UIView *subscroll;
@property float sliderMaxX;
@property float sliderMinX;
@property (strong, nonatomic) IBOutlet UITextField *locationField;
@property float sliderMin;
@property (strong, nonatomic) UIImage* greencheck;

@property (strong, nonatomic) UIImage* redexc;

@property float sliderMax;
@property (strong, nonatomic) IBOutlet UILabel *scheduleWhen;
@property (strong, nonatomic) IBOutlet UILabel *recRests;
@property (strong, nonatomic) IBOutlet UILabel *whenScheduleLabel;
@property (strong, nonatomic) IBOutlet UIImageView *whiteness;
@property (strong, nonatomic) IBOutlet UIButton *respondToInvite;
@property (strong, nonatomic) UIButton* responder;

@property (strong ,nonatomic) NSArray* timeOptions;
@property (strong, nonatomic) CreateMealNavigationController* nav;
@end

@implementation PriceViewController

@synthesize white, thumb1, thumb2, sliderBackdrop, sliderPosition, sliderMaxX, sliderMinX, sliderMax, sliderMin, sliderFill, ppp, locSwitch, locationField, myLocation, locValidator, greencheck, redexc, central, byMe, stepper, timeOptions, scheduleWhen, subscroll, indicator, myUITextField, scroller, submit, indicator2, recRests, whenScheduleLabel, whiteBorder, respondToInvite, responder, whereLabel, white2, currLocLabel, nav, minPrice, maxPrice, switchTicked;
+(CLLocationManager*) locationManager
{
    static CLLocationManager *locationManager = nil;
    
    if (locationManager == nil)
    {
        locationManager = [[CLLocationManager alloc] init];
    }
    
    return locationManager;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.switchTicked = NO;
    self.stepper.tintColor = [Graphics colorWithHexString:@"b8a37e"];
    [PriceViewController locationManager].delegate = self;
    [PriceViewController locationManager].desiredAccuracy = kCLLocationAccuracyBest;
    [PriceViewController locationManager].distanceFilter = kCLDistanceFilterNone;
    [[PriceViewController locationManager] startUpdatingLocation];
    self.title = @"Price";
    self.stepper.stepValue = 1;
    self.greencheck = [UIImage imageNamed:@"GreenCheck"];
    self.redexc = [UIImage imageNamed:@"RedExc"];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self.subscroll addGestureRecognizer:tap];
    self.locSwitch.onTintColor = [Graphics colorWithHexString:@"ffa500"];
    self.indicator2.hidden = YES;
    self.locationField.delegate = self;
    self.locValidator.hidden = YES;
    [self.central.titleLabel setTextAlignment:
     NSTextAlignmentCenter];
    self.stepper.value = 2;
    self.stepper.maximumValue = 5;
    self.stepper.minimumValue = 0;
    self.indicator.hidden = YES;
    self.timeOptions = @[@"15 Minutes", @"30 Minutes", @"1 Hour", @"5 Hours", @"24 Hours", @"Whenevs"];
    self.scheduleWhen.text = self.timeOptions[(int)self.stepper.value];
    self.myUITextField.delegate = self;
    
    CreateMealNavigationController* cmnc = (CreateMealNavigationController*) self.navigationController;
    self.nav = cmnc;
    UIImage *backImg = [UIImage imageNamed:@"BackBrownCarrot"];
    //UIImage* homeImg = [Graphics makeThumbnailOfSize:bigImage size:CGSizeMake(37,22)];
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    back.bounds = CGRectMake( 0, 0, backImg.size.width, backImg.size.height );
    [back setImage:backImg forState:UIControlStateNormal];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:back];
    [back addTarget:self action:@selector(backPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = backItem;
    UIImage *bigImage = [UIImage imageNamed:@"Home"];
   // self.slidePiece.backgroundColor = [Graphics colorWithHexString:@"ffa500"];
    UIImage* homeImg = [Graphics makeThumbnailOfSize:bigImage size:CGSizeMake(30,30)];
    UIButton *home = [UIButton buttonWithType:UIButtonTypeCustom];
    home.bounds = CGRectMake( 0, 0, homeImg.size.width, homeImg.size.height );
    [home setImage:homeImg forState:UIControlStateNormal];
    UIBarButtonItem *homeItem = [[UIBarButtonItem alloc] initWithCustomView:home];
    [home addTarget:self action:@selector(homePressed:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = homeItem;
    self.view.backgroundColor = [Graphics colorWithHexString:@"f5f0df"];
    self.subscroll.backgroundColor = [Graphics colorWithHexString:@"f5f0df"];
    self.byMe.titleLabel.textColor = [UIColor grayColor];
    UIImage *thumb = [UIImage imageNamed:@"SlickThumb"];
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
    [self.thumb1 addTarget:self action:@selector(wasDragged:withEvent:) forControlEvents:UIControlEventTouchDragOutside];
    [self.thumb2 addTarget:self action:@selector(wasDragged:withEvent:)
          forControlEvents:UIControlEventTouchDragInside];
    [self.thumb2 addTarget:self action:@selector(wasDragged:withEvent:)
          forControlEvents:UIControlEventTouchDragOutside];
    self.locationField.hidden = YES;
    self.sliderMax = self.thumb2.center.x;
    self.sliderMaxX = self.thumb2.center.x;
    self.sliderMinX = self.thumb1.center.x;
   // self.sliderMinX = self.thumb1.center.x;
    self.sliderMin = self.thumb1.center.x;
   // self.sliderMax = self.thumb2.center.y;
    [self setPppText];
    [self setSliderFillFrame];
    [self.subscroll addSubview:self.sliderFill];
    [self.subscroll addSubview:self.thumb2];
    [self.subscroll addSubview:self.thumb1];
    [self.subscroll bringSubviewToFront:self.thumb1];
    [self.subscroll bringSubviewToFront:self.thumb2];
    [self.subscroll sendSubviewToBack:self.white];
    [self.subscroll bringSubviewToFront:self.whiteBorder];
    [self.subscroll bringSubviewToFront:self.stepper];
    [self.subscroll bringSubviewToFront:self.scheduleWhen];
    self.responder = self.submit;
    if (!self.nav.creator){
       /* self.recRests.hidden = YES;
        self.whiteBorder.hidden = YES;
        self.central.hidden = YES;
        self.whenScheduleLabel.hidden = YES;
        self.stepper.hidden = YES;
        self.scheduleWhen.hidden = YES;
        self.whiteness.hidden = YES;
        self.myUITextField.hidden = YES;
        self.byMe.hidden = YES;*/
        [self.recRests removeFromSuperview];
        [self.whiteBorder removeFromSuperview];
        [self.central removeFromSuperview];
        [self.whenScheduleLabel removeFromSuperview];
        [self.stepper removeFromSuperview];
        [self.scheduleWhen removeFromSuperview];
        [self.whiteness removeFromSuperview];
        [self.myUITextField removeFromSuperview];
        [self.byMe removeFromSuperview];
        self.responder = self.respondToInvite;
        [self.submit removeFromSuperview];
        if (![[self.nav getInvitation] needToRespondToDate]){
            [self.whereLabel removeFromSuperview];
            [self.white2 removeFromSuperview];
            [self.locSwitch removeFromSuperview];
            [self.currLocLabel removeFromSuperview];
        }
       /* UIImage *rti = [UIImage imageNamed:@"RespondToInvite"];
        [self.submit setImage:rti forState: UIControlStateNormal];
        float height = self.locSwitch.frame.origin.y + 50;
        [self.submit setFrame: CGRectMake(self.submit.frame.origin.x, height, rti.size.width, rti.size.height)];
        NSLog(@"height %f", height);
        NSLog(@"locswitch y %f", self.locSwitch.frame.origin.y);
        NSLog(@"submit frame x: %f, y:%f, width:%f, height:%f", submit.frame.origin.x, submit.frame.origin.y, submit.frame.size.width, submit.frame.size.height);
        [self.indicator2 setFrame: CGRectMake(self.indicator2.frame.origin.x, height, self.indicator2.frame.size.width, self.indicator2.frame.size.height)];*/
        
    }
    else
        [self.respondToInvite removeFromSuperview];

    
    

}
- (void)viewDidLayoutSubviews{

    if (!self.nav.creator){

    [self.indicator2 setFrame: CGRectMake(self.indicator2.frame.origin.x, self.respondToInvite.frame.origin.y, self.indicator2.frame.size.width, self.indicator2.frame.size.height)];
    }
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    self.myLocation = newLocation;
    [[PriceViewController locationManager] stopUpdatingLocation];
     NSLog(@"updated location: %@", self.myLocation);
}

- (IBAction)stepperStepped:(id)sender {
    self.scheduleWhen.text = self.timeOptions[(int)self.stepper.value];
}


- (void) searchCoordinatesForAddress:(NSString *)inAddress
{
    //Build the string to Query Google Maps.
    NSMutableString *urlString = [NSMutableString stringWithFormat:@"https://maps.google.com/maps/api/geocode/json?address=%@&sensor=false&key=AIzaSyBITjgfUC0tbWp9-0SRIRR-PYAultPKDbA",inAddress];
    
    //Replace Spaces with a '+' character.
    [urlString setString:[urlString stringByReplacingOccurrencesOfString:@" " withString:@"+"]];
    
    //Create NSURL string from a formate URL string.
    NSURL *url = [NSURL URLWithString:urlString];
    
    //Setup and start an async download.
    //Note that we should test for reachability!.
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    [NSURLConnection connectionWithRequest:request delegate:self];
}

- (IBAction)centralPressed:(id)sender {
    self.central.backgroundColor = [Graphics colorWithHexString:@"b8a37e"];
    self.byMe.backgroundColor = [UIColor clearColor];
    self.central.titleLabel.textColor = [UIColor blackColor];
    self.byMe.titleLabel.textColor = [UIColor grayColor];
}
- (IBAction)bymePressed:(id)sender {
    self.byMe.backgroundColor = [Graphics colorWithHexString:@"b8a37e"];
    self.central.backgroundColor = [UIColor clearColor];
    self.byMe.titleLabel.textColor = [UIColor blackColor];
    self.central.titleLabel.textColor = [UIColor grayColor];
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    
    JSONDecoder* decoder = [[JSONDecoder alloc]
                            initWithParseOptions:JKParseOptionNone];
    NSDictionary *resultsDictionary = [data objectFromJSONData];
    if ([resultsDictionary[@"success"] isEqual: @YES]){
        NSLog(@"%@",resultsDictionary);
       // [self performSegueWithIdentifier:@"priceToHome" sender:self];
    }
    else if ([resultsDictionary[@"success"] isEqual: @NO]){
        NSLog(@"do something failure related");
    }
    else{
        NSLog(@"also hurray");
        NSMutableDictionary* json = [decoder objectWithData:data];
        if(!json){
            NSLog(@"researching");
        [self searchCoordinatesForAddress:[self.locationField text]];
        return;
        }
        if ([json[@"status"] isEqualToString:@"ZERO_RESULTS"]){
            NSLog(@"location not found");
            self.indicator.hidden = YES;
            [self.indicator stopAnimating];
            self.locValidator.image = redexc;
            self.locValidator.hidden = NO;
        }
        else{
            self.indicator.hidden = YES;
            [self.indicator stopAnimating];
            self.myLocation = [[CLLocation alloc] initWithLatitude:[json[@"results"][0][@"geometry"][@"location"][@"lat"] floatValue] longitude:[json[@"results"][0][@"geometry"][@"location"][@"lng"] floatValue]];
            NSLog(@"updated location: %@", self.myLocation);
            self.locValidator.image = greencheck;
            self.locValidator.hidden = NO;
        }
    }
    
}

-(void) setPppText{
    int min = roundf(powf((self.sliderMin - self.sliderMinX) / (self.sliderMaxX - self.sliderMinX), 2) * 60) + 10;
    int max =roundf(powf((self.sliderMax - self.sliderMinX) / (self.sliderMaxX - self.sliderMinX),2) * 60) + 10;
    self.minPrice = min;
    self.maxPrice = max;
    //int max = roundf((self.sliderMax - self.sliderMinX) / (self.sliderMaxX - self.sliderMinX) * 90) + 10;
    if (max >= 70){
        self.ppp.text = [NSString stringWithFormat:@"$%d - $%d+", min, max];
    }
    else
        self.ppp.text = [NSString stringWithFormat:@"$%d - $%d", min, max];
    
}

- (void)wasDragged:(UIButton *)button withEvent:(UIEvent *)event
{
	// get the touch
	UITouch *touch = [[event touchesForView:button] anyObject];
    
	// get delta
	CGPoint point = [touch locationInView:nil];
    float x = point.x;
    if (x < self.sliderMinX/* + (button.imageView.image.size.width/2)*/)
        x = self.sliderMinX;// + (button.imageView.image.size.width/2);
    else if (x > self.sliderMaxX /*+ (button.imageView.image.size.width/2)*/)
        x = self.sliderMaxX; /*+ (button.imageView.image.size.width/2);*/
    button.center = CGPointMake(x, button.center.y);
    if (self.thumb2.frame.origin.x < self.thumb1.frame.origin.x){
        self.sliderMin = self.thumb2.center.x;
        self.sliderMax = self.thumb1.center.x;
    }
    else {
        self.sliderMin = self.thumb1.center.x;
        self.sliderMax = self.thumb2.center.x;
    }
    [self setSliderFillFrame];
    [self setPppText];

}
- (IBAction)switchToggled:(id)sender {
    self.switchTicked = YES;
    self.myLocation = nil;
    if (self.locSwitch.on){
        self.locationField.hidden = YES;
        [[PriceViewController locationManager] startUpdatingLocation];
    }
    else{
        self.locationField.hidden = NO;
    }
}

- (IBAction)scrollDown:(id)sender {
    CGPoint bottomOffset = CGPointMake(0, self.scroller.contentSize.height - self.scroller.bounds.size.height);
    [self.scroller setContentOffset:bottomOffset animated:YES];
}

-(void)setSliderFillFrame
{
    [self.sliderFill setFrame:CGRectMake(self.sliderMin, self.sliderBackdrop.frame.origin.y, self.sliderMax-self.sliderMin /*+ self.thumb2.imageView.image.size.width/2*/, self.sliderBackdrop.frame.size.height)];
}

-(void)homePressed:(UIBarButtonItem*)sender{
    [self.navigationController popToRootViewControllerAnimated:YES];
    self.navigationController.navigationBarHidden = YES;
}
-(void)backPressed:(UIBarButtonItem*)sender{
    [self.navigationController popViewControllerAnimated:YES];
    
    
}


- (void)handleTap:(UITapGestureRecognizer *)recognizer
{
    for (UIView * txt in self.subscroll.subviews){
        if (([txt isKindOfClass:[UITextField class]] || [txt isKindOfClass:[UITextView class]]) && [txt isFirstResponder]) {
            if ([self.locationField isFirstResponder]){
                self.indicator.hidden = NO;
                [self.indicator startAnimating];
                [self searchCoordinatesForAddress:self.locationField.text];
            }
            [txt resignFirstResponder];
        }
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if  ([self.locationField isFirstResponder]){
        self.indicator.hidden = NO;
        [self.indicator startAnimating];
        [self searchCoordinatesForAddress:self.locationField.text];
    }
    [textField resignFirstResponder];
    return NO;
}


- (IBAction)hideStuff:(id)sender {
    self.locValidator.hidden = YES;
    self.indicator.hidden = YES;
    [self.indicator stopAnimating];

}





-(NSMutableDictionary*)getPreferences{
    NSMutableDictionary* ret = [[NSMutableDictionary alloc] init];
    if (self.nav.creator || [[self.nav getInvitation] needToRespondToDate])
        [ret setObject:[NSString stringWithFormat:@"%f,%f", self.myLocation.coordinate.latitude, self.myLocation.coordinate.longitude]  forKey:@"location"];
    WhatViewController* whatvc = (WhatViewController*)[self.nav viewControllers][[[self.nav viewControllers] count] - 2 ];
    [ret setObject:whatvc.wantItems forKey:@"foodList"];
    [ret setObject:[NSNumber numberWithInt:self.minPrice] forKey:@"minPrice"];
    [ret setObject:[NSNumber numberWithInt:self.maxPrice] forKey:@"maxPrice"];
    return ret;
}

-(NSMutableDictionary*)getCreatorPreferences{
    NSMutableDictionary* ret = [self getPreferences];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"cccc, MMM d, hh:mm aa"];
    HomeViewController* homevc = (HomeViewController*)[self.nav viewControllers][[[self.nav viewControllers] count] - 4];
    [ret setObject:[dateFormat stringFromDate:homevc.date.date] forKey:@"date"];
    WhoViewController* whovc = (WhoViewController*)[self.nav viewControllers][[[self.nav viewControllers] count] - 3];
    NSMutableArray* numbers = [[NSMutableArray alloc] init];
    for (NSMutableDictionary* dict in whovc.friends){
        if ([dict[@"checked"]  isEqual: @YES]){
            for (NSString* number in dict[@"numbers"])
                [numbers addObject:number];
        }
    }
    [ret setObject:self.timeOptions[(int)self.stepper.value] forKey:@"scheduleAfter"];
    [ret setObject:[NSNumber numberWithBool:(![self.central.backgroundColor  isEqual:[UIColor clearColor]] )] forKey:@"central"];
    [ret setObject:numbers forKey:@"numbers"];
    [ret setObject:self.myUITextField.text forKey:@"message"];
    return ret;
}

- (BOOL) validate{
    if(!self.myLocation){
        UIAlertView* av;
        if (!self.switchTicked){
            av = [[UIAlertView alloc] initWithTitle:@"Oof" message:@"We can't get a read on your current location, please enter it manually" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            self.locSwitch.on = NO;
            self.locationField.hidden = NO;
            [self.locationField becomeFirstResponder];
        }
        else{
            av = [[UIAlertView alloc] initWithTitle:@"Oof" message:@"Enter a valid location or use your current  location" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        }
        CGPoint offset = CGPointMake(0, 0);
        self.responder.hidden = NO;
        self.indicator2.hidden = YES;
        [self.indicator2 stopAnimating];
        [av show];
        [self.scroller setContentOffset:offset animated:YES];
        return NO;
    }
    return YES;
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return !([textField.text length]>80 && [string length] > range.length);
}
- (IBAction)respondSubmit:(id)sender {
    self.respondToInvite.hidden = YES;
    self.indicator2.hidden = NO;
    [self.indicator2 startAnimating];
    if([self validate])
            [User respondYes:[self.nav getInvitation].num preferences:[self getPreferences] source:self];
}
- (IBAction)submit:(id)sender {
    self.submit.hidden = YES;
    self.indicator2.hidden = NO;
    [self.indicator2 startAnimating];
    if ([self validate]){
        [User createInvitation:[self getCreatorPreferences] source:self];
    }
    
}
/*
- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSDictionary *resultsDictionary = [data objectFromJSONData];
    if ([resultsDictionary[@"success"] isEqual: @YES]){
        [self performSegueWithIdentifier:@"priceToHome" sender:self];
    }
}
*/
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
