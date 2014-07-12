//
//  InvitationsViewController.m
//  Let's Eat
//
//  Created by Ryan Kass on 3/3/14.
//  Copyright (c) 2014 Ryan Kass. All rights reserved.
//

#import "InvitationsViewController.h"
#import "User.h"
#import "Invitation.h"
#import "InviteViewController.h"
#import "Graphics.h"
#import "InvitationsConnectionHandler.h"
#import "LEViewController.h"
#import "InviteTransitionConnectionHandler.h"
#import "CheckAllStarsTableViewCell.h"
@interface InvitationsViewController ()

@property (strong, nonatomic) NSIndexPath* selectedIndexPath;
@property (strong, nonatomic) UIImage* carrot;
@property (strong, nonatomic) UIImage* reply;

@property (strong, nonatomic) NSNumber* acquired;
@property (strong, nonatomic) NSMutableData* responseDataMeals;
@property (strong, nonatomic) NSMutableData* responseDataInvitations;
@property (strong, nonatomic) IBOutlet UIButton *invitations;

@property (strong, nonatomic) IBOutlet UITableView *navBar;


@property (strong, nonatomic) IBOutlet UIButton *meals;

@property int tries;
@end

@implementation InvitationsViewController
@synthesize passedInvitations, selectedIndexPath, upcomingInvitations, carrot, reply, acquired, tries, responseDataMeals, responseDataInvitations, scheduled, mealsTable, upcomingMeals, passedMeals, canDoWork, transitionInvitation, tableLock;

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"view's loading");
    self.tableLock = [NSNumber numberWithInt:0];
    self.invitationsTable.dataSource = self;
    [self.navBar setDelegate:self];
    [self.navBar setDataSource:self];
    self.invitationsTable.delegate = self;
    self.mealsTable.delegate = self;
    self.mealsTable.dataSource = self;
    @synchronized(self.tableLock){
        self.passedMeals = [self loadInvitation:@"passedMeals"];
        self.upcomingMeals = [self loadInvitation:@"upcomingMeals"];
        self.passedInvitations = [self loadInvitation:@"passedInvitations"];
        self.upcomingInvitations = [self loadInvitation:@"upcomingInvitations"];
        [self syncInvitations:YES];
        [self syncInvitations:NO];
        [self.invitationsTable reloadData];
        [self.mealsTable reloadData];
    }
    UIImage* bigCarrot = [UIImage imageNamed:@"bluecarrot"];
    self.carrot = [Graphics makeThumbnailOfSize:bigCarrot size:CGSizeMake(10, 10)];
    UIImage* bigReply = [UIImage imageNamed:@"reply"];
    self.reply = [Graphics makeThumbnailOfSize:bigReply size:CGSizeMake(14, 18)];
    self.title = @"Meals";
    //self.view.backgroundColor = [UIColor colorWithPatternImage:GET_IMG(@"bg")];
    self.invitationsTable.backgroundColor = [UIColor clearColor];
    self.mealsTable.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.invitationsTable.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
    self.mealsTable.backgroundColor = [UIColor clearColor];
    [self.navigationController setNavigationBarHidden:NO];
    UIImage *bigImg = [UIImage imageNamed:@"HomeBack"];
    UIImage* backImg = [Graphics makeThumbnailOfSize:bigImg size:CGSizeMake(37,22)];
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    back.bounds = CGRectMake( 0, 0, backImg.size.width, backImg.size.height );
    [back setImage:backImg forState:UIControlStateNormal];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:back];
    [back addTarget:self action:@selector(homePressed:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = backItem;
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"mealsPressed"] && [[[NSUserDefaults standardUserDefaults] objectForKey:@"mealsPressed"] boolValue]){
        NSLog(@"h");
        [self.meals setBackgroundColor:[UIColor whiteColor]];
        [self.invitations setBackgroundColor:[UIColor clearColor]];
        [self.meals setTitleColor:[Graphics colorWithHexString:@"2d769b"] forState:UIControlStateNormal];
        [self.invitations setTitleColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:.18] forState:UIControlStateNormal];
        self.mealsTable.hidden = NO;
        self.invitationsTable.hidden = YES;
    }
    else{
        NSLog(@"k");
        [self.invitations setBackgroundColor:[UIColor whiteColor]];
        [self.meals setBackgroundColor:[UIColor clearColor]];
        [self.invitations setTitleColor:[Graphics colorWithHexString:@"2d769b"] forState:UIControlStateNormal];
        [self.meals setTitleColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:.18] forState:UIControlStateNormal];
        self.mealsTable.hidden = YES;
        self.invitationsTable.hidden = NO;
    }
    self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.spinner setFrame:CGRectMake(self.view.frame.size.width - 40, self.invitationsTable.frame.origin.y +15,self.spinner.frame.size.width, self.spinner.frame.size.height )];
    [self.spinner startAnimating];
    [self.view addSubview:self.spinner];
    self.navigationController.navigationBarHidden = YES;

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == self.navBar)
        return 0;
    return 20;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
