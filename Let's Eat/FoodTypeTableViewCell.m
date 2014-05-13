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
-(void)expandCollapse{
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
        [self setBackgroundColor:[UIColor clearColor]/*[Graphics colorWithHexString:color2]*/];
        [self.expandCollapseIV setHidden:YES];
       
    }
    else{
        [self setBackgroundColor:[Graphics colorWithHexString:color14]];
        [self.expandCollapseIV setHidden:NO];
        if (self.expanded){
            [self.expandCollapseIV setImage:GET_IMG(@"expanded")];
        }
        else{
            [self.expandCollapseIV setImage: GET_IMG(@"collapsed")];
  
        }
        [self.expandCollapseIV setHidden:NO];
    }
    [self setBackgroundColor:[UIColor clearColor]];
    [self setRatingButtonWithImage];
   // self.ratingButton setTintColor:[UIColor]

    
  
    
    

   
}
-(void)setRatingButtonWithImage{
    if (self.stars == 0){
        [self.ratingButton setImage:GET_IMG(@"nostars") forState:UIControlStateNormal];
       /* if (self.category){
            
            [self.ratingButton setImage:GET_IMG(@"NoStarsPressed") forState:UIControlStateHighlighted];
        }
        else{
            [self.ratingButton setImage:GET_IMG(@"NoStarsSmall") forState:UIControlStateNormal];
            [self.ratingButton setImage:GET_IMG(@"NoStarsSmallPressed") forState:UIControlStateHighlighted];
        }*/
    }
    else if (self.stars == 1){
        [self.ratingButton setImage:GET_IMG(@"onestar") forState:UIControlStateNormal];
       /* if (self.category){
            [self.ratingButton setImage:oneStarImg forState:UIControlStateNormal];
            
        }
        else{
            [self.ratingButton setImage:GET_IMG(@"OneStarSmall") forState:UIControlStateNormal];
            [self.ratingButton setImage:GET_IMG(@"OneStarSmallPressed") forState:UIControlStateHighlighted];
        }*/
    }
    else if (self.stars == 2){
        [self.ratingButton setImage:GET_IMG(@"twostars") forState:UIControlStateNormal];/*
        if (self.category){
            [self.ratingButton setImage:GET_IMG(@"twostars") forState:UIControlStateNormal];
            [self.ratingButton setImage:GET_IMG(@"TwoStarsPressed") forState:UIControlStateHighlighted];
        }
        else{
            [self.ratingButton setImage:GET_IMG(@"TwoStarsSmall") forState:UIControlStateNormal];
            [self.ratingButton setImage:GET_IMG(@"TwoStarsSmallPressed") forState:UIControlStateHighlighted];
        }*/
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
