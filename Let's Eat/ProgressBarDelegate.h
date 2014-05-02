//
//  ProgressBarDelegate.h
//  Let's Eat
//
//  Created by Ryan Kass on 5/1/14.
//  Copyright (c) 2014 Ryan Kass. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProgressBarDelegate : NSObject <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) NSString* title;
-(id) initWithTitle:(NSString*)titleInput;
@end
