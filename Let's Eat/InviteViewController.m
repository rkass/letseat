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
#import "NSDate-Utilities.h"
#import "InvitationsConnectionHandler.h"
#import "InviteTransitionConnectionHandler.h"



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
@property (strong, nonatomic) IBOutlet UILabel *timerLabel;
@property (strong, nonatomic) Invitation* previousInvitation;
@property BOOL restsPressed;
@property (strong, nonatomic) NSMutableData* responseData;
@property (strong, nonatomic) IBOutlet UILabel *msg;
@property (strong, nonatomic) UIView* labelbg;
@property double start;
@property (strong, nonatomic) NSNumber* tries;
@property (strong, nonatomic) NSTimer* timer;
@property (strong, nonatomic) IBOutlet UITableView* oneRest;


@end

@implementation InviteViewController
@synthesize invitation, rsvpTable, going, undecided, notGoing, overview, restaurants,  restaurantsTable, white, acquired, tries, restaurantsArr, responseData, voteChanged, selectedIndexPath, scheduled, labelbg, start, timer, oneRest, myLocation, restsPressed, previousInvitation;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.start = [self.invitation.scheduleTime timeIntervalSince1970];
    self.responseData = [[NSMutableData alloc] initWithLength:0];
    self.tries = [NSNumber numberWithInt:0];
    self.restaurantsTable.dataSource = self;
    self.restaurantsTable.delegate = self;
    self.rsvpTable.delegate = self;
    self.rsvpTable.dataSource = self;
    self.oneRest.delegate = self;
    self.oneRest.dataSource = self;
    self.oneRest.layer.cornerRadius = 8;
    self.title = @"Meal";
    [self.white setBackgroundColor:[UIColor colorWithRed:184 green:163 blue:126 alpha:1]];
    self.restsPressed = NO;
    self.rsvpTable.backgroundColor = [Graphics colorWithHexString:@"f5f0df"];
    self.view.backgroundColor = [Graphics colorWithHexString:@"f5f0df"];
    UIImage *backImg = [UIImage imageNamed:@"BackBrownCarrot"];
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
    [self layoutView];
    [self.view sendSubviewToBack:self.restaurants];
    [self.view sendSubviewToBack:self.overview];
    [self.view sendSubviewToBack:self.white];
    [self.view bringSubviewToFront:self.msg];
    [self.rsvpTable setFrame:CGRectMake(self.rsvpTable.frame.origin.x, self.rsvpTable.frame.origin.y - 900, self.rsvpTable.frame.size.width, self.rsvpTable.frame.size.height)];
    labelbg = [[UIView alloc] initWithFrame:CGRectMake(self.msg.frame.origin.x - 5, self.msg.frame.origin.y + 7, self.msg.frame.size.width + 10, self.msg.frame.size.height -10)];
    labelbg.backgroundColor = [Graphics colorWithHexString:@"ffa500"];
    labelbg.alpha = .5;
    labelbg.layer.cornerRadius = 8;
	
}

//Everything that could change with a fresh invitation
- (void) layoutView{
    NSMutableArray* arrays = [self.invitation generateResponsesArrays];
    self.going = arrays[0];
    self.undecided = arrays[1];
    self.notGoing = arrays[2];
    if ((!self.previousInvitation) || (![self.invitation isEqual:self.previousInvitation])){
        if (self.invitation.scheduled || self.invitation.iResponded){
            [self layoutAccordingToRestsPressed];
        }
        else{
            [self layoutAcceptDecline];
        }
        if (self.invitation.scheduled){
            self.date.text = [@"Scheduled For " stringByAppendingString:[self.invitation dateToString]];
            [self.rsvpTable setContentInset:UIEdgeInsetsMake(20, 0, 0, 0)];
            self.message.hidden = YES;
            self.msg.hidden = YES;
            self.timerLabel.hidden = YES;
            self.labelbg.hidden = YES;
            self.oneRest.hidden = NO;
            [self.timer invalidate];
        }
        else{
            self.date.text = [self.invitation dateToString];
            self.oneRest.hidden = YES;
            [self updateCounter:nil];
            [self.timer invalidate];
            self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateCounter:) userInfo:nil repeats:YES];
            if (self.invitation.message.length >80)
                self.msg.text = [self.invitation.message substringToIndex:80];
            else
                self.msg.text = self.invitation.message;
            if ([self.msg.text isEqualToString:@""])
                self.msg.text = @"Let's Eat!";
            self.message.text = [self.invitation.creator componentsSeparatedByString:@" "][0];
            if ([self.message.text hasSuffix:@"s"])
                self.message.text = [self.message.text stringByAppendingString:@"' Message:\n"];
            else if ([self.message.text hasSuffix:@"You"])
                self.message.text = @"Your Message:\n";
            else
                self.message.text = [self.message.text stringByAppendingString:@"'s Message:\n"];
            self.message.hidden = NO;
            [self.view addSubview:labelbg];
        }
    }
    if (self.previousInvitation){
        [self.restaurantsTable reloadData];
        [self.rsvpTable reloadData];
        [self.oneRest reloadData];
    }
    self.previousInvitation = self.invitation;
    if (self.invitation.updatingRecommendations > 0){
        bool retry;
        @synchronized(self.tries){
            self.tries = [NSNumber numberWithInt:([self.tries integerValue ]+ 1)];
            retry = ([self.tries integerValue] < 20);
        }
        if (retry){
            NSLog(@"retrying...");
            [self performSelector:@selector(recall) withObject:nil afterDelay:1];
        }
        else
            NSLog(@"retries exceeded max val before restaurants updated");
    }
    else{
        @synchronized(self.tries){
            self.tries = [NSNumber numberWithInt:0];
        }
    }
    
}
-(void) recall{
    NSLog(@"recalling.");
    InviteTransitionConnectionHandler* ivtch = [[InviteTransitionConnectionHandler alloc] initWithInvitateViewController:self];
    [User getInvitation:self.invitation.num source:ivtch];
}
-(void) saveRests{
    NSMutableArray* serialzedRests = [[NSMutableArray alloc] init];
    for (Restaurant* r in self.restaurantsArr)
        [serialzedRests addObject:[r serializeToData]];
    [LEViewController setUserDefault:[@"restaurants" stringByAppendingString:[NSString stringWithFormat:@"%d", self.invitation.num]] data:serialzedRests];
}


