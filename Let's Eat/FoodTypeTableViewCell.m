//
//  FoodTypeTableViewCell.m
//  Let's Eat
//
//  Created by Ryan Kass on 5/1/14.
//  Copyright (c) 2014 Ryan Kass. All rights reserved.
//

#import "FoodTypeTableViewCell.h"
#import "Graphics.h"
@interface FoodTypeTableViewCell ()

@end

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
-(void)setLayout:(NSMutableDictionary*)input vc:(WhatViewController *)vc{
    self.wvc = vc;
    self.category = [input[@"category"] boolValue];
    self.stars = [input[@"stars"] intValue];
    self.expanded = [input[@"expanded"] boolValue];
    [self.foodTypeLabel setText:input[@"label"]];
    if (!self.category){
        [self.expandCollapseButton setHidden:YES];
       
    }
    else{
        [self.expandCollapseButton setHidden:NO];
        if (self.expanded){
            [self.expandCollapseButton setImage:expandedImg forState:UIControlStateNormal];
        }
        else{
            [self.expandCollapseButton setImage:collapsedImg forState:UIControlStateNormal];
        }
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
