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

- (NSString *)postRequest:(NSString *)method data:(NSDictionary *)data
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString: [Server.url stringByAppendingString:method]]];
    NSString *jsonRequest = [Server dictToJSON:data];
    NSData *requestData = [NSData dataWithBytes:[jsonRequest UTF8String] length:[jsonRequest length]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%d", [requestData length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody: requestData];
    [NSURLConnection connectionWithRequest:request delegate:self];//auto-release?
    
    return [Server dictToJSON:data];
}
- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSMutableData *d = [NSMutableData data];
    [d appendData:data];
    
    NSString *a = [[NSString alloc] initWithData:d encoding:NSASCIIStringEncoding];
    
    NSLog(@"Data: %@", a);
}

+(NSString *) url { return url; }
+ (NSString *) dictToJSON:(NSDictionary *)dict
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];

    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
        return @"";//TODO:throw exception here
    } else {
        NSString *jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSLog(@"%@",jsonString);
        return jsonString;
    }
}

@end
