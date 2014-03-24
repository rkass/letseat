//
//  InviteViewController.m
//  Let's Eat
//
//  Created by Ryan Kass on 3/4/14.
//  Copyright (c) 2014 Ryan Kass. All rights reserved.
//

#import "InviteViewController.h"
#import "User.h"
#import "InvitationsViewController.h"
#import "JSONKit.h"
#import "CreateMealNavigationController.h"
#import "Graphics.h"

@interface InviteViewController ()

@property (strong, nonatomic) IBOutlet UIButton *restaurants;
@property (strong, nonatomic) IBOutlet UITableView *rsvpTable;
@property (strong, nonatomic) IBOutlet UILabel *date;
@property (strong, nonatomic) IBOutlet UIImageView *white;

@property (strong, nonatomic) IBOutlet UITableView *restaurantsTable;
@property (strong, nonatomic) NSMutableArray* going;
@property (strong, nonatomic) NSMutableArray* undecided;
@property (strong, nonatomic) IBOutlet UIButton *overview;
@property (strong, nonatomic) NSMutableArray* notGoing;
@property (strong, nonatomic) IBOutlet UILabel *message;
@end

@implementation InviteViewController
@synthesize invitation, rsvpTable, going, undecided, notGoing, overview, restaurants,  restaurantsTable, white;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.restaurantsTable.hidden = YES;
    self.title = @"Invitation";
    self.overview.backgroundColor = [Graphics colorWithHexString:@"b8a37e"];
    self.restaurants.backgroundColor = [UIColor clearColor];
    self.overview.titleLabel.textColor = [UIColor blackColor];
    self.restaurants.titleLabel.textColor = [UIColor grayColor];
    self.rsvpTable.delegate = self;
    self.rsvpTable.dataSource = self;
  //  [self.yes setTitleColor:[Graphics colorWithHexString:@"ffa500"] forState:UIControlStateNormal];
    //[self.no setTitleColor:[Graphics colorWithHexString:@"ffa500"] forState:UIControlStateNormal];
    CreateMealNavigationController* cmnc = (CreateMealNavigationController*) self.navigationController;
    cmnc.creator = NO;
    NSMutableArray* arrays = [self.invitation generateResponsesArrays];
    self.going = arrays[0];
    self.undecided = arrays[1];
    self.notGoing = arrays[2];

    if (self.invitation.iResponded || [self.invitation passed]){
        self.overview.titleLabel.text = @"Overview";
        self.restaurants.titleLabel.text = @"Restaurants";
      //  self.yes.hidden = YES;
       // self.no.hidden = YES;

    }
    else{
        self.overview.titleLabel.text = @"  Decline";
        self.restaurants.backgroundColor = [UIColor colorWithRed:0 green:1 blue:0 alpha:.1];
        self.restaurants.titleLabel.text = @"    Attend";
        self.overview.backgroundColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:.1];
        self.overview.titleLabel.textColor = [Graphics colorWithHexString:@"ffa500"];
        self.restaurants.titleLabel.textColor = [Graphics colorWithHexString:@"ffa500"];
       // self.restaurants.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    [self.white setBackgroundColor:[UIColor colorWithRed:184 green:163 blue:126 alpha:1]];
    NSLog(@"%@", NSStringFromCGRect(self.date.frame));
    self.date.text = [self.invitation dateToString];
    if (self.invitation.message.length >80)
        self.message.text = [self.invitation.message substringToIndex:80];
    else
        self.message.text = self.invitation.message;
    if ([self.message.text isEqualToString:@""])
        self.message.text = @"Let's Eat!";
    //self.message.backgroundColor = [UIColor colorWithRed:0 green:0 blue:1 alpha:.1];
    NSString* creatorDisplay = [self.invitation.creator componentsSeparatedByString:@" "][0];
    if ([creatorDisplay hasSuffix:@"s"])
        creatorDisplay = [creatorDisplay stringByAppendingString:@"' Message:\n"];
    else if ([creatorDisplay hasSuffix:@"You"])
        creatorDisplay = @"Your Message:\n";
    else
        creatorDisplay = [creatorDisplay stringByAppendingString:@"'s Message:\n"];
    self.message.text = [creatorDisplay stringByAppendingString:self.message.text];
    CGSize maxSize = CGSizeMake(self.message.frame.size.width, MAXFLOAT);
    
    CGRect labelRect = [self.message.text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.message.font} context:nil];
    [self.message setFrame:labelRect];
    self.rsvpTable.hidden = NO;
    self.message.hidden = NO;
    self.rsvpTable.backgroundColor = [Graphics colorWithHexString:@"f5f0df"];
    self.view.backgroundColor = [Graphics colorWithHexString:@"f5f0df"];
    UIImage *backImg = [UIImage imageNamed:@"BackBrownCarrot"];
    //UIImage* homeImg = [Graphics makeThumbnailOfSize:bigImage size:CGSizeMake(37,22)];
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    back.bounds = CGRectMake( 0, 0, backImg.size.width, backImg.size.height );
    [back setImage:backImg forState:UIControlStateNormal];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:back];
    [back addTarget:self action:@selector(backPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = backItem;
    UIImage *bigImage = [UIImage imageNamed:@"Home"];
    UIImage* homeImg = [Graphics makeThumbnailOfSize:bigImage size:CGSizeMake(30,30)];
    UIButton *home = [UIButton buttonWithType:UIButtonTypeCustom];
    home.bounds = CGRectMake( 0, 0, homeImg.size.width, homeImg.size.height );
    [home setImage:homeImg forState:UIControlStateNormal];
    UIBarButtonItem *homeItem = [[UIBarButtonItem alloc] initWithCustomView:home];
    [home addTarget:self action:@selector(homePressed:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = homeItem;

   // CGRect rect = [self.message.text boundingRectWithSize:CGSizeMake(self.message.frame.size.width, CGFLOAT_MAX) options: NSStringDrawingUsesLineFragmentOrigin context:nil];
    [self.view sendSubviewToBack:self.restaurants];
    [self.view sendSubviewToBack:self.overview];
    [self.view sendSubviewToBack:self.white];

    

	
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

-(void)homePressed:(UIBarButtonItem*)sender{
    [self.navigationController popToRootViewControllerAnimated:YES];
    self.navigationController.navigationBarHidden = YES;
}
-(void)backPressed:(UIBarButtonItem*)sender{
    [self.navigationController popViewControllerAnimated:YES];
    
    
}
- (IBAction)overviewPressed:(id)sender {
    if (self.invitation.iResponded || [self.invitation passed]){
            self.overview.backgroundColor = [Graphics colorWithHexString:@"b8a37e"];
    self.restaurants.backgroundColor = [UIColor clearColor];
    self.overview.titleLabel.textColor = [UIColor blackColor];
    self.restaurants.titleLabel.textColor = [UIColor grayColor];
    self.restaurantsTable.hidden = YES;
    self.date.hidden = NO;
    self.message.hidden = NO;
        self.rsvpTable.hidden = NO;}
    else{
        self.overview.titleLabel.text = @"  Decline";
        self.restaurants.backgroundColor = [UIColor colorWithRed:0 green:1 blue:0 alpha:.1];
        self.restaurants.titleLabel.text = @"    Attend";
        self.overview.backgroundColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:.1];
        self.overview.titleLabel.textColor = [Graphics colorWithHexString:@"ffa500"];
        self.restaurants.titleLabel.textColor = [Graphics colorWithHexString:@"ffa500"];
    }
}
- (IBAction)restsPressed:(id)sender {
    if (self.invitation.iResponded || [self.invitation passed]){

    self.restaurants.backgroundColor = [Graphics colorWithHexString:@"b8a37e"];
    self.overview.backgroundColor = [UIColor clearColor];
    self.restaurants.titleLabel.textColor = [UIColor blackColor];
    self.overview.titleLabel.textColor = [UIColor grayColor];
    self.restaurantsTable.hidden = NO;
    self.date.hidden = YES;
    self.message.hidden = YES;
            self.rsvpTable.hidden = YES;}
    else{
        self.overview.titleLabel.text = @"  Decline";
        self.restaurants.backgroundColor = [UIColor colorWithRed:0 green:1 blue:0 alpha:.1];
        self.restaurants.titleLabel.text = @"    Attend";
        self.overview.backgroundColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:.1];
        self.overview.titleLabel.textColor = [Graphics colorWithHexString:@"ffa500"];
        self.restaurants.titleLabel.textColor = [Graphics colorWithHexString:@"ffa500"];
    }
    
}
/*
- (IBAction)overviewPressed:(id)sender {
    self.suggestedRestaurants.hidden = YES;
    self.rsvpTable.hidden = NO;
    self.message.hidden = NO;
}
- (IBAction)suggestedRestaurantsPressed:(id)sender {
    self.suggestedRestaurants.hidden = NO;
    self.rsvpTable.hidden = YES;
    self.message.hidden = YES;
}*/
/*
- (IBAction)noPressed:(id)sender {
    UIAlertView* noResponseAlert = [[UIAlertView alloc] initWithTitle:@"Respond No?" message:@"Include an optional message:" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Okay", nil];
    noResponseAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [noResponseAlert textFieldAtIndex:0].delegate = self;
    [noResponseAlert show];
    
    
}
 */
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1)
        [User respondNo:self.invitation.num message:[alertView textFieldAtIndex:0].text source:self];
}

- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSDictionary *resultsDictionary = [data objectFromJSONData];
    NSLog(@"%@", resultsDictionary);
    if ([resultsDictionary[@"success"] isEqual: @YES]){
        InvitationsViewController* ivc = (InvitationsViewController*)[self.navigationController viewControllers][[[self.navigationController viewControllers] count] - 2 ];
        if ([ivc.upcomingInvitations containsObject:self.invitation]){
            [ivc.upcomingInvitations removeObject:self.invitation];
            [ivc saveInvitations];
            [ivc.invitationsTable reloadData];
        }
        [self.navigationController popViewControllerAnimated:YES];
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
    if (section == 0)
        return @"Going";
    if (section == 1)
        return @"Undecided";
    return @"Declined";
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
       cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
        
    }
    NSString* p;
    if (indexPath.section == 0)
        p = [self.going objectAtIndex:indexPath.row];
    else if (indexPath.section == 1)
        p = [self.undecided objectAtIndex:indexPath.row];
    else
        p = [self.notGoing objectAtIndex:indexPath.row];
    cell.textLabel.text = p;
    if (indexPath.section == 0){
        cell.detailTextLabel.text = [self.invitation preferencesForPerson:p];
        NSLog(@"prefs: %@",[self.invitation preferencesForPerson:p]);
    }
    else
        cell.detailTextLabel.text = nil;
    return cell;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
