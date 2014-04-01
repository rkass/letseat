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
#import "Restaurant.h"
#import "RestaurantTableViewCell.h"
#import "RestaurantViewController.h"

@interface InviteViewController ()

@property (strong, nonatomic) IBOutlet UIButton *restaurants;
@property (strong, nonatomic) IBOutlet UITableView *rsvpTable;
@property (strong, nonatomic) IBOutlet UILabel *date;
@property (strong, nonatomic) IBOutlet UIImageView *white;
@property (strong, nonatomic) NSIndexPath* selectedIndexPath;
@property (strong, nonatomic) IBOutlet UITableView *restaurantsTable;
@property (strong, nonatomic) NSMutableArray* going;
@property (strong, nonatomic) NSMutableArray* undecided;
@property (strong, nonatomic) IBOutlet UIButton *overview;
@property (strong, nonatomic) NSMutableArray* notGoing;
@property (strong, nonatomic) IBOutlet UILabel *message;
@property (strong, nonatomic) NSNumber* acquired;
@property (strong, nonatomic) NSMutableArray* restaurantsArr;
@property (strong, nonatomic) NSMutableData* responseData;

@property int tries;
@end

@implementation InviteViewController
@synthesize invitation, rsvpTable, going, undecided, notGoing, overview, restaurants,  restaurantsTable, white, acquired, tries, restaurantsArr, responseData, voteChanged, selectedIndexPath, scheduled;

- (void)viewDidLoad
{
    NSLog(@"at the view controller bitches");
    [super viewDidLoad];
    if (self.scheduled){
        UIImageView* iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"White"]];
        [iv setFrame:CGRectMake(self.message.frame.origin.x, self.message.frame.origin.y + 100, self.message.frame.size.width, self.message.frame.size.height)];
        //[self.view addSubview:iv];
    }
    self.voteChanged = NO;
    self.restaurantsTable.hidden = YES;
    self.title = @"Invitation";
    self.responseData = [[NSMutableData alloc] initWithLength:0];
    self.tries = 0;
    self.restaurantsTable.dataSource = self;
    self.restaurantsTable.delegate = self;
    self.acquired = [NSNumber numberWithInt:0];
    self.overview.backgroundColor = [Graphics colorWithHexString:@"b8a37e"];
    self.restaurants.backgroundColor = [UIColor clearColor];
    self.overview.titleLabel.textColor = [UIColor blackColor];
    self.restaurants.titleLabel.textColor = [UIColor grayColor];
    self.rsvpTable.delegate = self;
    self.rsvpTable.dataSource = self;
    self.restaurantsArr = [self loadRestaurants];
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
        NSLog(@"calling");
        [User getRestaurants:self.invitation.num source:self];
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
   
    
    self.date.text = [self.invitation dateToString];
    if (!self.scheduled){
        if (self.invitation.message.length >80)
            self.message.text = [self.invitation.message substringToIndex:80];
        else
            self.message.text = self.invitation.message;
        if ([self.message.text isEqualToString:@""])
            self.message.text = @"Let's Eat!";
    }
    //self.message.backgroundColor = [UIColor colorWithRed:0 green:0 blue:1 alpha:.1];
    NSString* creatorDisplay = [self.invitation.creator componentsSeparatedByString:@" "][0];
    if ([creatorDisplay hasSuffix:@"s"])
        creatorDisplay = [creatorDisplay stringByAppendingString:@"' Message:\n"];
    else if ([creatorDisplay hasSuffix:@"You"])
        creatorDisplay = @"Your Message:\n";
    else
        creatorDisplay = [creatorDisplay stringByAppendingString:@"'s Message:\n"];
    if (!self.scheduled)
        self.message.text = [creatorDisplay stringByAppendingString:self.message.text];
 /*   CGSize maxSize = CGSizeMake(self.message.frame.size.width, MAXFLOAT);
    
    CGRect labelRect = [self.message.text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.message.font} context:nil];
    [self.message setFrame:labelRect];*/
    self.rsvpTable.hidden = NO;
    if (!self.scheduled)
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
    [self.rsvpTable setFrame:CGRectMake(self.rsvpTable.frame.origin.x, self.rsvpTable.frame.origin.y - 900, self.rsvpTable.frame.size.width, self.rsvpTable.frame.size.height)];
    

	
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == self.rsvpTable)
        return 20;
    return 2;
}

