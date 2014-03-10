//
//  Graphics.h
//  Let's Eat
//
//  Created by Ryan Kass on 3/10/14.
//  Copyright (c) 2014 Ryan Kass. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Graphics : NSObject
+ (UIColor *) colorWithHexString: (NSString *) hexString;
+ (UIImage *) makeThumbnailOfSize:(UIImage*)img size:(CGSize)size;
@end
