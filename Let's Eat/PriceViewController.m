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
#import "InviteTransitionConnectionHandler.h"
#import "User.h"
#import "JSONKit.h"
#import "Graphics.h"
#import "LEViewController.h"
#import "Invitation.h"
#import "LEViewController.h"
#import "CheckAllStarsTableViewCell.h"
#import "ProgressBarDelegate.h"
#import "ProgressBarTableViewCell.h"
#import "FinalStepTableViewCell.h"
@interface PriceViewController ()
@property (strong, nonatomic) IBOutlet UITableView *progressBarTable;
@property (strong, nonatomic) IBOutlet UISlider *slidePiece;
@property (strong, nonatomic) IBOutlet UILabel *minYeses;
@property (strong, nonatomic) NSMutableData* responseData;
@property (strong, nonatomic) IBOutlet UIButton *cib;
@property int invitees;
@property (strong, nonatomic) CLLocation* nonCurrentLocation;
@property (strong, nonatomic) IBOutlet UILabel *currLocLabel;
@property int minPrice;
@property (strong, nonatomic) IBOutlet UILabel *scheduleIf;
@property int maxPrice;
@property (strong, nonatomic) IBOutlet UIImageView *white2;
@property (strong, nonatomic) IBOutlet UILabel *scheduleResponse;
@property (strong, nonatomic) IBOutlet UILabel *numPeople;
@property (strong, nonatomic) IBOutlet UIImageView *whiteSched;
@property (strong, nonatomic) IBOutlet UIImageView *slideBackDrop2;
@property int minPeople;
@property (strong, nonatomic) IBOutlet UILabel *whereLabel;
@property (strong, nonatomic) IBOutlet UIImageView *white;
@property (strong, nonatomic) UIButton *thumb1;
@property (strong, nonatomic) UIButton *thumb3;
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
@property (strong, nonatomic) Invitation* invitation;
@property bool switchTicked;

@property (strong, nonatomic) IBOutlet UISwitch *locSwitch;
@property (strong, nonatomic) UIImageView* sliderFill;
@property (strong, nonatomic) UIImageView* sliderFill2;
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
@property float sliderMin2;
@property float sliderMax2;
@property float sliderMax;
@property (strong, nonatomic) IBOutlet UILabel *scheduleWhen;
@property (strong, nonatomic) IBOutlet UITableView *navBar;
@property (strong, nonatomic) IBOutlet UILabel *recRests;
@property (strong, nonatomic) IBOutlet UILabel *whenScheduleLabel;
@property (strong, nonatomic) IBOutlet UILabel *messageLabel;
@property (strong, nonatomic) IBOutlet UIImageView *whiteness;
@property (strong, nonatomic) IBOutlet UIButton *respondToInvite;
@property (strong, nonatomic) UIButton* responder;
@property (strong, nonatomic) IBOutlet UIView *bottomNavBar;

@property (strong ,nonatomic) NSArray* timeOptions;
@property (strong,nonatomic) ProgressBarDelegate* progressBarDelegate;


@property (strong, nonatomic) CreateMealNavigationController* nav;
@end

@implementation PriceViewController

@synthesize white, thumb1, thumb2, thumb3, sliderBackdrop, sliderPosition, sliderMaxX, sliderMinX, sliderMax, sliderMin, sliderFill, sliderFill2, ppp, locSwitch, locationField, locValidator, greencheck, redexc, central, byMe, stepper, timeOptions, scheduleWhen, subscroll, indicator, myUITextField, scroller, submit, indicator2, recRests, whenScheduleLabel, whiteBorder, respondToInvite, responder, whereLabel, white2, currLocLabel, nav, minPrice, maxPrice, switchTicked, invitees, sliderMin2, sliderMax2, numPeople, invitation;

