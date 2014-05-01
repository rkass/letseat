//
//  LEViewController.m
//  Let's Eat
//
//  Created by Ryan Kass on 2/17/14.
//  Copyright (c) 2014 Ryan Kass. All rights reserved.
//

#import "LEViewController.h"
#import "Server.h"

@interface LEViewController ()

@property (strong, nonatomic) UIAlertView *failedConnection;
@end




@implementation LEViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
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
    if (self.fadeout && self.fadeout != (id)[NSNull null])
        [self.fadeout removeFromSuperview];
}
-(void)loadingScreen{
    self.fadeout = [[UIView alloc] initWithFrame:CGRectMake(0,0,[UIApplication sharedApplication].keyWindow.frame.size.width , [UIApplication sharedApplication].keyWindow.frame.size.height)];
    self.fadeout.backgroundColor = [UIColor blackColor];
    self.fadeout.alpha = .7;
    [[UIApplication sharedApplication].keyWindow addSubview:self.fadeout];
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
    self.failedConnection = [[UIAlertView alloc] initWithTitle:@"Oof" message:@"Couldn't connect to the server.  Check your connection and try again." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
    [self.failedConnection show];
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
