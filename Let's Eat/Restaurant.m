//
//  Restaurant.m
//  Let's Eat
//
//  Created by Ryan Kass on 3/25/14.
//  Copyright (c) 2014 Ryan Kass. All rights reserved.
//

#import "Restaurant.h"

@implementation Restaurant
@synthesize address, distance, name, percentMatch, price, ratingImg, snippetImg, votes, types, invitation, url;
-(id)init:(NSString*)addressInput distanceInput:(NSNumber*)distanceInput nameInput:(NSString*)nameInput percentMatchInput:(NSNumber*)percentMatchInput priceInput:(NSNumber*)priceInput ratingImgInput:(NSString*)ratingImgInput snippetImgInput:(NSString*)snippetImgInput votesInput:(NSNumber *)votesInput typesInput:(NSArray*)typesInput iVotedInput:(BOOL)iVotedInput invitationInput:(int)invitationInput urlInput:(NSString*)urlInput{
    self = [super init];
    if (self){
        self.address = addressInput;
        if (!distanceInput){
            NSLog(@"distance null for %@", urlInput);
            self.distance = 5;
        }
        else
            self.distance = [distanceInput floatValue];
        self.name = nameInput;
        if (!percentMatchInput){
            self.percentMatch = 50;
            NSLog(@"percent match null for %@", urlInput);
        }
        else
            self.percentMatch = [percentMatchInput integerValue];
        if (!priceInput){
            self.price = 2;
            NSLog(@"price null for %@", urlInput);
        }
        else
            self.price = [priceInput integerValue];
        self.ratingImg = ratingImgInput;
        self.snippetImg = snippetImgInput;
        if (!votesInput){
            self.votes = 0;
            NSLog(@"votes null for %@", urlInput);
        }
        else
            self.votes = [votesInput integerValue];
        self.types = typesInput;
        self.iVoted = iVotedInput;
        self.invitation = invitationInput;
        self.url = urlInput;
    }
    return self;
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