- (void)viewDidLoad
{
    [super viewDidLoad];
   // self.progressBarDelegate = [[ProgressBarDelegate alloc] initWithTitle:@"Create Invitation Button"];
   // [self.progressBarTable setDelegate:self.progressBarDelegate];
    //[self.progressBarTable setDataSource:self.progressBarDelegate];
   // [self.bottomNavBar setBackgroundColor:[UIColor colorWithRed:168 green:191   blue:13 alpha:1]];
    [self.bottomNavBar setBackgroundColor:[UIColor colorWithWhite:1 alpha:.5]];
    self.switchTicked = NO;
    self.stepper.tintColor = [Graphics colorWithHexString:@"2d769b"];
    [self.navBar setDelegate:self];
    [self.navBar setDataSource:self];
 self.responseData = [[NSMutableData alloc] initWithLength:0];
    self.stepper.stepValue = 1;
    self.greencheck = [UIImage imageNamed:@"greencheck"];
    self.redexc = [UIImage imageNamed:@"RedExc"];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self.subscroll addGestureRecognizer:tap];
    self.locSwitch.onTintColor = [Graphics colorWithHexString:@"2d769b"];
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
    self.title = @"Final Step";
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
    self.view.backgroundColor = [UIColor colorWithPatternImage:GET_IMG(@"bg")];
    self.subscroll.backgroundColor = [UIColor colorWithPatternImage:GET_IMG(@"bg")];
    self.byMe.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.byMe.titleLabel.textColor = [UIColor grayColor];

    UIImage *thumb = [UIImage imageNamed:@"SlickThumb"];
    self.sliderMaxX = self.sliderBackdrop.frame.origin.x + self.sliderBackdrop.frame.size.width - thumb.size.width/2;
    self.sliderMinX = self.sliderBackdrop.frame.origin.x - thumb.size.width/2;


    self.thumb1 = [[UIButton alloc] initWithFrame:CGRectMake(self.sliderMinX, self.sliderBackdrop.frame.origin.y + self.sliderBackdrop.frame.size.height/2 - thumb.size.height/2 /*+ self.subscroll.frame.origin.y*/,thumb.size.width , thumb.size.height)];

    if (self.nav.creator){
        NSMutableArray* arr = [self getCreatorPreferences][@"numbers"];
        self.invitees = arr.count;
        [self.cib setTitle:@"Create Invitation" forState:UIControlStateNormal];
    }
    else{
        [self.cib setTitle:@"Respond" forState:UIControlStateNormal];
        [self.cib setTitle:@"Respond" forState:UIControlStateHighlighted];
    }
    self.sliderMin = self.sliderMinX;
    self.sliderMax = self.sliderMaxX;
    self.sliderMin2 = self.sliderMinX;
    self.sliderMax2 = self.sliderMax2;

    [self.thumb1 setImage:thumb forState:UIControlStateNormal];
    self.thumb2 = [[UIButton alloc] initWithFrame:CGRectMake(self.sliderMaxX, self.sliderBackdrop.frame.origin.y + self.sliderBackdrop.frame.size.height/2 - thumb.size.height/2 ,thumb.size.width, thumb.size.height)];
    [self.thumb2 setImage:thumb forState:UIControlStateNormal];
    self.thumb3 = [[UIButton alloc] initWithFrame:CGRectMake(self.sliderMinX, self.slideBackDrop2.frame.origin.y + self.slideBackDrop2.frame.size.height/2 - thumb.size.height/2,thumb.size.width, thumb.size.height)];
    UIImage *sliderFillImg = [UIImage imageNamed:@"sliderfill"];

    self.sliderFill = [[UIImageView alloc] initWithImage:sliderFillImg];
    self.sliderFill2 = [[UIImageView alloc] initWithImage:sliderFillImg];
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
    self.sliderMin2 = self.thumb1.center.x;
    self.sliderMax2 = self.thumb3.center.x;
    self.thumb1.adjustsImageWhenHighlighted = NO;
    self.thumb2.adjustsImageWhenHighlighted = NO;
   // self.sliderMax = self.thumb2.center.y;
    NSLog(@"slidermin1: %f", self.sliderMin);
    NSLog(@"slidermin2: %f", self.sliderMin2);

    [self setPppText2];
    [self setSliderFillFrame2];
    [self.subscroll addSubview:self.sliderFill];
    [self.subscroll addSubview:self.thumb2];
    [self.subscroll addSubview:self.thumb1];
    [self.subscroll bringSubviewToFront:self.thumb1];
    [self.subscroll bringSubviewToFront:self.thumb2];
    [self.subscroll sendSubviewToBack:self.white];
    [self.subscroll bringSubviewToFront:self.whiteBorder];
    [self.subscroll bringSubviewToFront:self.stepper];
    [self.subscroll bringSubviewToFront:self.scheduleWhen];
    NSLog(@"invitees count: %lu", (unsigned long)self.nav.invitees.count);
    self.responder = self.submit;
  //for testing: self.nav.creator = NO;
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
        [self.scheduleIf removeFromSuperview];
        [self.scheduleResponse removeFromSuperview];
        [self.whiteSched removeFromSuperview];
        [self.slideBackDrop2 removeFromSuperview];
        [self.recRests removeFromSuperview];
        [self.whiteBorder removeFromSuperview];
        [self.central removeFromSuperview];
        [self.whenScheduleLabel removeFromSuperview];
        [self.stepper removeFromSuperview];
        [self.scheduleWhen removeFromSuperview];
        [self.whiteness removeFromSuperview];
        [self.myUITextField removeFromSuperview];
        [self.messageLabel removeFromSuperview];
        [self.byMe removeFromSuperview];
        self.responder = self.respondToInvite;
        [self.submit removeFromSuperview];
        if (![self.nav.invitation needToRespondToDate]){
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
    else{
        if (self.invitees == 0 && self.nav.invitees.count == 0){
            NSLog(@"here");
            self.respondToInvite.titleLabel.textAlignment = NSTextAlignmentCenter;
            self.respondToInvite.titleLabel.text = @"Schedule Meal";
            [self.submit removeFromSuperview];
            [self.scheduleIf removeFromSuperview];
            [self.scheduleResponse removeFromSuperview];
            [self.whiteSched removeFromSuperview];
            [self.slideBackDrop2 removeFromSuperview];
            [self.recRests removeFromSuperview];
            [self.whiteBorder removeFromSuperview];
            [self.central removeFromSuperview];
            [self.whenScheduleLabel removeFromSuperview];
            [self.stepper removeFromSuperview];
            [self.scheduleWhen removeFromSuperview];
            [self.whiteness removeFromSuperview];
            [self.myUITextField removeFromSuperview];
            [self.byMe removeFromSuperview];
            [self.messageLabel removeFromSuperview];

        }
        else{
            [self.respondToInvite removeFromSuperview];

            [self.thumb3 setImage:thumb forState:UIControlStateNormal];
            [self.thumb3 addTarget:self action:@selector(wasDragged2:withEvent:)
              forControlEvents:UIControlEventTouchDragInside];
            [self.thumb3 addTarget:self action:@selector(wasDragged2:withEvent:) forControlEvents:UIControlEventTouchDragOutside];
            self.thumb3.adjustsImageWhenHighlighted = NO;
            [self.subscroll addSubview:self.sliderFill2];
        //    [self.subscroll addSubview:self.thumb3];

        }
    }
    [self loadDefaults];
  //  [self setPppText];
  //  [self setSliderFillFrame];
    
    

}
- (void)viewDidLayoutSubviews{

    if (!self.nav.creator || (self.invitees == 0 && self.nav.invitees.count == 0)){

    [self.indicator2 setFrame: CGRectMake(self.indicator2.frame.origin.x, self.respondToInvite.frame.origin.y, self.indicator2.frame.size.width, self.indicator2.frame.size.height)];

    }
    [self setPppText];
    [self setSliderFillFrame];
    UIImage *thumb = [UIImage imageNamed:@"SlickThumb"];
    [self.thumb1 setFrame:CGRectMake(self.thumb1.frame.origin.x, self.sliderBackdrop.frame.origin.y + self.sliderBackdrop.frame.size.height/2 - thumb.size.height/2 /*+ self.subscroll.frame.origin.y*/,thumb.size.width , thumb.size.height)];
    [self.thumb2 setFrame:CGRectMake(self.thumb2.frame.origin.x, self.sliderBackdrop.frame.origin.y + self.sliderBackdrop.frame.size.height/2 - thumb.size.height/2 ,thumb.size.width, thumb.size.height)];
   /* UIImage *thumb = [UIImage imageNamed:@"SlickThumb"];
    [self.thumb1 setFrame:CGRectMake(self.sliderMinX, self.sliderBackdrop.frame.origin.y + self.sliderBackdrop.frame.size.height/2 - thumb.size.height/2,thumb.size.width , thumb.size.height)];
    [self.thumb2 setFrame:CGRectMake(self.sliderMaxX, self.sliderBackdrop.frame.origin.y + self.sliderBackdrop.frame.size.height/2 - thumb.size.height/2 ,thumb.size.width, thumb.size.height)];*/
}
-(void)viewWillAppear:(BOOL)animated{
  /*  UIImage *thumb = [UIImage imageNamed:@"SlickThumb"];
    [self.thumb1 setFrame:CGRectMake(self.sliderMinX, self.sliderBackdrop.frame.origin.y + self.sliderBackdrop.frame.size.height/2 - thumb.size.height/2,thumb.size.width , thumb.size.height)];
    [self.thumb2 setFrame:CGRectMake(self.sliderMaxX, self.sliderBackdrop.frame.origin.y + self.sliderBackdrop.frame.size.height/2 - thumb.size.height/2 ,thumb.size.width, thumb.size.height)];*/

}
- (float)xPositionFromSliderValue:(UISlider *)aSlider;
{
    float sliderRange = aSlider.frame.size.width - aSlider.currentThumbImage.size.width;
    float sliderOrigin = aSlider.frame.origin.x + (aSlider.currentThumbImage.size.width / 2.0);
    
    float sliderValueToPixels = (((aSlider.value-aSlider.minimumValue)/(aSlider.maximumValue-aSlider.minimumValue)) * sliderRange) + sliderOrigin;
    
    return sliderValueToPixels;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView == self.navBar)
        return 0;
    return 0;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView == self.navBar)
        return 1;
    return 0;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.navBar)
        return 1;
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"hurr");
    if (tableView == self.navBar){
        NSLog(@"navbar");
        CheckAllStarsTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CheckAllStars"];
        NSLog(@"cell %@", cell);
        [cell setWithPriceVC:self];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }

    NSLog(@"nonavbar");
    return nil;
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
    NSLog(@"requesting.....\n.....\n....");
    [NSURLConnection connectionWithRequest:request delegate:self];
}

