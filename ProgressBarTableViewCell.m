//
//  ProgressBarTableViewCell.m
//  Let's Eat
//
//  Created by Ryan Kass on 5/1/14.
//  Copyright (c) 2014 Ryan Kass. All rights reserved.
//
#import "Graphics.h"
#import "ProgressBarTableViewCell.h"
#import "WhoViewController.h"
#import "WhatViewController.h"
#import "PriceViewController.h"
#import "CreateMealNavigationController.h"
@implementation ProgressBarTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

-(void)setLayout:(NSString*)titleInput{
    [self.progressSlider setThumbImage:[[UIImage alloc] init] forState:UIControlStateNormal];
    if ([titleInput isEqualToString:@"Create Invitation"]){
        [self.pathTitleButton setTitle:@"Create Invitation" forState:UIControlStateNormal];
        [self.progressSlider setValue:(2.0/3.0)];
    }
    else if ([titleInput isEqualToString:@"Attend Meal"])
    {
        [self.pathTitleButton   setTitle:@"Attend Meal" forState:UIControlStateNormal ];
        [self.progressSlider setValue:0.5];
    }
    [self.progressSlider setTintColor:[Graphics colorWithHexString:color3]];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
