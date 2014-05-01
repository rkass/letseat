//
//  Restaurant.m
//  Let's Eat
//
//  Created by Ryan Kass on 3/25/14.
//  Copyright (c) 2014 Ryan Kass. All rights reserved.
//

#import "Restaurant.h"
#import "JSONKit.h"


@implementation Restaurant

@synthesize address, distance, name, percentMatch, price, ratingImg, restLoc, snippetImg, votes, types, invitation, url, ivc, responseData, myLocation;
-(id)init:(NSString*)addressInput distanceInput:(NSNumber*)distanceInput nameInput:(NSString*)nameInput percentMatchInput:(NSNumber*)percentMatchInput priceInput:(NSNumber*)priceInput ratingImgInput:(NSString*)ratingImgInput snippetImgInput:(NSString*)snippetImgInput votesInput:(NSNumber *)votesInput typesInput:(NSArray*)typesInput iVotedInput:(BOOL)iVotedInput invitationInput:(int)invitationInput urlInput:(NSString*)urlInput InviteViewControllerInput:(InviteViewController *)InviteViewControllerInput{
    self = [super init];
    self.responseData = [[NSMutableData alloc] initWithLength:0];
    self.distance = -1;
    self.ivc = InviteViewControllerInput;
    if (self){
        self.address = addressInput;
        self.name = nameInput;
        if (percentMatchInput == (id)[NSNull null]){
            self.percentMatch = 50;
            NSLog(@"percent match null for %@", urlInput);
        }
        else
            self.percentMatch = (int)([percentMatchInput integerValue] * 100);
        if (priceInput == (id)[NSNull null]){
            self.price = 2;
            NSLog(@"price null for %@", urlInput);
        }
        else
            self.price = [priceInput integerValue];
        self.ratingImg = ratingImgInput;
        self.snippetImg = snippetImgInput;
        if (votesInput == (id)[NSNull null]){
            self.votes = 0;
            NSLog(@"votes null for %@", urlInput);
        }
        else
            self.votes = [votesInput integerValue];
        self.types = typesInput;
        self.iVoted = iVotedInput;
        self.invitation = invitationInput;
        self.url = urlInput;
        [self searchCoordinatesForAddress:self.address];
    }
    return self;
}

-(id)init:(NSString*)addressInput nameInput:(NSString*)nameInput percentMatchInput:(NSNumber*)percentMatchInput priceInput:(NSNumber*)priceInput ratingImgInput:(NSString*)ratingImgInput snippetImgInput:(NSString*)snippetImgInput votesInput:(NSNumber*)votesInput typesInput:(NSArray*)typesInput iVotedInput:(BOOL)iVotedInput urlInput:(NSString*)urlInput myLocationInput:(CLLocation*)myLocationInput invitationInput:(int)invitationInput{
    self = [super init];
    self.responseData = [[NSMutableData alloc] initWithLength:0];
    self.distance = -1;
    self.invitation = invitationInput;
    [self searchCoordinatesForAddress:self.address];
    if (self){
        self.address = addressInput;
        self.name = nameInput;
        if (percentMatchInput == (id)[NSNull null]){
            self.percentMatch = 50;
            NSLog(@"percent match null for %@", urlInput);
        }
        else
            self.percentMatch = (int)([percentMatchInput floatValue] * 100);
        if (priceInput == (id)[NSNull null]){
            self.price = 2;
            NSLog(@"price null for %@", urlInput);
        }
        else
            self.price = [priceInput integerValue];
        self.ratingImg = ratingImgInput;
        self.snippetImg = snippetImgInput;
        if (votesInput == (id)[NSNull null]){
            self.votes = 0;
            NSLog(@"votes null for %@", urlInput);
        }
        else
            self.votes = [votesInput integerValue];
        self.types = typesInput;
        self.iVoted = iVotedInput;
        self.url = urlInput;
        self.myLocation = myLocationInput;

    }
    return self;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.responseData appendData:data];
 
}
- (void)connectionDidFinishLoading:(NSURLConnection*)connection
{
    JSONDecoder* decoder = [[JSONDecoder alloc]
                            initWithParseOptions:JKParseOptionNone];
    NSMutableDictionary* json = [decoder objectWithData:self.responseData];
   // NSLog(@"restaurant finished loading %@", json);
    [self.responseData setLength:0];
    if(!json){
        NSLog(@"data");
        //[self searchCoordinatesForAddress:self.address];
        return;
    }
    if ([json[@"status"] isEqualToString:@"ZERO_RESULTS"]){
        NSLog(@"location not found");
    }
    else{
     
        self.restLoc = [[CLLocation alloc] initWithLatitude:[json[@"results"][0][@"geometry"][@"location"][@"lat"] floatValue] longitude:[json[@"results"][0][@"geometry"][@"location"][@"lng"] floatValue]];
       /* if (self.ivc){
            CLLocationDistance d = [self.ivc.myLocation distanceFromLocation:self.restLoc];
            self.distance = d / 1609.34;
            [self.ivc saveRests];
        }*/
        CLLocationDistance d = [self.myLocation distanceFromLocation:self.restLoc];
        NSLog(@"MY LOC: %@", self.myLocation);
       NSLog(@"REST LOC: %@", self.restLoc);
        self.distance = d / 1609.34;
        NSLog(@"setting distance to %f", self.distance);
    }
    
}
-(void)setInviteAndDistance:(InviteViewController*)ivcin{
    self.ivc = ivcin;
    CLLocationDistance d = [self.ivc.myLocation distanceFromLocation:self.restLoc];
    self.distance = d / 1609.34;
  //  NSLog(@"our distance: %f", self.distance);
    //NSLog(@"my location: %@", self.ivc.myLocation);
    //NSLog(@"rest location: %@", self.restLoc);
    //NSLog(@"address: %@", self.address);
}


