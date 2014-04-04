//
//  Restaurant.h
//  Let's Eat
//
//  Created by Ryan Kass on 3/25/14.
//  Copyright (c) 2014 Ryan Kass. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "InviteViewController.h"

@interface Restaurant : NSObject
@property (strong, nonatomic) CLLocation* restLoc;
@property (strong, nonatomic) CLLocation* myLocation;
@property (strong, nonatomic) NSString* address;
@property float distance;
@property int percentMatch;
@property int price;
@property int votes;
@property int invitation;
@property (strong, nonatomic) NSString* url;
@property (strong, nonatomic) NSArray* types;
@property (strong, nonatomic) NSString* name;
@property (strong, nonatomic) NSString* ratingImg;
@property (strong, nonatomic) NSString* snippetImg;
@property (strong, nonatomic) InviteViewController* ivc;
@property BOOL iVoted;
@property NSMutableData* responseData;
-(id)init:(NSString*)addressInput distanceInput:(NSNumber*)distanceInput nameInput:(NSString*)nameInput percentMatchInput:(NSNumber*)percentMatchInput priceInput:(NSNumber*)priceInput ratingImgInput:(NSString*)ratingImgInput snippetImgInput:(NSString*)snippetImgInput votesInput:(NSNumber*)votesInput typesInput:(NSArray*)typesInput iVotedInput:(BOOL)iVotedInput invitationInput:(int)invitationInput urlInput:(NSString*)urlInput InviteViewControllerInput:(InviteViewController*)InviteViewControllerInput;
-(id)init:(NSString*)addressInput nameInput:(NSString*)nameInput percentMatchInput:(NSNumber*)percentMatchInput priceInput:(NSNumber*)priceInput ratingImgInput:(NSString*)ratingImgInput snippetImgInput:(NSString*)snippetImgInput votesInput:(NSNumber*)votesInput typesInput:(NSArray*)typesInput iVotedInput:(BOOL)iVotedInput urlInput:(NSString*)urlInput myLocationInput:(CLLocation*)myLocationInput;
-(id)initWithData:(NSData*)data;
-(void)setInviteAndDistance:(InviteViewController*)ivcin;
-(NSData*)serializeToData;
-(NSMutableDictionary*)serialize;
@end
