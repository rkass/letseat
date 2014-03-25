//
//  Restaurant.m
//  Let's Eat
//
//  Created by Ryan Kass on 3/25/14.
//  Copyright (c) 2014 Ryan Kass. All rights reserved.
//

#import "Restaurant.h"

@implementation Restaurant
@synthesize address, distance, name, percentMatch, price, ratingImg, snippetImg, votes, types;
-(id)init:(NSString*)addressInput distanceInput:(NSNumber*)distanceInput nameInput:(NSString*)nameInput percentMatchInput:(NSNumber*)percentMatchInput priceInput:(NSNumber*)priceInput ratingImgInput:(NSString*)ratingImgInput snippetImgInput:(NSString*)snippetImgInput votesInput:(NSNumber *)votesInput typesInput:(NSArray*)typesInput iVotedInput:(BOOL)iVotedInput{
    self = [super init];
    if (self){
        self.address = addressInput;
        self.distance = [distanceInput floatValue];
        self.name = nameInput;
        self.percentMatch = [percentMatchInput integerValue];
        self.price = [priceInput integerValue];
        self.ratingImg = ratingImgInput;
        self.snippetImg = snippetImgInput;
        self.votes = [votesInput integerValue];
        self.types = typesInput;
        self.iVoted = iVotedInput;
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
    return dict;
}

-(NSData*)serializeToData{
    
    return [NSKeyedArchiver archivedDataWithRootObject:[self serialize]];
}
@end
