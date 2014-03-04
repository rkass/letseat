//
//  InvitationsViewController.m
//  Let's Eat
//
//  Created by Ryan Kass on 3/3/14.
//  Copyright (c) 2014 Ryan Kass. All rights reserved.
//

#import "InvitationsViewController.h"
#import "User.h"
#import "JSONKit.h"
#import "Invitation.h"

@interface InvitationsViewController ()
@property (strong, nonatomic) IBOutlet UITableView *invitationsTable;
@property (strong, nonatomic) NSMutableArray* passedInvitations;
@property (strong, nonatomic) NSMutableArray* upcomingInvitations;

@end

@implementation InvitationsViewController
@synthesize passedInvitations, upcomingInvitations;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Invitations";
    self.invitationsTable.dataSource = self;
    self.invitationsTable.delegate = self;
    self.passedInvitations = [[[NSUserDefaults standardUserDefaults] arrayForKey:@"passedInvitations"] mutableCopy];
    if (!self.passedInvitations)
        self.passedInvitations = [[NSMutableArray alloc] init];
    self.upcomingInvitations = [[[NSUserDefaults standardUserDefaults] arrayForKey:@"upcomingInvitations"] mutableCopy];
    if (!self.upcomingInvitations)
        self.upcomingInvitations = [[NSMutableArray alloc] init];
    [User getInvitations:self];
	// Do any additional setup after loading the view.
}

- (void) syncInvitations
{
    for (Invitation* i in self.upcomingInvitations){
        if ([i passed]){
            [self.upcomingInvitations removeObject:i];
            [self.passedInvitations addObject:i];
        }
    }
    NSSortDescriptor *dateDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:dateDescriptor];
    self.passedInvitations = [[self.passedInvitations
                                 sortedArrayUsingDescriptors:sortDescriptors] mutableCopy];
    self.upcomingInvitations = [[self.upcomingInvitations sortedArrayUsingDescriptors:sortDescriptors] mutableCopy];
    [LEViewController setUserDefault:@"passedInvitations" data:self.passedInvitations];
    [LEViewController setUserDefault:@"upcomingInvitations" data:self.upcomingInvitations];
}

- (void) addInvitation:(Invitation*)invitation
{
    for (Invitation* i in self.upcomingInvitations){
        if (i.num == invitation.num)
            return;
    }
    for (Invitation* i in self.passedInvitations){
        if (i.num == invitation.num)
            return;
    }
    [self.upcomingInvitations addObject:invitation];
    [self syncInvitations];
}

- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSDictionary *resultsDictionary = [data objectFromJSONData];
    NSLog(@"%@", resultsDictionary);
    for (NSMutableDictionary* dict in resultsDictionary[@"invitations"]){
        Invitation* i = [[Invitation alloc] init:dict[@"id"] timeInput:dict[@"time"] peopleInput:dict[@"people"] messageInput:dict[@"message"]];
        [self addInvitation:i];
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0)
        return [self.upcomingInvitations count];
    return [self.passedInvitations count];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSLog(@"Number of Sections");
    if(section == 0)
        return nil;
    return @"Passed Invitations";
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        
    }
    Invitation *i;
    if (indexPath.section == 0)
        i = [self.upcomingInvitations objectAtIndex:indexPath.row];
    else
        i = [self.passedInvitations objectAtIndex:indexPath.row];
    cell.textLabel.text = [i displayPeople];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"cccc, MMM d, hh:mm aa"];
    cell.detailTextLabel.text = [dateFormat stringFromDate:i.date];
    return cell;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
