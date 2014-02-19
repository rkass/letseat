//
//  ValidationViewController.h
//  Let's Eat
//
//  Created by Ryan Kass on 2/19/14.
//  Copyright (c) 2014 Ryan Kass. All rights reserved.
//

#import "LEViewController.h"

@interface ValidationViewController : LEViewController
@property (strong, nonatomic) IBOutlet UITextField *username;
@property (strong, nonatomic) IBOutlet UITextField *password;
- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;
@end
