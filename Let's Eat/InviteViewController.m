//
//  InviteViewController.m
//  Let's Eat
//
//  Created by Ryan Kass on 3/4/14.
//  Copyright (c) 2014 Ryan Kass. All rights reserved.
//

#import "InviteViewController.h"

@interface InviteViewController ()
@property (strong, nonatomic) IBOutlet UITableView *rsvpTable;
@property (strong, nonatomic) NSMutableArray* going;
@property (strong, nonatomic) NSMutableArray* undecided;
@property (strong, nonatomic) IBOutlet UIButton *yes;
@property (strong, nonatomic) NSMutableArray* notGoing;
@property (strong, nonatomic) IBOutlet UIButton *no;
@end

@implementation InviteViewController
@synthesize invitation, rsvpTable, going, undecided, notGoing, yes, no;

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([[self.invitation creator] isEqualToString:@"You"])
        self.title = @"Your Invitation";
    else
        self.title = [NSString stringWithFormat:@"Invite from %@", [self.invitation creator]];
    self.rsvpTable.delegate = self;
    self.rsvpTable.dataSource = self;
    NSMutableArray* arrays = [self.invitation generateResponsesArrays];
    self.going = arrays[0];
    self.undecided = arrays[1];
    self.notGoing = arrays[2];
    if (self.invitation.iResponded){
        self.yes.hidden = YES;
        self.no.hidden = YES;
    }
        
	
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0)
        return [self.going count];
    if (section == 1)
        return [self.undecided count];
    return [self.notGoing count];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(section == 0)
        return @"Going";
    if (section == 1)
        return @"Undecided";
    return @"Not Going";
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        
    }
    NSString* p;
    if (indexPath.section == 0)
        p = [self.going objectAtIndex:indexPath.row];
    else if (indexPath.section == 1)
        p = [self.undecided objectAtIndex:indexPath.row];
    else
        p = [self.notGoing objectAtIndex:indexPath.row];
    cell.textLabel.text = p;
    return cell;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