-(void)viewWillAppear:(BOOL)animated{
    [self.invitationsTable reloadData];
    [self.mealsTable reloadData];
    [self refreshView];

}

-(void)refreshView{
    NSLog(@"reloading view");
    [self.spinner startAnimating];
    self.invConnHandler1 = [[InvitationsConnectionHandler alloc] initWithInvitationsViewController:self];
    self.invConnHandler2 = [[InvitationsConnectionHandler alloc] initWithInvitationsViewController:self];
    [User getMeals:self.invConnHandler1];
    [User getInvitations:self.invConnHandler2 ];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"mealsPressed"] && [[[NSUserDefaults standardUserDefaults] objectForKey:@"mealsPressed"] boolValue]){
        [self.meals setBackgroundColor:[UIColor whiteColor]];
        [self.invitations setBackgroundColor:[UIColor clearColor]];
        [self.meals setTitleColor:[Graphics colorWithHexString:@"2d769b"] forState:UIControlStateNormal];
        [self.invitations setTitleColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:.18] forState:UIControlStateNormal];
        self.mealsTable.hidden = NO;
        self.invitationsTable.hidden = YES;
    }
    else{
        NSLog(@"k");
        [self.invitations setBackgroundColor:[UIColor whiteColor]];
        [self.meals setBackgroundColor:[UIColor clearColor]];
        [self.invitations setTitleColor:[Graphics colorWithHexString:@"2d769b"] forState:UIControlStateNormal];
        [self.meals setTitleColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:.18] forState:UIControlStateNormal];
        self.mealsTable.hidden = YES;
        self.invitationsTable.hidden = NO;
    }
    @synchronized(self.tableLock){
        [self.invitationsTable reloadData];
        [self.mealsTable reloadData];
    }
}

-(void)homePressed:(UIBarButtonItem*)sender{
    [self.navigationController popToRootViewControllerAnimated:YES];
    self.navigationController.navigationBarHidden = YES;
}
- (IBAction)mealsPressed:(id)sender {
    self.meals.backgroundColor = [UIColor whiteColor];
    self.invitations.backgroundColor = [UIColor clearColor];
    [self.meals setTitleColor:[Graphics colorWithHexString:@"2d769b"] forState:UIControlStateNormal];
    [self.invitations setTitleColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:.18] forState:UIControlStateNormal];
    self.mealsTable.hidden = NO;
    self.invitationsTable.hidden = YES;
    [LEViewController setUserDefault:@"mealsPressed" data:[NSNumber numberWithBool:YES]];
}

- (IBAction)invitationsPressed:(id)sender {
    self.invitations.backgroundColor = [UIColor whiteColor];
    self.meals.backgroundColor = [UIColor clearColor];
    [self.invitations setTitleColor:[Graphics colorWithHexString:@"2d769b"] forState:UIControlStateNormal];
    [self.meals setTitleColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:.18] forState:UIControlStateNormal];
    self.mealsTable.hidden = YES;
    self.invitationsTable.hidden = NO;
    [LEViewController setUserDefault:@"mealsPressed" data:[NSNumber numberWithBool:NO]];
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
    NSMutableArray* pm = [[NSMutableArray alloc] init];
    NSMutableArray* um = [[NSMutableArray alloc] init];
    @synchronized(self.tableLock){
        for(Invitation* i in self.passedInvitations)
            [pi addObject:[i serializeToData]];
        for (Invitation* i in self.upcomingInvitations)
            [ui addObject:[i serializeToData]];
        for(Invitation* i in self.passedMeals)
            [pm addObject:[i serializeToData]];
        for (Invitation* i in self.upcomingMeals)
            [um addObject:[i serializeToData]];
    }
    [LEViewController setUserDefault:@"passedMeals" data:pm];
    [LEViewController setUserDefault:@"upcomingMeals" data:um];
    [LEViewController setUserDefault:@"passedInvitations" data:pi];
    [LEViewController setUserDefault:@"upcomingInvitations" data:ui];
  
}

