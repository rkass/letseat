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
#import "Graphics.h"

@interface InvitationsViewController ()

@property (strong, nonatomic) NSIndexPath* selectedIndexPath;
@property (strong, nonatomic) UIImage* carrot;
@property (strong, nonatomic) UIImage* reply;
@property (strong, nonatomic) NSNumber* acquired;
@end

@implementation InvitationsViewController
@synthesize passedInvitations, selectedIndexPath, upcomingInvitations, carrot, reply, acquired;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.acquired = [NSNumber numberWithInt:0];
    UIImage* bigCarrot = [UIImage imageNamed:@"OrangeCarrot"];
    self.carrot = [Graphics makeThumbnailOfSize:bigCarrot size:CGSizeMake(10, 10)];
    UIImage* bigReply = [UIImage imageNamed:@"Reply"];
    self.reply = [Graphics makeThumbnailOfSize:bigReply size:CGSizeMake(14, 18)];
    self.title = @"Invitations";
    self.invitationsTable.dataSource = self;
    self.invitationsTable.delegate = self;
    self.invitationsTable.backgroundColor = [Graphics colorWithHexString:@"f5f0df"];
    self.passedInvitations = [self loadInvitation:@"passedInvitations"];
    self.upcomingInvitations = [self loadInvitation:@"upcomingInvitations"];
    [self syncInvitations];
    [self.invitationsTable reloadData];
    [User getInvitations:self];
    [self.navigationController setNavigationBarHidden:NO];
    UIImage *bigImg = [UIImage imageNamed:@"HomeBack"];
    UIImage* backImg = [Graphics makeThumbnailOfSize:bigImg size:CGSizeMake(37,22)];
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    back.bounds = CGRectMake( 0, 0, backImg.size.width, backImg.size.height );
    [back setImage:backImg forState:UIControlStateNormal];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:back];
    [back addTarget:self action:@selector(homePressed:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = backItem;
	// Do any additional setup after loading the view.
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

-(void)homePressed:(UIBarButtonItem*)sender{
    [self.navigationController popToRootViewControllerAnimated:YES];
    self.navigationController.navigationBarHidden = YES;
}

- (NSMutableArray*) loadInvitation:(NSString*)invitations
{
    NSMutableArray* ret = [[NSMutableArray alloc] init];
    for (NSData* data in [[NSUserDefaults standardUserDefaults] arrayForKey:invitations])
        [ret addObject:[[Invitation alloc] initWithData:data]];
    return ret;
}

- (void) saveInvitations
{
    NSMutableArray* pi = [[NSMutableArray alloc] init];
    NSMutableArray* ui = [[NSMutableArray alloc] init];
    for(Invitation* i in self.passedInvitations)
        [pi addObject:[i serializeToData]];
    for (Invitation* i in self.upcomingInvitations)
        [ui addObject:[i serializeToData]];
    [LEViewController setUserDefault:@"passedInvitations" data:pi];
    [LEViewController setUserDefault:@"upcomingInvitations" data:ui];
}

- (void) syncInvitations
{
    NSMutableArray* removals = [[NSMutableArray alloc] init];
    for (Invitation* i in self.upcomingInvitations){
        if ([i passed] || [i respondedNo])
            [removals addObject:i];
    }
    for (Invitation* i in removals){
        [self.upcomingInvitations removeObject:i];
        [self.passedInvitations addObject:i];
    }
    [removals removeAllObjects];
    for (Invitation* i in self.passedInvitations){
        if ([i respondedNo])
           [removals addObject:i];
    }
    for (Invitation* i in removals)
        [self.passedInvitations removeObject:i];
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
    [self.upcomingInvitations addObject:invitation];
    [self syncInvitations];
}

- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    @synchronized(self.acquired){
        if(self.acquired.integerValue == 1)
            return;
    }
    NSDictionary *resultsDictionary = [data objectFromJSONData];
    NSLog(@"%@", resultsDictionary);
    if(!resultsDictionary){
        @synchronized(self.acquired){
            NSLog(@"in here");
            if (self.acquired.integerValue == 0){
                NSLog(@"recalling");
                [User getInvitations:self];
                
            }
        }
        return;
    }
    else{
        @synchronized(self.acquired){
            self.acquired = [NSNumber numberWithInt:1];
        }
    }
    [self.passedInvitations removeAllObjects];
    [self.upcomingInvitations removeAllObjects];

    for (NSMutableDictionary* dict in resultsDictionary[@"invitations"]){
      //  NSLog(@"%@", dict);
        Invitation* i = [[Invitation alloc] init:dict[@"id"] timeInput:dict[@"time"] peopleInput:dict[@"people"] messageInput:dict[@"message"] iRespondedInput:[dict[@"iResponded"] boolValue] creatorIndexInput:dict[@"creatorIndex"] responseArrayInput:dict[@"responses"] centralInput:[dict[@"central"] boolValue] preferencesInput:dict[@"preferences"]];
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
    [dateFormat setDateFormat:@"cccc, MMM d, h:mm aa"];
    if (!i.iResponded && indexPath.section == 0)
        cell.accessoryView = [[UIImageView alloc] initWithImage:self.reply];
    else
        cell.accessoryView = [[UIImageView alloc] initWithImage:self.carrot];
    cell.detailTextLabel.text = [dateFormat stringFromDate:i.date];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
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
