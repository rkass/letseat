//
//  CreateMealNavigationController.m
//  Let's Eat
//
//  Created by Ryan Kass on 2/23/14.
//  Copyright (c) 2014 Ryan Kass. All rights reserved.
//

#import "CreateMealNavigationController.h"
#import "HomeViewController.h"
#import "WhoViewController.h"



@interface CreateMealNavigationController ()

@end

@implementation CreateMealNavigationController
@synthesize creator, invitation;
- (void)viewDidLoad
{

    [super viewDidLoad];
    self.invitees = [[NSMutableArray alloc] init];
    [self.navigationBar setHidden:YES];
}

/*
-(Invitation*) getInvitation{
    NSLog(@"implement me!");
    return [[Invitation alloc] init];
}*/
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}
-(NSMutableArray*) topN:(int)n{
    NSMutableArray* ret = [[NSMutableArray alloc] init];
    int index = 0;
    for (NSArray* arr in self.orderedCategories){
        if (index < n)
            [ret addObject:arr[0]];
        else
            break;
        index += 1;
    }
    return ret;
}
@end
