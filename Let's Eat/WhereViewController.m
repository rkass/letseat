//
//  WhereViewController.m
//  Let's Eat
//
//  Created by Ryan Kass on 2/24/14.
//  Copyright (c) 2014 Ryan Kass. All rights reserved.
//

#import "WhereViewController.h"

@interface WhereViewController ()
@property (strong, nonatomic) NSString* latitude;
@property (strong, nonatomic) NSString* longitude;
@property (strong, nonatomic) NSString* address;
@property (strong, nonatomic) CLLocation* myLocation;
//@property (weak, nonatomic) IBOutlet MKMapView *map;
@end

@implementation WhereViewController

@synthesize latitude, longitude, address, myLocation;
+(CLLocationManager*) locationManager
{
    static CLLocationManager *locationManager = nil;
    
    if (locationManager == nil)
    {
        locationManager = [[CLLocationManager alloc] init];
    }
    
    return locationManager;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [WhereViewController locationManager].delegate = self;
    [WhereViewController locationManager].desiredAccuracy = kCLLocationAccuracyBest;
    [WhereViewController locationManager].distanceFilter = kCLDistanceFilterNone;
    [[WhereViewController locationManager] startUpdatingLocation];
   // CLLocationCoordinate2D coordinate = [self getLocation];
    //NSString *latitude = [NSString stringWithFormat:@"%f", coordinate.latitude];
    //NSString *longitude = [NSString stringWithFormat:@"%f", coordinate.longitude];
    
   // NSLog(@"Latitude : %@", latitude);
   // NSLog(@"Longitude : %@",longitude);

    
}/*
-(CLLocationCoordinate2D) getLocation{
    static CLLocationManager *locationManager;
    if (! locationManager)
    	locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    [locationManager startUpdatingLocation];
    CLLocation *location = [locationManager location];
    CLLocationCoordinate2D coordinate = [location coordinate];
    
    return coordinate;
}
*/
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    int degrees = newLocation.coordinate.latitude;
    double decimal = fabs(newLocation.coordinate.latitude - degrees);
    int minutes = decimal * 60;
    double seconds = decimal * 3600 - minutes * 60;
    NSString *lat = [NSString stringWithFormat:@"%d° %d' %1.4f\"",
                     degrees, minutes, seconds];
    NSLog(@" Current Latitude : %@",lat);
    //latLabel.text = lat;
    degrees = newLocation.coordinate.longitude;
    decimal = fabs(newLocation.coordinate.longitude - degrees);
    minutes = decimal * 60;
    seconds = decimal * 3600 - minutes * 60;
    NSString *longt = [NSString stringWithFormat:@"%d° %d' %1.4f\"",
                       degrees, minutes, seconds];
    self.longitude = longt;
    self.latitude = lat;
    self.myLocation = newLocation;
    NSLog(@" Current Longitude : %@",longt);
    [[WhereViewController locationManager] stopUpdatingLocation];
  
    //longLabel.text = longt;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
