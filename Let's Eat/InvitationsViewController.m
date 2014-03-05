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
#import "InviteViewController.h"

@interface InvitationsViewController ()
@property (strong, nonatomic) IBOutlet UITableView *invitationsTable;
@property (strong, nonatomic) NSMutableArray* passedInvitations;
@property (strong, nonatomic) NSMutableArray* upcomingInvitations;
@property (strong, nonatomic) NSIndexPath* selectedIndexPath;

@end

@implementation InvitationsViewController
@synthesize passedInvitations, selectedIndexPath, upcomingInvitations;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Invitations";
    self.invitationsTable.dataSource = self;
    self.invitationsTable.delegate = self;
    self.passedInvitations = [self loadInvitation:@"passedInvitations"];
    self.upcomingInvitations = [self loadInvitation:@"upcomingInvitations"];
    [User getInvitations:self];
	// Do any additional setup after loading the view.
}

- (NSMutableArray*) loadInvitation:(NSString*)invitations
{
    NSMutableArray* ret = [[NSMutableArray alloc] init];
    for (NSMutableDictionary* dict in [[NSUserDefaults standardUserDefaults] arrayForKey:invitations])
        [ret addObject:[[Invitation alloc] initWithDict:dict]];
    return ret;
}

- (void) saveInvitations
{
    NSMutableArray* pi = [[NSMutableArray alloc] init];
    NSMutableArray* ui = [[NSMutableArray alloc] init];
    for(Invitation* i in self.passedInvitations)
        [pi addObject:[i serialize]];
    for (Invitation* i in self.upcomingInvitations)
        [ui addObject:[i serialize]];
    [LEViewController setUserDefault:@"passedInvitations" data:pi];
    [LEViewController setUserDefault:@"upcomingInvitations" data:ui];
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
    NSSortDescriptor *dateDescriptor2 = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObject:dateDescriptor];
    NSArray *sortDescriptors2 = [NSArray arrayWithObject:dateDescriptor2];
    self.passedInvitations = [[self.passedInvitations
                                 sortedArrayUsingDescriptors:sortDescriptors2] mutableCopy];
    self.upcomingInvitations = [[self.upcomingInvitations sortedArrayUsingDescriptors:sortDescriptors] mutableCopy];
    [self saveInvitations];
}

- (void) addInvitation:(Invitation*)invitation
{
    Invitation* remove;
    for (Invitation* i in self.upcomingInvitations){
        if (i.num == invitation.num){
            remove = i;
            break;
        }
    }
    if (remove)
        [self.upcomingInvitations removeObject:remove];
    remove = nil;
    for (Invitation* i in self.passedInvitations){
        if (i.num == invitation.num){
            remove = i;
            break;
        }
    }
    if (remove)
        [self.passedInvitations removeObject:remove];
    [self.upcomingInvitations addObject:invitation];
    [self syncInvitations];
}

- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSDictionary *resultsDictionary = [data objectFromJSONData];
    for (NSMutableDictionary* dict in resultsDictionary[@"invitations"]){
        Invitation* i = [[Invitation alloc] init:dict[@"id"] timeInput:dict[@"time"] peopleInput:dict[@"people"] messageInput:dict[@"message"] iRespondedInput:[dict[@"iResponded"] boolValue] creatorIndexInput:dict[@"creatorIndex"] responseArrayInput:dict[@"responses"]];
        [self addInvitation:i];
    }
    [self.invitationsTable reloadData];
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
    if(section == 0)
        return @"Upcoming Invitations";
    return @"Passed Invitations";
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
        
    }
    Invitation *i;
    if (indexPath.section == 0)
        i = [self.upcomingInvitations objectAtIndex:indexPath.row];
    else
        i = [self.passedInvitations objectAtIndex:indexPath.row];
    cell.textLabel.text = [i displayPeople];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"cccc, MMM d, hh:mm aa"];
    if (!i.iResponded && indexPath.section == 0)
        cell.backgroundColor = [UIColor redColor];
    else
        cell.backgroundColor = [UIColor clearColor];
    cell.detailTextLabel.text = [dateFormat stringFromDate:i.date];
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"invitationsToInvite"]){
        InviteViewController *iv = (InviteViewController *)segue.destinationViewController;
        NSMutableArray* arr = self.upcomingInvitations;
        if (self.selectedIndexPath.section == 1)
            arr = self.passedInvitations;
        iv.invitation = arr[self.selectedIndexPath.row];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.selectedIndexPath = indexPath;
    [self performSegueWithIdentifier:@"invitationsToInvite" sender:self];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
