//
//  ProgressBarDelegate.m
//  Let's Eat
//
//  Created by Ryan Kass on 5/1/14.
//  Copyright (c) 2014 Ryan Kass. All rights reserved.
//

#import "ProgressBarDelegate.h"
#import "ProgressBarTableViewCell.h"
@implementation ProgressBarDelegate

-(id) initWithTitle:(NSString*)titleInput{
    self = [super init];
    self.title = titleInput;
    return self;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"here and stuff");
    ProgressBarTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"ProgressBar"];
    [cell setLayout:self.title];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

@end
