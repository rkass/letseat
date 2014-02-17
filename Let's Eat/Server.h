//
//  PostRequest.h
//  Let's Eat
//
//  Created by Ryan Kass on 2/14/14.
//  Copyright (c) 2014 Ryan Kass. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Server: NSObject

//Assume JSON encoding
- (NSDictionary *)postRequest:(NSString *)method data:(NSDictionary *)data;

+(NSString *) url;

@end
