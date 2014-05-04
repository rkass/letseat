//
//  CheckAllStarsTableViewCell.m
//  Let's Eat
//
//  Created by Ryan Kass on 5/2/14.
//  Copyright (c) 2014 Ryan Kass. All rights reserved.
//

#import "CheckAllStarsTableViewCell.h"
#import "Graphics.h"
#import "WhatViewController.h"
@implementation CheckAllStarsTableViewCell

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
- (IBAction)twoStarsPressed:(id)sender {
    [self.wvc statePressed:3];
}
- (IBAction)oneStarPressed:(id)sender {
    [self.wvc statePressed:2];
}
- (IBAction)noStarsPressed:(id)sender {
    [self.wvc statePressed:1];
}
-(void)setWithState:(int)state vc:(WhatViewController*)vc{
    self.wvc = vc;
    self.state = state;
    if (self.state == 0){
        [self.noStarsButton setImage:GET_IMG(@"NoStarsAllOff") forState:UIControlStateNormal];
        [self.oneStarButton setImage:GET_IMG(@"OneStarAllOff") forState:UIControlStateNormal];
        [self.twoStarsButton setImage:GET_IMG(@"TwoStarsAllOff") forState:UIControlStateNormal];
    }
    else if (self.state == 1){
        [self.noStarsButton setImage:GET_IMG(@"NoStarsAllOn") forState:UIControlStateNormal];
        [self.oneStarButton setImage:GET_IMG(@"OneStarAllOff") forState:UIControlStateNormal];
        [self.twoStarsButton setImage:GET_IMG(@"TwoStarsAllOff") forState:UIControlStateNormal];
    }
    else if (self.state == 2){
        [self.noStarsButton setImage:GET_IMG(@"NoStarsAllOff") forState:UIControlStateNormal];
        [self.oneStarButton setImage:GET_IMG(@"OneStarAllOn") forState:UIControlStateNormal];
        [self.twoStarsButton setImage:GET_IMG(@"TwoStarsAllOff") forState:UIControlStateNormal];
    }
    else if (self.state == 3){
        [self.noStarsButton setImage:GET_IMG(@"NoStarsAllOff") forState:UIControlStateNormal];
        [self.oneStarButton setImage:GET_IMG(@"OneStarAllOff") forState:UIControlStateNormal];
        [self.twoStarsButton setImage:GET_IMG(@"TwoStarsAllOn") forState:UIControlStateNormal];
    }
    [self.noStarsButton setImage:GET_IMG(@"NoStarsAllOn") forState:UIControlStateHighlighted];
    [self.oneStarButton setImage:GET_IMG(@"OneStarAllOn") forState:UIControlStateHighlighted];
    [self.twoStarsButton setImage:GET_IMG(@"TwoStarsAllOn") forState:UIControlStateHighlighted];
    [self setBackgroundColor:[UIColor clearColor]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
