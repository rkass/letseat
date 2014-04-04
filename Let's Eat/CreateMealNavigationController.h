//
//  CreateMealNavigationController.h
//  Let's Eat
//
//  Created by Ryan Kass on 2/23/14.
//  Copyright (c) 2014 Ryan Kass. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Invitation.h"

@interface CreateMealNavigationController : UINavigationController
@property Invitation* invitation;
@property BOOL creator;


@end