- (void) syncInvitations:(bool)meals
{
    NSMutableArray* upcoming;
    NSMutableArray* passed;
    if (meals){
        upcoming = self.upcomingMeals;
        passed = self.passedMeals;
    }
    else{
        upcoming = self.upcomingInvitations;
        passed = self.passedInvitations;
    }
    NSMutableArray* removals = [[NSMutableArray alloc] init];
    for (Invitation* i in upcoming){
        if (meals){
            if ([i passed] || [i respondedNo]){
                [removals addObject:i];
            }
        }
        else{
            if ([i passedScheduleTime] || [i respondedNo] || [i passed])
                [removals addObject:i];
        }
    }
    for (Invitation* i in removals){
        [upcoming removeObject:i];
        [passed addObject:i];
    }
    [removals removeAllObjects];
    for (Invitation* i in passed){
        if ([i respondedNo])
           [removals addObject:i];
    }
    for (Invitation* i in removals)
        [passed removeObject:i];
    if (meals){
        [passed sortUsingFunction:sortInvitationByDate3 context:nil];
        [upcoming sortUsingFunction:sortInvitationByDate4 context:nil];
    }
    else{
        [passed sortUsingFunction:sortInvitationByDate2 context:nil];
        [upcoming sortUsingFunction:sortInvitationByDate context:nil];
    }

    [self saveInvitations];
}

NSComparisonResult sortInvitationByDate(Invitation *i1, Invitation *i2, void *ignore)
{
    return [i1.scheduleTime compare:i2.scheduleTime];
}

NSComparisonResult sortInvitationByDate2(Invitation *i1, Invitation *i2, void *ignore)
{
    return [i2.scheduleTime compare:i1.scheduleTime];
}

NSComparisonResult sortInvitationByDate3(Invitation *i1, Invitation *i2, void *ignore)
{
    return [i2.date compare:i1.date];
}

NSComparisonResult sortInvitationByDate4(Invitation *i1, Invitation *i2, void *ignore)
{
    return [i1.date compare:i2.date];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSMutableArray* upcoming;
    NSMutableArray* passed;
    if (tableView == self.invitationsTable){
        upcoming = self.upcomingInvitations;
        passed = self.passedInvitations;
    }
    else{
        upcoming = self.upcomingMeals;
        passed = self.passedMeals;
    }
    if (section == 0)
        return MAX([upcoming count], 1);
    if (tableView == self.invitationsTable)
        return 0;
    if (tableView == self.navBar)
        return 1;
    return MAX([passed count], 1);
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == self.navBar)
        return 1;
    if (tableView == self.invitationsTable)
        return 1;
    return 2;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (tableView == self.navBar)
        return @"";
    if(section == 0){
        if (tableView == self.mealsTable)
            return @"Upcoming Meals";
        return @"Upcoming Invitations";
    }
    if (tableView == self.mealsTable)
        return @"Passed Meals";
    return @"Passed Invitations";
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.navBar){
        CheckAllStarsTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CheckAllStars"];
        [cell setWithInvitationVC:self];
        return cell;
    }
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
        
    }
    NSMutableArray* upcoming;
    NSMutableArray* passed;
    if (tableView == self.invitationsTable){
        upcoming = self.upcomingInvitations;
        passed = self.passedInvitations;
    }
    else{
        upcoming = self.upcomingMeals;
        passed = self.passedMeals;
    }
    Invitation *i;
    if (indexPath.section == 0){
        if ([upcoming count] > indexPath.row)
            i = [upcoming objectAtIndex:indexPath.row];
    }
    else{
        if ([passed count] > indexPath.row)
            i = [passed objectAtIndex:indexPath.row];
    }
    if (!i){
        cell.textLabel.text = @"(None)";
        cell.detailTextLabel.text = nil;
        cell.accessoryView = nil;
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    else{
        [cell setSelectionStyle:UITableViewCellSelectionStyleDefault];
        cell.textLabel.text = [i displayPeople];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"cccc, MMM d, h:mm aa"];
        if (!i.iResponded && indexPath.section == 0 && tableView == self.invitationsTable)
            cell.accessoryView = [[UIImageView alloc] initWithImage:self.reply];
        else
            cell.accessoryView = [[UIImageView alloc] initWithImage:self.carrot];
        cell.detailTextLabel.text = [dateFormat stringFromDate:i.date];

    }
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"invitationsToInvite"]){
        InviteViewController *iv = (InviteViewController *)segue.destinationViewController;
        iv.invitation = self.transitionInvitation;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([[tableView cellForRowAtIndexPath:indexPath].textLabel.text isEqualToString:@"(None)"]){
        return;
    }
    if (tableView == self.navBar)
        return;
    self.selectedIndexPath = indexPath;
    self.ivtch = [[InviteTransitionConnectionHandler alloc] initWithInvitationsViewController:self segueInput:@"invitationsToInvite"];
    NSMutableArray* arr;
    if (self.invitationsTable.hidden){
        if (self.selectedIndexPath.section == 0)
            arr = self.upcomingMeals;
        else
            arr = self.passedMeals;
    }
    else{
        arr = self.upcomingInvitations;
    }
    Invitation* selectedInvitation = arr[indexPath.row];
    [User getInvitation:selectedInvitation.num source:self.ivtch];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self loadingScreen];
    NSLog(@"double passed it all");
}
       


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