-(void)homePressed:(UIBarButtonItem*)sender{
    [self.navigationController popToRootViewControllerAnimated:YES];
    self.navigationController.navigationBarHidden = YES;
}
-(void)backPressed:(UIBarButtonItem*)sender{
    [self.navigationController popViewControllerAnimated:YES];
    
    
}
- (NSMutableArray*) loadRestaurants
{
    NSMutableArray* ret = [[NSMutableArray alloc] init];
    for (NSData* data in [[NSUserDefaults standardUserDefaults] arrayForKey:
                          [@"restaurants" stringByAppendingString:[NSString stringWithFormat:@"%d", self.invitation.num]]])
        [ret addObject:[[Restaurant alloc] initWithData:data]];
    return ret;
}
- (IBAction)overviewPressed:(id)sender {
    NSLog(@"here");
    if (self.invitation.iResponded || [self.invitation passed]){
            self.overview.backgroundColor = [Graphics colorWithHexString:@"b8a37e"];
        NSLog(@"here");
    self.restaurants.backgroundColor = [UIColor clearColor];
    self.overview.titleLabel.textColor = [UIColor blackColor];
    self.restaurants.titleLabel.textColor = [UIColor grayColor];
    self.restaurantsTable.hidden = YES;
    self.date.hidden = NO;
    if (!self.scheduled)
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
    if (!self.scheduled)
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

- (void)connectionDidFinishLoading:(NSURLConnection*)connection{
    NSMutableDictionary* resultsDictionary = [self.responseData objectFromJSONData];
    NSLog(@"data: %@", self.responseData);
    NSLog(@"%@", resultsDictionary);
    [self.responseData setLength:0];
    if ([resultsDictionary[@"request"] isEqualToString:@"restaurants" ]){
        NSMutableArray* arr = [self.restaurantsArr mutableCopy];
        [self.restaurantsArr removeAllObjects];
        for (NSMutableDictionary* dict in resultsDictionary[@"restaurants"]){
            NSNumber* votes = dict[@"votes"];
            bool iVoted = [dict[@"user_voted"] boolValue];
            if (self.voteChanged){
                for (Restaurant* r in arr){
                    if ([r.snippetImg isEqualToString:dict[@"snippet_img"]]){
                        if (iVoted != r.iVoted){
                            if (iVoted)
                                votes = [NSNumber numberWithInt:([votes integerValue] - 1)];
                            else
                                votes = [NSNumber numberWithInt:([votes integerValue] + 1)];
                        }
                        iVoted = r.iVoted;
                        break;
                    }
                }
            }
            [self.restaurantsArr addObject:[[Restaurant alloc] init:dict[@"address"] distanceInput:dict[@"distance"] nameInput:dict[@"name"] percentMatchInput:dict[@"percentMatch"] priceInput:dict[@"price"] ratingImgInput:dict[@"rating_img"] snippetImgInput:dict[@"snippet_img"] votesInput:votes typesInput:dict[@"types_list"] iVotedInput:iVoted invitationInput:self.invitation.num urlInput:dict[@"url"]]];
        }
        NSMutableArray* serialzedRests = [[NSMutableArray alloc] init];
        for (Restaurant* r in self.restaurantsArr)
            [serialzedRests addObject:[r serializeToData]];
        [LEViewController setUserDefault:[@"restaurants" stringByAppendingString:[NSString stringWithFormat:@"%d", self.invitation.num]] data:serialzedRests];
        [self.restaurantsTable reloadData];
    }
    else{
        if ([resultsDictionary[@"success"] isEqual: @YES]){
            InvitationsViewController* ivc = (InvitationsViewController*)[self.navigationController viewControllers][[[self.navigationController viewControllers] count] - 2 ];
            if ([ivc.upcomingInvitations containsObject:self.invitation]){
                [ivc.upcomingInvitations removeObject:self.invitation];
                [ivc saveInvitations];
                [ivc.invitationsTable reloadData];
            }
            [self.navigationController popViewControllerAnimated:YES];
        }}
    
}

- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSLog(@"receiving");
    [self.responseData appendData:data];
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"inviteToRestaurant"]){
        RestaurantViewController *rv = (RestaurantViewController *)segue.destinationViewController;
        rv.restaurant = self.restaurantsArr[selectedIndexPath.row];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView == self.restaurantsTable) {
        self.selectedIndexPath = indexPath;
        [self performSegueWithIdentifier:@"inviteToRestaurant" sender:self];
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.rsvpTable){
        if (section == 0)
            return [self.going count];
        if (section == 1)
            return [self.undecided count];
        return [self.notGoing count];}
    else
        return [self.restaurantsArr count];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == self.rsvpTable)
        return 3;
    return 1;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (tableView == self.rsvpTable){
        if (section == 0)
            return @"Going";
        if (section == 1)
            return @"Undecided";
        return @"Declined";
    }
    return @"";
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.rsvpTable){
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
        }
        else
            cell.detailTextLabel.text = nil;
        return cell;
    }
    static NSString *CellIdentifier = @"restCell";
    RestaurantTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    [cell setWithRestaurant:self.restaurantsArr[indexPath.row] rowInput:indexPath.row ivcInput:self];

    return cell;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
