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
#import "PriceViewController.h"
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
-(void)setWithPriceVC:(PriceViewController*)pvcInput{
    self.pvc = pvcInput;
    [self generalSetup];
}
- (IBAction)leftButtonPressed:(id)sender {
    //different code when not the back button
    if (self.pvc){
        [self.pvc.navigationController popViewControllerAnimated:YES];
    }
    [self.wvc.navigationController popViewControllerAnimated:YES];
}

-(void)setWithState:(int)state vc:(WhatViewController*)vc{

    NSLog(@"setting with state %u", state);
    self.wvc = vc;
    self.state = state;
    if (self.state == 0){
        [self.stateButton setImage:GET_IMG(@"nostarsall") forState:UIControlStateNormal];
    }
    else if (self.state == 1){
        [self.stateButton setImage:GET_IMG(@"nostarsall") forState:UIControlStateNormal];
    }
    else if (self.state == 2){
        [self.stateButton setImage:GET_IMG(@"onestarall") forState:UIControlStateNormal];
    }
    else if (self.state == 3){
        [self.stateButton setImage:GET_IMG(@"twostarsall") forState:UIControlStateNormal];
    }
    [self generalSetup];

}
-(void)generalSetup{
    [self setBackgroundColor:[UIColor colorWithPatternImage:GET_IMG(@"menubar")]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