- (IBAction)centralPressed:(id)sender {
    //change to pressed155/notpressed155
    self.central.backgroundColor = [UIColor whiteColor];
    self.byMe.backgroundColor = [UIColor clearColor];
    [self.central setTitleColor:[Graphics colorWithHexString:@"2d769b"] forState:UIControlStateNormal];
    [self.byMe setTitleColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:.18] forState:UIControlStateNormal];
    
}
- (IBAction)bymePressed:(id)sender {
    self.byMe.backgroundColor = [UIColor whiteColor];
    self.central.backgroundColor = [UIColor clearColor];
    [self.byMe setTitleColor:[Graphics colorWithHexString:@"2d769b"] forState:UIControlStateNormal];
    [self.central setTitleColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:.18] forState:UIControlStateNormal];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"priceToInvite"]){
        InviteViewController *iv = (InviteViewController *)segue.destinationViewController;
        iv.invitation = self.invitation;
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection*)connection{
    NSDictionary* resultsDictionary = [self.responseData objectFromJSONData];
self.responseData = [[NSMutableData alloc] initWithLength:0];
    JSONDecoder* decoder = [[JSONDecoder alloc]
                            initWithParseOptions:JKParseOptionNone];
    NSLog(@"res dict: %@", resultsDictionary);
    NSLog(@"%@",resultsDictionary);
    if ([resultsDictionary[@"success"] isEqual: @YES]){
        
        if ([resultsDictionary[@"call"] isEqualToString:@"create_invitation"] || [resultsDictionary[@"call"] isEqualToString:@"respond_yes"]   ){
            Invitation* i = [InviteTransitionConnectionHandler loadInvitation:resultsDictionary locationInput:LEViewController.myLocation];
            self.invitation = i;
            [LEViewController setUserDefault:@"mealsPressed" data:[NSNumber numberWithBool:i.scheduled]];
            [self performSegueWithIdentifier:@"priceToInvite" sender:self];
        }
        // [self performSegueWithIdentifier:@"priceToHome" sender:self];
    }
    else if ([resultsDictionary[@"success"] isEqual: @NO]){
        NSLog(@"do something failure related");
    }
    else if ([resultsDictionary[@"status"] isEqualToString:@"ZERO_RESULTS"]){
        NSLog(@"in heya");
        self.indicator.hidden = YES;
        [self.indicator stopAnimating];
        self.locValidator.image = redexc;
        self.locValidator.hidden = NO;
        self.nonCurrentLocation = nil;
    }
    else{
       
            self.indicator.hidden = YES;
            [self.indicator stopAnimating];
            self.nonCurrentLocation = [[CLLocation alloc] initWithLatitude:[resultsDictionary[@"results"][0][@"geometry"][@"location"][@"lat"] floatValue] longitude:[resultsDictionary[@"results"][0][@"geometry"][@"location"][@"lng"] floatValue]];
            NSLog(@"updated location: %@", self.nonCurrentLocation);
            self.locValidator.image = greencheck;
            self.locValidator.hidden = NO;
        
    }

}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.responseData appendData:data];
    
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

