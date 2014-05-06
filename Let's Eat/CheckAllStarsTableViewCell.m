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
- (IBAction)statePressed:(id)sender {
    self.state = (self.state % 3) + 1;
    NSLog(@"pressed %u", self.state);
    [self.wvc statePressed:self.state];
}

- (void)awakeFromNib
{
    // Initialization code
}

-(void)setWithState:(int)state vc:(WhatViewController*)vc{
    NSLog(@"setting with state %u", state);
    self.wvc = vc;
    self.state = state;
    if (self.state == 0){
        [self.stateButton setImage:GET_IMG(@"NoStarsAllOff") forState:UIControlStateNormal];
    }
    else if (self.state == 1){
        [self.stateButton setImage:GET_IMG(@"NoStarsAllOff") forState:UIControlStateNormal];
    }
    else if (self.state == 2){
        [self.stateButton setImage:GET_IMG(@"OneStarAllOff") forState:UIControlStateNormal];
    }
    else if (self.state == 3){
        [self.stateButton setImage:GET_IMG(@"TwoStarsAllOff") forState:UIControlStateNormal];
    }

    [self setBackgroundColor:[UIColor colorWithPatternImage:GET_IMG(@"BlueBarBackground")]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
