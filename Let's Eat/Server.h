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
+ (void)postRequest:(NSString *)method data:(NSData *)data source:(NSObject *)source;
+(NSDictionary *) JSONToDict:(NSString *)jsonString;
+ (NSString *) dictToJSON:(NSDictionary *)dict;
+ (NSString *) arrToJSON:(NSArray *)array;
+(NSString *) url;

@end
