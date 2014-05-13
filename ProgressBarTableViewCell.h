//
//  ProgressBarTableViewCell.h
//  Let's Eat
//
//  Created by Ryan Kass on 5/1/14.
//  Copyright (c) 2014 Ryan Kass. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LEViewController.h"

@interface ProgressBarTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *slidertrack;
@property (strong, nonatomic) IBOutlet UIButton *pathTitleButton;


-(void)setLayout:(NSString*) titleInput;
@end
