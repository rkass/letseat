//
//  NonScheduledTableViewCell.m
//  Let's Eat
//
//  Created by Ryan Kass on 5/15/14.
//  Copyright (c) 2014 Ryan Kass. All rights reserved.
//

#import "NonScheduledTableViewCell.h"
#import "InviteViewController.h"
#import "Graphics.h"

@implementation NonScheduledTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}
-(void)setWithIVC:(InviteViewController*)ivcInput{
    NSLog(@"I was called");
    self.ivc = ivcInput;
    NSString* component = [self.ivc.invitation.creator componentsSeparatedByString:@" "][0];
    if ([component hasSuffix:@"s"])
        self.messageHeader.text = [NSString stringWithFormat:@"%@' Message:", component];
    else if ([component hasSuffix:@"You"])
        self.messageHeader.text = @"Your Message:";
    else
        self.messageHeader.text = [NSString stringWithFormat:@"%@'s Message:", component];
    if (self.ivc.invitation.message.length >80)
        self.message.text = [self.ivc.invitation.message substringToIndex:80];
    else
        self.message.text = self.ivc.invitation.message;
    if ([self.message.text isEqualToString:@""])
        self.message.text = @"Let's Eat!\n     ";
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    if (self.message.text.length > 40)
        [self setBackgroundColor:[UIColor colorWithPatternImage:GET_IMG(@"bigmessagebackground")]];
    else
        [self setBackgroundColor:[UIColor colorWithPatternImage:GET_IMG(@"messagebackground")]];
    [self.messageHeader setTextColor:[Graphics colorWithHexString:@"62ab3c"]];
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
