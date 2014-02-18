//
//  PostRequest.m
//  Let's Eat
//
//  Created by Ryan Kass on 2/14/14.
//  Copyright (c) 2014 Ryan Kass. All rights reserved.
//

#import "Server.h"



@implementation Server

static NSString* url = @"http://localhost:3000/api/v1/";

+ (void)postRequest:(NSString *)method data:(NSData *)data source:(NSObject *)source
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString: [Server.url stringByAppendingString:method]]];
    //NSData *requestData = [NSData dataWithBytes:[data UTF8String] length:[data length]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%d", [data length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody: data];
    [NSURLConnection connectionWithRequest:request delegate:source];//auto-release?

}

+(NSString *) url { return url; }
+(NSDictionary *) JSONToDict:(NSString *)jsonString
{
    NSData * jsonData = [jsonString dataUsingEncoding:NSASCIIStringEncoding];
    NSError * error=nil;
    return [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
}
+ (NSString *) arrToJSON:(NSArray *)array
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:&error];
    
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
        return @"";//TODO:throw exception here
    } else {
        NSString *jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        return jsonString;
    }
}
+ (NSString *) dictToJSON:(NSDictionary *)dict
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];

    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
        return @"";//TODO:throw exception here
    } else {
        NSString *jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        return jsonString;
    }
}

@end
