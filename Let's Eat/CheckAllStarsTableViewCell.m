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
#import "InviteViewController.h"
#import "InvitationsViewController.h"
#import "WhoViewController.h"
#import "TellFriendsViewController.h"
#import "RestaurantViewController.h"
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
    if (self.wvc){
        self.state = (self.state % 3) + 1;
        NSLog(@"pressed %u", self.state);
        [self.wvc statePressed:self.state];
    }
    if (self.whovc){
        [self.whovc performSegueWithIdentifier:@"whoToTellFriends" sender:self];
    }
}
-(void)setWithTellFriends:(TellFriendsViewController *)tfii{
    self.tfi = tfii;
    [self generalSetup];
}
-(void)setWithInvitationVC:(InvitationsViewController *)iivcInput{
    self.iivc = iivcInput;
    [self generalSetup];
}
-(void)setWithWhoVC:(WhoViewController *)whoInput{
    self.whovc = whoInput;
    [self generalSetup];
}
-(void)setWithInviteVC:(InviteViewController *)ivcInput{
    self.ivc = ivcInput;
    [self generalSetup];
}
-(void)setWithRVC:(RestaurantViewController*)rvcInput{
    self.rvc = rvcInput;
    [self.titleLabel setText:self.rvc.restaurant.name];
    [self generalSetup];
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
    if (self.rvc){
        if ([self.rvc.yelpView canGoBack])
            [self.rvc.yelpView goBack];
        else
            [self.rvc.navigationController popViewControllerAnimated:YES];
    }
    if (self.tfi)
        [self.tfi.navigationController popViewControllerAnimated:YES];
    else if (self.iivc)
       [ self.iivc.navigationController popToRootViewControllerAnimated:YES];
    else if (self.whovc)
        [self.whovc.navigationController popToRootViewControllerAnimated:YES];
    else if (self.ivc){
        NSArray* vc = [self.ivc.navigationController viewControllers];
        if ([vc[vc.count - 2] isKindOfClass:[InvitationsViewController class]]){
            [self.ivc.navigationController popViewControllerAnimated:YES];
        }
        else{
            
            [self.ivc performSegueWithIdentifier:@"inviteToInvitations" sender:self];
        }
    }
    else if (self.pvc){
        [self.pvc.navigationController popViewControllerAnimated:YES];
    }
    else
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
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    [self setBackgroundColor:[UIColor colorWithPatternImage:GET_IMG(@"menubar")]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