-(void) setPppText2{
    int min = lroundf((self.sliderMax2 - self.sliderMinX) / (self.sliderMaxX - self.sliderMinX) * self.invitees);
    self.minPeople = min;
    //int max = roundf((self.sliderMax - self.sliderMinX) / (self.sliderMaxX - self.sliderMinX) * 90) + 10;
    if (self.minPeople == self.invitees)
        self.numPeople.text = @"Everyone";
    else
        self.numPeople.text = [NSString stringWithFormat:@"%d", min];

    
}

- (void)wasDragged2:(UIButton *)button withEvent:(UIEvent *)event
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
    self.sliderMax2 = button.center.x;
    [self setSliderFillFrame2];
    [self setPppText2];
    
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
    if (self.locSwitch.on){
        self.locationField.hidden = YES;
        self.indicator.hidden = YES;
        self.locValidator.hidden = YES;
        [self.locationField resignFirstResponder];
    }
    else{
        self.locationField.hidden = NO;

    }
}

- (void) loadDefaults{
    NSNumber *sliderMinDef = [[NSUserDefaults standardUserDefaults] objectForKey:@"sliderMin"];
    if (sliderMinDef){
        self.sliderMin = [sliderMinDef floatValue];
        self.thumb1.center = CGPointMake(self.sliderMin, self.thumb1.center.y);
        [self setPppText];
        [self setSliderFillFrame];
    }
    NSNumber *sliderMaxDef = [[NSUserDefaults standardUserDefaults] objectForKey:@"sliderMax"];
    if (sliderMaxDef){
        self.sliderMax = [sliderMaxDef floatValue];
        self.thumb2.center = CGPointMake(self.sliderMax, self.thumb2.center.y);
        [self setPppText];
        [self setSliderFillFrame];
    }
    NSNumber *centralDef = [[NSUserDefaults standardUserDefaults] objectForKey:@"central"];
    if (centralDef && (![centralDef boolValue])){
        NSLog(@"here");
        self.byMe.backgroundColor = [UIColor whiteColor];
        self.central.backgroundColor = [UIColor clearColor];
        [self.byMe setTitleColor:[Graphics colorWithHexString:@"2d769b"] forState:UIControlStateNormal];
        [self.central setTitleColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:.18] forState:UIControlStateNormal];
    }
    else{
        self.central.backgroundColor = [UIColor whiteColor];
        self.byMe.backgroundColor = [UIColor clearColor];
        [self.central setTitleColor:[Graphics colorWithHexString:@"2d769b"] forState:UIControlStateNormal];
        [self.byMe setTitleColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:.18] forState:UIControlStateNormal];
    }
    NSNumber *scheduleAfterDef = [[NSUserDefaults standardUserDefaults] objectForKey:@"scheduleAfter"];
    if (scheduleAfterDef){
        [self.stepper setValue:[scheduleAfterDef doubleValue]];
        self.scheduleWhen.text = self.timeOptions[(int)self.stepper.value];
    }
    NSNumber *sliderMax2Def = [[NSUserDefaults standardUserDefaults] objectForKey:@"sliderMax2"];
    if (sliderMax2Def){
        self.sliderMax2 = [sliderMax2Def floatValue];
        self.thumb3.center = CGPointMake(self.sliderMax2, self.thumb3.center.y);
        [self setPppText2];
        [self setSliderFillFrame2];
    }
    
}

