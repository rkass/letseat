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
  //  [self.progressSlider setThumbImage:[[UIImage alloc] init] forState:UIControlStateNormal];
    UIImageView* sliderfill = [[UIImageView alloc] initWithImage:GET_IMG(@"sliderfill2")];
    if ([titleInput isEqualToString:@"Respond1"]){
        [self.pathTitleButton setTitle:@"Respond" forState:UIControlStateNormal];
        [sliderfill setFrame:CGRectMake(self.slidertrack.frame.origin.x, self.slidertrack.frame.origin.y, 213, self.slidertrack.frame.size.height)];
    }
    else if ([titleInput isEqualToString:@"Create Invitation"]){
        [self.pathTitleButton setTitle:@"Create Invitation" forState:UIControlStateNormal];
        [sliderfill setFrame:CGRectMake(self.slidertrack.frame.origin.x, self.slidertrack.frame.origin.y, 213, self.slidertrack.frame.size.height)];
        
    }
    else if ([titleInput isEqualToString:@"Create Invitation Button"]){
        [self setBackgroundColor:[UIColor colorWithPatternImage:GET_IMG(@"createinvitation")]];
        [sliderfill setFrame:CGRectMake(self.slidertrack.frame.origin.x, self.slidertrack.frame.origin.y, 320, self.slidertrack.frame.size.height)];
        NSLog(@"my height %f", self.frame.size.height);
    }
    else if ([titleInput isEqualToString:@"Create Invitation Button2"]){
        [self setBackgroundColor:[UIColor colorWithPatternImage:GET_IMG(@"respond")]];
        [sliderfill setFrame:CGRectMake(self.slidertrack.frame.origin.x, self.slidertrack.frame.origin.y, 320, self.slidertrack.frame.size.height)];
        NSLog(@"my height %f", self.frame.size.height);
    }
    else if ([titleInput isEqualToString:@"CI"]){
        [self setBackgroundColor:[UIColor colorWithPatternImage:GET_IMG(@"createinvitation")]];
        [sliderfill setFrame:CGRectMake(self.slidertrack.frame.origin.x, self.slidertrack.frame.origin.y, 320/3, self.slidertrack.frame.size.height)];
    }
    else if ([titleInput isEqualToString:@"Attend Meal"])
    {
        [self.pathTitleButton   setTitle:@"Attend Meal" forState:UIControlStateNormal ];
    }
    [self addSubview:sliderfill];
    
    [self setBackgroundColor:[UIColor colorWithRed:255 green:255 blue:255 alpha:.35]];
    
  //  [self.backgroundView setAlpha:.1];



}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
