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
@property (strong, nonatomic) NSMutableData* responseData;

@property int tries;
@end

@implementation InvitationsViewController
@synthesize passedInvitations, selectedIndexPath, upcomingInvitations, carrot, reply, acquired, tries, responseData, scheduled;

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (self.scheduled)
        [User getMeals:self];
    else
        [User getInvitations:self];
    self.tries = 0;
    self.responseData = [[NSMutableData alloc] initWithLength:0];
    self.acquired = [NSNumber numberWithInt:0];
    UIImage* bigCarrot = [UIImage imageNamed:@"OrangeCarrot"];
    self.carrot = [Graphics makeThumbnailOfSize:bigCarrot size:CGSizeMake(10, 10)];
    UIImage* bigReply = [UIImage imageNamed:@"Reply"];
    self.reply = [Graphics makeThumbnailOfSize:bigReply size:CGSizeMake(14, 18)];
    if (self.scheduled)
        self.title = @"Meals";
    else
        self.title = @"Invitations";
    self.invitationsTable.dataSource = self;
    self.invitationsTable.delegate = self;
    self.invitationsTable.backgroundColor = [Graphics colorWithHexString:@"f5f0df"];
    if (self.scheduled){
        self.passedInvitations = [self loadInvitation:@"passedMeals"];
        self.upcomingInvitations = [self loadInvitation:@"upcomingMeals"];
    }
    else{
        self.passedInvitations = [self loadInvitation:@"passedInvitations"];
        self.upcomingInvitations = [self loadInvitation:@"upcomingInvitations"];
    }
    [self syncInvitations];
    [self.invitationsTable reloadData];
    
    [self.navigationController setNavigationBarHidden:NO];
    UIImage *bigImg = [UIImage imageNamed:@"HomeBack"];
    UIImage* backImg = [Graphics makeThumbnailOfSize:bigImg size:CGSizeMake(37,22)];
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    back.bounds = CGRectMake( 0, 0, backImg.size.width, backImg.size.height );
    [back setImage:backImg forState:UIControlStateNormal];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:back];
    [back addTarget:self action:@selector(homePressed:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = backItem;
    
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
    if (self.scheduled){
        [LEViewController setUserDefault:@"passedMeals" data:pi];
        [LEViewController setUserDefault:@"upcomingMeals" data:ui];
    }
    else{
        [LEViewController setUserDefault:@"passedInvitations" data:pi];
    [LEViewController setUserDefault:@"upcomingInvitations" data:ui];
    }
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
    //[self syncInvitations];
}

-(void)recall{
    if (self.scheduled)
        [User getMeals:self];
    else
        [User getInvitations:self];
}

- (void)connectionDidFinishLoading:(NSURLConnection*)connection
{
    NSDictionary *resultsDictionary = [self.responseData objectFromJSONData];
    NSLog(@"%@", resultsDictionary);
    [self.passedInvitations removeAllObjects];
    [self.upcomingInvitations removeAllObjects];
    for (NSMutableDictionary* dict in resultsDictionary[@"invitations"]){
        Invitation* i = [[Invitation alloc] init:dict[@"id"] timeInput:dict[@"time"] peopleInput:dict[@"people"] messageInput:dict[@"message"] iRespondedInput:[dict[@"iResponded"] boolValue] creatorIndexInput:dict[@"creatorIndex"] responseArrayInput:dict[@"responses"] centralInput:[dict[@"central"] boolValue] preferencesInput:dict[@"preferences"]];
        NSLog(@"id: %d", i.num);
        [self.upcomingInvitations addObject:i];
        NSLog(@"upcoming invitations count: %d,", self.upcomingInvitations.count);
    }
    NSLog(@"passed inviations count: %d", self.passedInvitations.count);
    NSLog(@"upcoming invitations count: %d,", self.upcomingInvitations.count);
    [self syncInvitations];
    NSLog(@"passed inviations count: %d", self.passedInvitations.count);
    NSLog(@"upcoming invitations count: %d,", self.upcomingInvitations.count);
    [self.invitationsTable reloadData];
}

- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.responseData appendData:data];
    /*@synchronized(self.acquired){
        if(self.acquired.integerValue == 1 || [self.navigationController viewControllers][[[self.navigationController viewControllers] count] -1 ] != self || self.tries > 10 || [self.connections containsObject:connection]){
            return;
        }
    }
    NSDictionary *resultsDictionary = [data objectFromJSONData];
    if(!resultsDictionary){
        NSLog(@"failed");
        NSLog(@"data: %@", data);
        @synchronized(self.acquired){
            if (self.acquired.integerValue == 0 && (!(self.tries > 10)) && (!([self.connections containsObject:connection]))){
                self.tries += 1;
                [self.connections addObject:connection];
                [self performSelector:@selector(recall) withObject:nil afterDelay:.5];
            }
        }
        //NSLog(@"returning");
        return;
    }
    else{
        NSLog(@"succeeded");
        @synchronized(self.acquired){
            self.acquired = [NSNumber numberWithInt:1];
        }
    }
    NSLog(@"%@", resultsDictionary);
    [self.passedInvitations removeAllObjects];
    [self.upcomingInvitations removeAllObjects];

    for (NSMutableDictionary* dict in resultsDictionary[@"invitations"]){
       // NSLog(@"one");
      //  NSLog(@"%@", dict);
        [self.upcomingInvitations addObject:[[Invitation alloc] init:dict[@"id"] timeInput:dict[@"time"] peopleInput:dict[@"people"] messageInput:dict[@"message"] iRespondedInput:[dict[@"iResponded"] boolValue] creatorIndexInput:dict[@"creatorIndex"] responseArrayInput:dict[@"responses"] centralInput:[dict[@"central"] boolValue] preferencesInput:dict[@"preferences"]]];
        Invitation* i = [[Invitation alloc] init:dict[@"id"] timeInput:dict[@"time"] peopleInput:dict[@"people"] messageInput:dict[@"message"] iRespondedInput:[dict[@"iResponded"] boolValue] creatorIndexInput:dict[@"creatorIndex"] responseArrayInput:dict[@"responses"] centralInput:[dict[@"central"] boolValue] preferencesInput:dict[@"preferences"]];
        [self addInvitation:i];
        
    }NSLog(@"reloading data");
    [self syncInvitations];
    [self.invitationsTable reloadData];*/
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0)
        return MAX([self.upcomingInvitations count], 1);
    return MAX([self.passedInvitations count], 1);
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(section == 0){
        if (self.scheduled)
            return @"Upcoming Meals";
        return @"Upcoming Invitations";
    }
    if (self.scheduled)
        return @"Passed Meals";
    return @"Passed Invitations";
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
        
    }
    Invitation *i;
    if (indexPath.section == 0){
        if ([self.upcomingInvitations count] > indexPath.row)
            i = [self.upcomingInvitations objectAtIndex:indexPath.row];
    }
    else{
        if ([self.passedInvitations count] > indexPath.row)
            i = [self.passedInvitations objectAtIndex:indexPath.row];
    }
    if (!i){
        cell.textLabel.text = @"(None)";
        cell.detailTextLabel.text = nil;
    }
    else{
        cell.textLabel.text = [i displayPeople];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"cccc, MMM d, h:mm aa"];
        if (!i.iResponded && indexPath.section == 0)
            cell.accessoryView = [[UIImageView alloc] initWithImage:self.reply];
        else
            cell.accessoryView = [[UIImageView alloc] initWithImage:self.carrot];
        cell.detailTextLabel.text = [dateFormat stringFromDate:i.date];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"invitationsToInvite"]){
        InviteViewController *iv = (InviteViewController *)segue.destinationViewController;
        iv.scheduled = self.scheduled;
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