- (void)searchCoordinatesForAddress:(NSString *)inAddress
{
    //Build the string to Query Google Maps.
    
    NSRange r1 =[inAddress rangeOfString:@"("];
    NSRange r2 = [inAddress rangeOfString:@")"];
    //NSLog(@"old string: %@", inAddress);
    if (r1.length > 0 && r2.length > 0 && r1.location < r2.location){
        NSString* newString1 = [inAddress substringToIndex:r1.location];
        NSString* newString2 = [inAddress substringFromIndex:r2.location + 2];
        inAddress = [newString1 stringByAppendingString:newString2];
    }
  //  NSLog(@"new string: %@", inAddress);
    NSMutableString *urlString = [NSMutableString stringWithFormat:@"https://maps.google.com/maps/api/geocode/json?address=%@&sensor=false&key=AIzaSyBITjgfUC0tbWp9-0SRIRR-PYAultPKDbA",inAddress];
    
    //Replace Spaces with a '+' character.
    [urlString setString:[urlString stringByReplacingOccurrencesOfString:@" " withString:@"+"]];

    //Create NSURL string from a formate URL string.
    NSURL *requrl = [NSURL URLWithString:urlString];
  //  NSLog(@"Request url: %@", requrl);
    //Setup and start an async download.
    //Note that we should test for reachability!.
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:requrl];
    [NSURLConnection connectionWithRequest:request delegate:self];
}

-(id)initWithDict:(NSMutableDictionary*)dict
{
    self = [super init];
    if (self){
        self.address = dict[@"address"];
        self.distance = [dict[@"distance"] floatValue];
        self.name = dict[@"name"];
        self.percentMatch = [dict[@"percentMatch"] integerValue];
        self.price = [dict[@"price"] integerValue];
        self.ratingImg = dict[@"ratingImg"];
        self.snippetImg = dict[@"snippetImg"];
        self.votes = [dict[@"votes"] integerValue];
        self.types = dict[@"types"];
        self.iVoted = [dict[@"iVoted"] boolValue];
        self.invitation = [dict[@"invitation"] integerValue];
        self.url = dict[@"url"];
        self.restLoc = dict[@"restLoc"];
        self.distance = [dict[@"distance"] floatValue];
        self.responseData = [[NSMutableData alloc] initWithLength:0];
        if (!self.restLoc)
            [self searchCoordinatesForAddress:self.address];
    }
    return self;
}

-(id)initWithData:(NSData*)data
{
    return [self initWithDict:[NSKeyedUnarchiver unarchiveObjectWithData:data]];
}

-(NSMutableDictionary*)serialize{
    
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    [dict setObject:self.address forKey:@"address"];
    [dict setObject:[NSNumber numberWithFloat:self.distance] forKey:@"distance"];
    [dict setObject:self.name forKey:@"name"];
    [dict setObject:[NSNumber numberWithInt:self.percentMatch] forKey:@"percentMatch"];
    [dict setObject:[NSNumber numberWithInt:self.price] forKey:@"price"];
    [dict setObject:self.ratingImg forKey:@"ratingImg"];
    [dict setObject:self.snippetImg forKey:@"snippetImg"];
    [dict setObject:[NSNumber numberWithInt:self.votes] forKey:@"votes"];
    [dict setObject:self.types forKey:@"types"];
    [dict setObject:[NSNumber numberWithBool:self.iVoted] forKey:@"iVoted"];
    [dict setObject:[NSNumber numberWithInt:self.invitation] forKey:@"invitation"];
    [dict setObject:self.url forKey:@"url"];
    return dict;
}

-(NSData*)serializeToData{
    
    return [NSKeyedArchiver archivedDataWithRootObject:[self serialize]];
}
@end