- (void) saveDefaults{
    [LEViewController setUserDefault:@"sliderMin" data:[NSNumber numberWithFloat: self.sliderMin]];
     [LEViewController setUserDefault:@"sliderMax" data:[NSNumber numberWithFloat:self.sliderMax]];
     [LEViewController setUserDefault:@"central" data:[NSNumber numberWithBool:(![self.central.backgroundColor  isEqual:[UIColor clearColor]])]];
     [LEViewController setUserDefault:@"scheduleAfter" data:[NSNumber numberWithDouble:self.stepper.value]];
     [LEViewController setUserDefault:@"sliderMax2" data:[NSNumber numberWithFloat:self.sliderMax2]];
}

- (IBAction)scrollDown:(id)sender {
    CGPoint bottomOffset = CGPointMake(0, 400);
    [self.scroller setContentOffset:bottomOffset animated:YES];
}

-(void)setSliderFillFrame
{
    NSLog(@"fill frame min 1: %f", self.sliderMin);
    NSLog(@"width1: %f", self.sliderMax-self.sliderMin);
    [self.sliderFill setFrame:CGRectMake(self.sliderMin, self.sliderBackdrop.frame.origin.y, self.sliderMax-self.sliderMin /*+ self.thumb2.imageView.image.size.width/2*/, self.sliderBackdrop.frame.size.height)];
}

