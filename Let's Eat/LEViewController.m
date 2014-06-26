//
//  LEViewController.m
//  Let's Eat
//
//  Created by Ryan Kass on 2/17/14.
//  Copyright (c) 2014 Ryan Kass. All rights reserved.
//

#import "LEViewController.h"
#import "Server.h"
#import "NoConnectionAlertDelegate.h"
@interface LEViewController ()

@property (strong, nonatomic) UIAlertView *failedConnection;
@end




@implementation LEViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.alertShowing = NO;
    if ([CLLocationManager locationServicesEnabled]) {
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [LEViewController locationManager].delegate = self;
            [LEViewController locationManager].desiredAccuracy = kCLLocationAccuracyBest;
            [LEViewController locationManager].distanceFilter = kCLDistanceFilterNone;
            [[LEViewController locationManager] startUpdatingLocation];
        });
        
    }
	// Do any additional setup after loading the view.
    /*TODO
     write bad request function
     */
}
static CLLocation* myLocation;
+ (CLLocation*) myLocation
{
    @synchronized(self) {
        return myLocation;
    }
}
+ (void) setMyLocation:(CLLocation *)locationInput
{
    @synchronized(self)
        {
            myLocation = locationInput;
        }
}
-(void)viewWillDisappear:(BOOL)animated{
    [self unloadScreen];
}
-(void)unloadScreen{
    REMOVE_VIEW(self.fadeout);
    REMOVE_VIEW(self.blacky);
    REMOVE_VIEW(self.loadingIndicator);
    REMOVE_VIEW(self.loadingLabel);
}
-(void)loadingScreen{
    self.fadeout = [[UIView alloc] initWithFrame:CGRectMake(0,0,[UIApplication sharedApplication].keyWindow.frame.size.width , [UIApplication sharedApplication].keyWindow.frame.size.height)];
    self.fadeout.backgroundColor = [UIColor clearColor];
    [[UIApplication sharedApplication].keyWindow addSubview:self.fadeout];
    self.blacky = [[UIView alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width)/2 - 150, ([UIScreen mainScreen].bounds.size.height)/2 - 75, 300, 150)];
    self.blacky.backgroundColor = [UIColor blackColor];
    self.blacky.alpha = .75;
    self.loadingIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width)/2 - 120, ([UIScreen mainScreen].bounds.size.height)/2 - 90, 240, 240)];
    [self.loadingIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [[UIApplication sharedApplication].keyWindow addSubview:self.loadingIndicator];
    self.loadingIndicator.hidden = NO;
    [self.loadingIndicator startAnimating];
    [[UIApplication sharedApplication].keyWindow addSubview:self.blacky];
    self.loadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, ([UIScreen mainScreen].bounds.size.height)/2 - 60, 320, 80)];
    [self.loadingLabel setFont:[UIFont boldSystemFontOfSize:20]];
    [self.loadingLabel setTextColor:[UIColor whiteColor]];
    [self.loadingLabel setText:@"Contacting the internet..."];
    [self.loadingLabel setTextAlignment:NSTextAlignmentCenter];
    [[UIApplication sharedApplication].keyWindow addSubview:self.loadingLabel];
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:self.loadingIndicator];
}
+(CLLocationManager*) locationManager
{
    static CLLocationManager *locationManager = nil;
    
    if (locationManager == nil)
    {
        locationManager = [[CLLocationManager alloc] init];
    }
    
    return locationManager;
}


- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"noConnectionAlertShowing"] integerValue] == 0){
        [LEViewController setUserDefault:@"noConnectionAlertShowing" data:[NSNumber numberWithInteger:1]];
        self.noConnectionAlertDelegate = [[NoConnectionAlertDelegate alloc] init];
        self.failedConnection = [[UIAlertView alloc] initWithTitle:@"Oof" message:@"Couldn't connect to the server.  Check your connection and try again." delegate:self.noConnectionAlertDelegate cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [self.failedConnection show];
        [self unloadScreen];
        
    }
    
}
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    LEViewController.myLocation = newLocation;
    NSLog(@"updated my location to %@", LEViewController.myLocation);
  //  NSLog(@"SEETTTTING LOC to %@", self.myLocation);
    [[LEViewController locationManager] stopUpdatingLocation];
    
}
- (NSUInteger) supportedInterfaceOrientations {
    // Return a bitmask of supported orientations. If you need more,
    // use bitwise or (see the commented return).
    return UIInterfaceOrientationMaskPortrait;
    // return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskPortraitUpsideDown;
}
+ (void) setUserDefault:(NSString *)key data:(NSObject *) data
{
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