-(void)viewWillAppear:(BOOL)animated{
    NSLog(@"will appear");
    InviteTransitionConnectionHandler* ivtch = [[InviteTransitionConnectionHandler alloc] initWithInvitateViewController:self];
    [User getInvitation:self.invitation.num source:ivtch];
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.timer invalidate];
    self.timer = nil;
}

- (void)updateCounter:(NSTimer *)theTimer {
   
    int secondsLeft = self.start - [[NSDate date] timeIntervalSince1970];
    if(secondsLeft > -1 ){
        int hours = secondsLeft / 3600;
        int minutes = (secondsLeft % 3600) / 60;
        int seconds = (secondsLeft %3600) % 60;
        NSTimeInterval ti = [self.invitation.scheduleTime timeIntervalSinceDate:[NSDate date]];
        int daysBefore = (ti / 86400);
        if (daysBefore == 1)
            self.timerLabel.text = [NSString stringWithFormat:@"Scheduling in %u Day", daysBefore];
        else if (daysBefore > 1)
            self.timerLabel.text = [NSString stringWithFormat:@"Scheduling in %u Days", daysBefore];
        else{
            if (hours == 0){
                if (minutes == 0){
                    self.timerLabel.text = [NSString stringWithFormat:@"Scheduling in %2d", seconds];
                }
                else{
                    self.timerLabel.text = [NSString stringWithFormat:@"Scheduling in %2d:%02d", minutes, seconds];
                }
            }
            else
                self.timerLabel.text = [NSString stringWithFormat:@"Scheduling in %2d:%02d:%02d", hours, minutes, seconds];
        }

       
    }
    else {
        InviteTransitionConnectionHandler* ivtch = [[InviteTransitionConnectionHandler alloc] initWithInvitateViewController:self];
        [User getInvitation:self.invitation.num source:ivtch];
        //[User getMeals:<#(NSObject *)#>]
        [self.labelbg setHidden:YES];
        [self.labelbg removeFromSuperview];
       /* InvitationsViewController* ivs = [self.navigationController viewControllers][[self.navigationController viewControllers].count - 2 ];
        [User getMeals:[[InvitationsConnectionHandler alloc] initWithInvitationsViewController:ivs] ];
        [User getInvitations:[[InvitationsConnectionHandler alloc] initWithInvitationsViewController:ivs] ];*/
        [self.timer invalidate];
        self.timer = nil;
    }
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
    NSArray* vc = [self.navigationController viewControllers];
    if ([vc[vc.count - 2] isKindOfClass:[InvitationsViewController class]]){
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        [self performSegueWithIdentifier:@"inviteToInvitations" sender:self];
         }
}
/*
- (NSMutableArray*) loadRestaurants
{
    NSMutableArray* ret = [[NSMutableArray alloc] init];
    for (NSData* data in [[NSUserDefaults standardUserDefaults] arrayForKey:
                          [@"restaurants" stringByAppendingString:[NSString stringWithFormat:@"%d", self.invitation.num]]]){
        Restaurant* r = [[Restaurant alloc] initWithData:data];
        //[r setInviteAndDistance:self];
        [ret addObject:r];
    }
    return ret;
}*/

