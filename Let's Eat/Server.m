//
//  PostRequest.m
//  Let's Eat
//
//  Created by Ryan Kass on 2/14/14.
//  Copyright (c) 2014 Ryan Kass. All rights reserved.
//

#import "Server.h"
#import "JSONKit.h"


@implementation Server

static NSString* prod = @"http://immense-fortress-7865.herokuapp.com/api/v1/";
static NSString* testing = @"http://localhost:3000/api/v1/";
static bool production = YES;

+ (void)postRequest:(NSString *)method data:(NSData *)data source:(NSObject *)source
{

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString: [Server.url stringByAppendingString:method]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%d", [data length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody: data];
    [request setTimeoutInterval:5];
    [NSURLConnection connectionWithRequest:request delegate:source];

}

+(NSString *) url { if (production) return prod; else return testing;}
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
