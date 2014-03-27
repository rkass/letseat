//
//  Restaurant.h
//  Let's Eat
//
//  Created by Ryan Kass on 3/25/14.
//  Copyright (c) 2014 Ryan Kass. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Restaurant : NSObject

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
@property BOOL iVoted;
-(id)init:(NSString*)addressInput distanceInput:(NSNumber*)distanceInput nameInput:(NSString*)nameInput percentMatchInput:(NSNumber*)percentMatchInput priceInput:(NSNumber*)priceInput ratingImgInput:(NSString*)ratingImgInput snippetImgInput:(NSString*)snippetImgInput votesInput:(NSNumber*)votesInput typesInput:(NSArray*)typesInput iVotedInput:(BOOL)iVotedInput invitationInput:(int)invitationInput urlInput:(NSString*)urlInput;
-(id)initWithData:(NSData*)data;
-(NSData*)serializeToData;
-(NSMutableDictionary*)serialize;
@end