-(void) layoutAcceptDecline{
    [self.overview setTitle:@"  Decline" forState:UIControlStateNormal];
    [self.restaurants setTitle:@"  Attend" forState:UIControlStateNormal];
    self.restaurants.backgroundColor = [UIColor colorWithRed:0 green:1 blue:0 alpha:.1];
    self.overview.backgroundColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:.1];
    [self.restaurants setTitleColor:[Graphics colorWithHexString:@"ffa500"] forState:UIControlStateNormal];
    [self.overview setTitleColor:[Graphics colorWithHexString:@"ffa500"] forState:UIControlStateNormal];
}
- (IBAction)overviewPressed:(id)sender {
    NSLog(@"overview pressed");
    if (self.invitation.iResponded || [self.invitation passed]){
        self.restsPressed = NO;
        [self layoutAccordingToRestsPressed];
    }
    else{
        [self layoutAcceptDecline];
        UIAlertView* noResponseAlert = [[UIAlertView alloc] initWithTitle:@"Decline?" message:@"Include an optional message:" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Okay", nil];
        noResponseAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
        [noResponseAlert textFieldAtIndex:0].delegate = self;
        [noResponseAlert show];

        
    }
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return !([textField.text length]>40 && [string length] > range.length);
}
- (void) layoutAccordingToRestsPressed{
    if (self.restsPressed){
        self.restaurants.backgroundColor = [Graphics colorWithHexString:@"b8a37e"];
        self.overview.backgroundColor = [UIColor clearColor];
        self.restaurants.titleLabel.textColor = [UIColor blackColor];
        self.overview.titleLabel.textColor = [UIColor grayColor];
        self.restaurantsTable.hidden = NO;
        self.date.hidden = YES;
        if (!self.scheduled){
            self.message.hidden = YES;
            self.msg.hidden = YES;
            self.labelbg.hidden = YES;
        }
        self.rsvpTable.hidden = YES;
    }
    else{
        self.overview.backgroundColor = [Graphics colorWithHexString:@"b8a37e"];
        self.restaurants.backgroundColor = [UIColor clearColor];
        self.overview.titleLabel.textColor = [UIColor blackColor];
        self.restaurants.titleLabel.textColor = [UIColor grayColor];
        self.restaurantsTable.hidden = YES;
        self.date.hidden = NO;
        if (!self.scheduled){
            self.message.hidden = NO;
            self.labelbg.hidden = NO;
            self.msg.hidden = NO;
        }
        else{
            self.message.hidden = YES;
            self.labelbg.hidden = YES;
            self.msg.hidden = YES;
        }
        self.rsvpTable.hidden = NO;
    }
}
- (IBAction)restsPressed:(id)sender {
    NSLog(@"rests pressed");
    if (self.invitation.iResponded || [self.invitation passed]){
        self.restsPressed = YES;
        [self layoutAccordingToRestsPressed];
    }
    else{
        [self layoutAcceptDecline];
        [self performSegueWithIdentifier:@"inviteToWhat" sender:self];
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1)
        [User respondNo:self.invitation.num message:[alertView textFieldAtIndex:0].text source:self];
}
/*
- (void)connectionDidFinishLoading:(NSURLConnection*)connection{
    NSMutableDictionary* resultsDictionary = [self.responseData objectFromJSONData];
  //  NSLog(@"%@", resultsDictionary);
    NSLog(@"connecting");
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
            [self.restaurantsArr addObject:[[Restaurant alloc] init:dict[@"address"] distanceInput:dict[@"distance"] nameInput:dict[@"name"] percentMatchInput:dict[@"percentMatch"] priceInput:dict[@"price"] ratingImgInput:dict[@"rating_img"] snippetImgInput:dict[@"snippet_img"] votesInput:votes typesInput:dict[@"types_list"] iVotedInput:iVoted invitationInput:self.invitation.num urlInput:dict[@"url"] InviteViewControllerInput:self]];
        }
        NSMutableArray* serialzedRests = [[NSMutableArray alloc] init];
        for (Restaurant* r in self.restaurantsArr)
            [serialzedRests addObject:[r serializeToData]];
        [LEViewController setUserDefault:[@"restaurants" stringByAppendingString:[NSString stringWithFormat:@"%d", self.invitation.num]] data:serialzedRests];
        [self.restaurantsTable reloadData];
        [self.oneRest reloadData];
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
   // NSLog(@"receiving");
    [self.responseData appendData:data];
}
 */


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"inviteToRestaurant"]){
        NSLog(@"preparing for segue %@", segue.identifier);
        RestaurantViewController *rv = (RestaurantViewController *)segue.destinationViewController;
        rv.restaurant = self.invitation.restaurants[selectedIndexPath.row];
        NSLog(@"restaurant name: %@", rv.restaurant.name);
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView != self.rsvpTable) {
        NSLog(@"here");
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
    else if (tableView == self.restaurantsTable)
        return [self.invitation.restaurants count];
    else
        return MIN(1, [self.invitation.restaurants count]);
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
        else{
            cell.detailTextLabel.text = [self.invitation messagesForPerson:p];

        }

        return cell;
    }

    static NSString *CellIdentifier = @"restCell";
    RestaurantTableViewCell* cell;
    if (tableView == oneRest){
        cell =  [tableView dequeueReusableCellWithIdentifier:@"restCell2"];
        [cell setWithRestaurant:self.invitation.restaurants[indexPath.row] rowInput:indexPath.row ivcInput:self oneRestInput:YES];
    }
    else{
        cell =  [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        [cell setWithRestaurant:self.invitation.restaurants[indexPath.row] rowInput:indexPath.row ivcInput:self oneRestInput:NO];
        
    }
    return cell;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    NSLog(@"received memory warning");
    // Dispose of any resources that can be recreated.
}

@end