-(void)setSliderFillFrame2
{
    NSLog(@"fill frame min 2: %f", self.sliderMin2);
    NSLog(@"width2: %f", self.sliderMax2-self.sliderMin2);
    [self.sliderFill2 setFrame:CGRectMake(self.sliderMin2,  self.slideBackDrop2.frame.origin.y, self.sliderMax2-self.sliderMin2 /*+ self.thumb2.imageView.image.size.width/2*/, self.slideBackDrop2.frame.size.height)];
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
    if (self.nav.creator || [self.nav.invitation needToRespondToDate]){
        CLLocation* activeLocation;
        if (self.locSwitch.on){
            activeLocation = LEViewController.myLocation;
        }
        else
            activeLocation = self.nonCurrentLocation;
        [ret setObject:[NSString stringWithFormat:@"%f,%f", activeLocation.coordinate.latitude, activeLocation.coordinate.longitude]  forKey:@"location"];
    }
    WhatViewController* whatvc = (WhatViewController*)[self.nav viewControllers][[[self.nav viewControllers] count] - 2 ];
    [ret setObject:whatvc.ratingsDict forKey:@"ratingsDict"];
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
    NSMutableArray* invs = [[NSMutableArray alloc] init];
    for (NSMutableDictionary* dict in self.nav.invitees){
        for (NSString* number in dict[@"numbers"])
            [ invs addObject:number];
    }
    [ret setObject:self.timeOptions[(int)self.stepper.value] forKey:@"scheduleAfter"];
    [ret setObject:[NSNumber numberWithInt:self.minPeople] forKey:@"minPeople"];
    [ret setObject:[NSNumber numberWithBool:(![self.central.backgroundColor  isEqual:[UIColor clearColor]] )] forKey:@"central"];
    [ret setObject:numbers forKey:@"numbers"];
    [ret setObject:invs forKey:@"invitees"];
    [ret setObject:self.myUITextField.text forKey:@"message"];
    return ret;
}

- (BOOL) validate{
    if((!LEViewController.myLocation) && ([self.nav.invitation needToRespondToDate]) && (!self.nonCurrentLocation)){
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
    [self saveDefaults];
    return YES;
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return !([textField.text length]>80 && [string length] > range.length);
}
- (IBAction)respondSubmit:(id)sender {
    NSLog(@"respond submitting");
    if([self validate]){
        NSLog(@"validated");
        [self loadingScreen];
        if (self.nav.creator)
            [User createInvitation:[self getCreatorPreferences] source:self];
        else{
            NSLog(@"responding yes");
            [User respondYes:self.nav.invitation.num preferences:[self getPreferences] source:self];
        }
        
    }
}
- (IBAction)submit:(id)sender {
    NSLog(@"submitting");
    if ([self validate]){
        self.submit.hidden = YES;
        self.indicator2.hidden = NO;
        [self.indicator2 startAnimating];
        [self loadingScreen];
        [User createInvitation:[self getCreatorPreferences] source:self];
    }
    


}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [super connection:connection didFailWithError:error];
    self.indicator2.hidden = YES;
    self.responder.hidden = NO;
    [self unloadScreen];
    
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
