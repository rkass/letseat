//
//  FoodTypeTableViewCell.m
//  Let's Eat
//
//  Created by Ryan Kass on 5/1/14.
//  Copyright (c) 2014 Ryan Kass. All rights reserved.
//

#import "FoodTypeTableViewCell.h"
#import "Graphics.h"
#import "WhatViewController.h"

@implementation FoodTypeTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}
- (IBAction)expandCollapse:(id)sender {
    if (self.expanded){
        [self.wvc collapseCategory:self.foodTypeLabel.text];
    }
    else{
        [self.wvc expandCategory:self.foodTypeLabel.text];
    }
}
-(void)updateRow{
    NSMutableArray* reviseIndices = [[NSMutableArray alloc] init];
    int cnt = 0;
    for (NSMutableDictionary* dict in self.wvc.foodTypes){
        if ([dict[@"label"] isEqualToString:self.foodTypeLabel.text] && ([dict[@"category"] boolValue] == self.category)){
            [reviseIndices addObject:[NSIndexPath indexPathForRow:cnt inSection:0] ];
            break;
        }
        cnt += 1;
    }
    [self.wvc updateFoodTypesTable:nil editIndices:reviseIndices removeIndices:nil];
    
}
- (IBAction)ratingButtonPressed:(id)sender {
    
   
    [self.wvc ratingPressed:self];
}
-(void)setLayout:(NSMutableDictionary*)input vc:(WhatViewController *)vc{
    self.wvc = vc;
    self.category = [input[@"category"] boolValue];
    self.stars = [input[@"stars"] intValue];
    self.expanded = [input[@"expanded"] boolValue];
    [self.foodTypeLabel setText:input[@"label"]];
    if (!self.category){
        [self setBackgroundColor:[UIColor whiteColor]];
        [self.expandCollapseButton setHidden:YES];
       
    }
    else{
        [self setBackgroundColor:[Graphics colorWithHexString:color14]];
        [self.expandCollapseButton setHidden:NO];
        if (self.expanded){
            [self.expandCollapseButton setImage:expandedImg forState:UIControlStateNormal];
        }
        else{
            [self.expandCollapseButton setImage:collapsedImg forState:UIControlStateNormal];
        }
    }
    if (self.stars == 0){
        if (self.category)
            [self.ratingButton setImage:noStarsImg forState:UIControlStateNormal];
        else
            [self.ratingButton setImage:noStarsSmallImg forState:UIControlStateNormal];
    }
    else if (self.stars == 1){
        if (self.category)
            [self.ratingButton setImage:oneStarImg forState:UIControlStateNormal];
        else
            [self.ratingButton setImage:oneStarSmallImg forState:UIControlStateNormal];
    }
    else if (self.stars == 2){
        if (self.category)
            [self.ratingButton setImage:twoStarsImg forState:UIControlStateNormal];
        else
            [self.ratingButton setImage:twoStarsSmallImg forState:UIControlStateNormal];
    }

    
  
    
    

   
}
- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
