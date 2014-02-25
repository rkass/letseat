//
//  WhereViewController.m
//  Let's Eat
//
//  Created by Ryan Kass on 2/24/14.
//  Copyright (c) 2014 Ryan Kass. All rights reserved.
//

#import "WhereViewController.h"
#import "JSONKit.h"

@interface WhereViewController ()
@property (strong, nonatomic) NSString* latitude;
@property (strong, nonatomic) NSString* longitude;
@property (strong, nonatomic) NSString* address;
@property (strong, nonatomic) CLLocation* myLocation;
@property (weak, nonatomic) IBOutlet MKMapView *map;
@property (strong, nonatomic) NSLock* lock;
@property (weak, nonatomic) IBOutlet UISearchBar *search;
@property (strong, nonatomic) UIAlertView* alert;
@property (strong, nonatomic) MKPointAnnotation* annotation;
@end

@implementation WhereViewController

@synthesize latitude, longitude, address, myLocation, map,  alert, annotation;
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
    self.title = @"Where you at?";
    [self.search setDelegate:self];
    [WhereViewController locationManager].delegate = self;
    [WhereViewController locationManager].desiredAccuracy = kCLLocationAccuracyBest;
    [WhereViewController locationManager].distanceFilter = kCLDistanceFilterNone;
    [[WhereViewController locationManager] startUpdatingLocation];


    
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    self.search.text = @"";
    self.search.showsCancelButton = NO;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self searchCoordinatesForAddress:[searchBar text]];
    [searchBar resignFirstResponder];
    self.search.showsCancelButton = NO;
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

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{

    JSONDecoder* decoder = [[JSONDecoder alloc]
                            initWithParseOptions:JKParseOptionNone];
    NSMutableDictionary* json = [decoder objectWithData:data];
//    NSLog(@"dict%@", json);
    if(!json){
        NSLog(@"researching");
        [self searchCoordinatesForAddress:[self.search text]];
        return;
    }
    if ([json[@"status"] isEqualToString:@"ZERO_RESULTS"]){
        if (!self.alert)
        {
            self.alert = [[UIAlertView alloc] initWithTitle:@"Oof" message:@"Can't find that place, try a different one or idk maybe spelling it right." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
            
        }
        [alert show];
    }
    else{
        NSLog(@"%@", json[@"results"][0][@"geometry"][@"location"]);
        [self.map removeAnnotation:self.annotation ];
        self.myLocation = [[CLLocation alloc] initWithLatitude:[json[@"results"][0][@"geometry"][@"location"][@"lat"] floatValue] longitude:[json[@"results"][0][@"geometry"][@"location"][@"lng"] floatValue]];
        
        [self.annotation setCoordinate:self.myLocation.coordinate];
        [self.map addAnnotation:self.annotation];
        self.map.region = MKCoordinateRegionMakeWithDistance(self.myLocation.coordinate, 500, 500);

        
    }

}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    [self.search becomeFirstResponder];
    
}

- (void)searchBarTextDidBeginEditing:(UISearchBar*)searchBar
{
    self.search.showsCancelButton = YES;
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    self.myLocation = newLocation;
    [[WhereViewController locationManager] stopUpdatingLocation];
    [self.lock lock];
    if (!self.annotation){
        self.annotation = [[MKPointAnnotation alloc] init];
        [self.annotation setCoordinate:self.myLocation.coordinate];
        [self.map addAnnotation:self.annotation];
        self.map.region = MKCoordinateRegionMakeWithDistance(self.myLocation.coordinate, 500, 500);
    }
    else
        [self.lock unlock];
  
  
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
