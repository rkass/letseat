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
#import "CreateMealNavigationController.h"
#import "Graphics.h"
#import "Restaurant.h"
#import "RestaurantTableViewCell.h"
#import "RestaurantViewController.h"
#import "NSDate-Utilities.h"
#import "InvitationsConnectionHandler.h"
#import "InviteTransitionConnectionHandler.h"
#import "CheckAllStarsTableViewCell.h"
#import "NonScheduledTableViewCell.h"

@interface InviteViewController ()

@property (strong, nonatomic) IBOutlet UIButton *restaurants;
@property (strong, nonatomic) IBOutlet UITableView *rsvpTable;

@property (strong, nonatomic) IBOutlet UITableView *navBar;
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
@property (strong, nonatomic) UIActivityIndicatorView *restaurantSpinner;
@property (strong, nonatomic) UIActivityIndicatorView *oneRestSpinner;
@property (strong, nonatomic) UILabel *loadingLabel;
@property (strong, nonatomic) UILabel *oneRestLoadingLabel;
@property CGRect originalPosish;
@property (strong, nonatomic) NSMutableData* responseData;
@property (strong, nonatomic) IBOutlet UILabel *msg;
@property (strong, nonatomic) UIView* labelbg;
@property double start;
@property (strong, nonatomic) NSNumber* tries;
@property (strong, nonatomic) NSTimer* timer;
@property (strong, nonatomic) IBOutlet UITableView* oneRest;
@property (strong, nonatomic) UIActivityIndicatorView* reloadingRests;
@property BOOL reloading;


@end

@implementation InviteViewController
@synthesize invitation, rsvpTable, going, undecided, notGoing, overview, restaurants,  restaurantsTable, white, acquired, tries, restaurantsArr, responseData, voteChanged, selectedIndexPath, scheduled, labelbg, start, timer, oneRest,restsPressed, previousInvitation;

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"in view did load");
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
    self.reloading = NO;
    self.rsvpTable.backgroundColor = [UIColor clearColor];
    //self.view.backgroundColor = [UIColor colorWithPatternImage:GET_IMG(@"bg")];
    ((CreateMealNavigationController*)self.navigationController).invitation = self.invitation;
    ((CreateMealNavigationController*)self.navigationController).creator = NO;
    self.navigationController.navigationBarHidden = YES;
    self.restaurantSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.restaurantSpinner setFrame:CGRectMake(160 - (self.restaurantSpinner.frame.size.width/2), self.restaurantsTable.frame.origin.y + 5, self.restaurantSpinner.frame.size.width, self.restaurantSpinner.frame.size.height)];
    [self.restaurantSpinner startAnimating];
    [self.view addSubview:self.restaurantSpinner];
    self.reloadingRests = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.reloadingRests setFrame:CGRectMake(160 - (self.reloadingRests.frame.size.width/2), self.overview.center.y - (self.reloadingRests.frame.size.height/2), self.reloadingRests.frame.size.width, self.reloadingRests.frame.size.height)];
    [self.reloadingRests startAnimating];
    [self.view addSubview:self.reloadingRests];
    self.loadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.restaurantSpinner.frame.origin.y + self.restaurantSpinner.frame.size.height + 2, self.view.frame.size.width, 50)];
    self.loadingLabel.text = loadingRestaurantsText;
    self.loadingLabel.font = [UIFont systemFontOfSize:15];
    self.loadingLabel.numberOfLines = 2;
    self.loadingLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.loadingLabel];
    self.oneRestSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.oneRestSpinner setFrame:CGRectMake(160 - (self.oneRestSpinner.frame.size.width/2), self.oneRest.frame.origin.y + 5, self.oneRestSpinner.frame.size.width, self.oneRestSpinner.frame.size.height)];
    self.oneRestLoadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.oneRestSpinner.frame.origin.y + self.oneRestSpinner.frame.size.height + 2, self.view.frame.size.width, 50)];
    [self.oneRestSpinner startAnimating];
    [self.view addSubview:self.oneRestSpinner];
    self.oneRestLoadingLabel.text = loadingRestaurantsText;
    self.oneRestLoadingLabel.font = [UIFont systemFontOfSize:15];
    self.oneRestLoadingLabel.numberOfLines = 2;
    self.oneRestLoadingLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.oneRestLoadingLabel];
    [self.navBar setDelegate:self];
    [self.navBar setDataSource:self];

    [self.view sendSubviewToBack:self.restaurants];
    [self.view sendSubviewToBack:self.overview];
    [self.view sendSubviewToBack:self.white];
   // [self.view bringSubviewToFront:self.msg];
    self.inviteSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.inviteSpinner setFrame:CGRectMake(self.view.frame.size.width - self.inviteSpinner.frame.size.width, self.date.frame.origin.y, self.inviteSpinner.frame.size.width, self.inviteSpinner.frame.size.height)];
    [self.view addSubview:self.inviteSpinner];
    [self.rsvpTable setFrame:CGRectMake(self.rsvpTable.frame.origin.x, self.rsvpTable.frame.origin.y - 900, self.rsvpTable.frame.size.width, self.rsvpTable.frame.size.height)];
   /* labelbg = [[UIView alloc] initWithFrame:CGRectMake(self.msg.frame.origin.x - 5, self.msg.frame.origin.y + 7, self.msg.frame.size.width + 10, self.msg.frame.size.height -10)];
    labelbg.backgroundColor = [Graphics colorWithHexString:@"ffa500"];
    labelbg.alpha = .5;
    labelbg.layer.cornerRadius = 8;
    [labelbg setFrame:CGRectMake(self.msg.frame.origin.x - 5, self.msg.frame.origin.y + 7, self.msg.frame.size.width + 10, self.msg.frame.size.height -10)];*/
    self.originalPosish = self.restaurantsTable.frame;
}


//Everything that could change with a fresh invitation
- (void) layoutView{
    [self.inviteSpinner stopAnimating];
    NSMutableArray* arrays = [self.invitation generateResponsesArrays];
    self.going = arrays[0];
    self.undecided = arrays[1];
    self.notGoing = arrays[2];
    if ((!self.previousInvitation) || (![self.invitation isEqual:self.previousInvitation])){
        if (self.invitation.scheduled || self.invitation.iResponded){
            NSLog(@"laying out rests pressed");
            [self layoutAccordingToRestsPressed];
        }
        else{
            [self layoutAcceptDecline];
        }
        if (self.invitation.scheduled){
            [((CheckAllStarsTableViewCell*)[self.navBar cellForRowAtIndexPath:INDEX_PATH(0, 0)]).titleLabel setText:@"Meal"];
            self.date.text = [@"Scheduled For " stringByAppendingString:[self.invitation dateToString]];
            [self.rsvpTable setContentInset:UIEdgeInsetsMake(20, 0, 0, 0)];
            //self.message.hidden = YES;
           // self.msg.hidden = YES;
            self.timerLabel.hidden = YES;
           // self.labelbg.hidden = YES;
            [self.timer invalidate];
        }
        else{
            [((CheckAllStarsTableViewCell*)[self.navBar cellForRowAtIndexPath:INDEX_PATH(0, 0)]).titleLabel setText:@"Invite"];
            self.date.text = [self.invitation dateToString];
           // self.oneRest.hidden = YES;
            [self updateCounter:nil];
            [self.timer invalidate];
            self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateCounter:) userInfo:nil repeats:YES];
      /*      if (self.invitation.message.length >80)
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
            [self.view addSubview:labelbg];*/
        }
    }
    if (self.previousInvitation){
        [self.restaurantsTable reloadData];
        [self.rsvpTable reloadData];
        [self.oneRest reloadData];
    }
    self.wereDone =  (self.previousInvitation.updatingRecommendations == 0) && (self.invitation.updatingRecommendations == 0);
    self.previousInvitation = self.invitation;
    NSLog(@"recalling");
    NSLog(@"updating: %d", self.invitation.updatingRecommendations);
    [self performSelector:@selector(recall) withObject:nil afterDelay:10];
   /* if (self.invitation.updatingRecommendations > 0){
        bool retry;
        @synchronized(self.tries){
            self.tries = [NSNumber numberWithInt:([self.tries integerValue ]+ 1)];
         //   retry = ([self.tries integerValue] < 50);
        }
        retry = YES;
        if (retry){
            NSLog(@"retrying...");
            [self performSelector:@selector(recall) withObject:nil afterDelay:10];
        }
        else
            NSLog(@"retries exceeded max val before restaurants updated");
    }
    else{
        @synchronized(self.tries){
            self.tries = [NSNumber numberWithInt:0];
        }
    }*/
   // [labelbg setFrame:CGRectMake(self.msg.frame.origin.x - 5, self.msg.frame.origin.y + 7, self.msg.frame.size.width + 10, self.msg.frame.size.height -10)];

}
-(void) recall{
    NSLog(@"RREEECCALLLEDDD");
    if(!self.invtrans)
        self.invtrans = [[InviteTransitionConnectionHandler alloc] initWithInvitateViewController:self];
    [User getInvitation:self.invitation.num source:self.invtrans];
}
-(void) saveRests{
    NSMutableArray* serialzedRests = [[NSMutableArray alloc] init];
    for (Restaurant* r in self.restaurantsArr)
        [serialzedRests addObject:[r serializeToData]];
    [LEViewController setUserDefault:[@"restaurants" stringByAppendingString:[NSString stringWithFormat:@"%d", self.invitation.num]] data:serialzedRests];
}


-(void)viewWillAppear:(BOOL)animated{
      [self layoutView];
  /*  if(!self.invtrans)
        self.invtrans = [[InviteTransitionConnectionHandler alloc] initWithInvitateViewController:self];

   // NSLog(@"invite view location: %@", L.myLocation);
    [User getInvitation:self.invitation.num source:self.invtrans];
   // [labelbg setFrame:CGRectMake(self.msg.frame.origin.x - 5, self.msg.frame.origin.y + 7, self.msg.frame.size.width + 10, self.msg.frame.size.height -10)];*/

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
        if (!self.invtrans)
            self.invtrans = [[InviteTransitionConnectionHandler alloc] initWithInvitateViewController:self];

        [User getInvitation:self.invitation.num source:self.invtrans];
        //[User getMeals:]
        [self.labelbg setHidden:YES];
        [self.labelbg removeFromSuperview];
       // [self.msg removeFromSuperview];
        //[self.message removeFromSuperview];
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
    if (tableView == self.navBar || tableView == self.oneRest)
        return 0;
    return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (tableView == self.oneRest){
        return 0;
    }
    return 0;
}
/*
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.oneRest){
        if (self.invitation.scheduled)
            return 80;
        else
            return 50;
        
    }
    if (tableView == self.restaurantsTable) {
        return 80;
    }
    if (tableView == self.navBar){
        return 44;
    }
    if (tableView == self.rsvpTable){
        return 44;
    }
    return 0;
}*/
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
    [self.oneRestSpinner stopAnimating];
    self.loadingLabel.hidden = YES;
    [self.restaurantSpinner stopAnimating];
    [self.reloadingRests stopAnimating];
    self.oneRestLoadingLabel.hidden = YES;
    [self.overview setTitle:@"Decline" forState:UIControlStateNormal];
    [self.restaurants setTitle:@"Attend" forState:UIControlStateNormal];
    self.restaurants.backgroundColor = [UIColor colorWithPatternImage:GET_IMG(@"declineattend")];
    self.overview.backgroundColor = [UIColor colorWithPatternImage:GET_IMG(@"declineattend")];
    self.restaurantsTable.hidden = YES;
    self.oneRest.hidden = NO;
   // self.message.hidden = NO;
   // self.labelbg.hidden = NO;
   // self.msg.hidden = NO;
    self.rsvpTable.hidden = NO;
    [self.restaurants setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    [self.overview setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
}
- (IBAction)overviewPressed:(id)sender {
    NSLog(@"overview pressed");
    if (self.invitation.iResponded || self.invitation.scheduled){
        self.restsPressed = NO;
        [self layoutAccordingToRestsPressed];
    }
    else{
        [self layoutAcceptDecline];
        UIAlertView* noResponseAlert = [[UIAlertView alloc] initWithTitle:@"Decline?" message:@"Include an optional message:" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
        noResponseAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
        [noResponseAlert textFieldAtIndex:0].delegate = self;
        [noResponseAlert show];

        
    }
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return !([textField.text length]>40 && [string length] > range.length);
}
- (void) layoutAccordingToRestsPressed{
    /*
     self.central.backgroundColor = [UIColor whiteColor];
     self.byMe.backgroundColor = [UIColor clearColor];
     [self.central setTitleColor:[Graphics colorWithHexString:@"2d769b"] forState:UIControlStateNormal];
     [self.byMe setTitleColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:.18] forState:UIControlStateNormal];*/
    
    [self.overview setTitle:@"Overview" forState:UIControlStateNormal];
    [self.restaurants setTitle:@"Restaurants" forState:UIControlStateNormal];
    if (self.restsPressed){
        self.oneRestLoadingLabel.hidden = YES;
        [self.oneRestSpinner stopAnimating];
        self.restaurants.backgroundColor = [UIColor whiteColor];
        self.overview.backgroundColor = [UIColor clearColor];
        [self.restaurants setTitleColor:[Graphics colorWithHexString:@"2d769b"] forState:UIControlStateNormal];
        [self.overview setTitleColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:.18] forState:UIControlStateNormal];
        self.restaurantsTable.hidden = NO;
        self.date.hidden = YES;
        if (!self.invitation.scheduled){
           // self.message.hidden = YES;
            //self.msg.hidden = YES;
            //self.labelbg.hidden = YES;
        }
        self.rsvpTable.hidden = YES;
        self.oneRest.hidden = YES;
        self.timerLabel.hidden = YES;
        if (self.invitation.updatingRecommendations > 0){
            NSLog(@"updating");
            if (((self.invitation.restaurants) && (self.invitation.restaurants.count == 15)) || self.reloading){
                [self.reloadingRests startAnimating];
                [self.restaurantSpinner stopAnimating];
                self.loadingLabel.hidden = YES;
                [self.restaurantsTable setFrame:self.originalPosish];
                [self.restaurantsTable setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
                self.reloading = YES;
            }
            else{
                [self.reloadingRests stopAnimating];
                [self.restaurantSpinner startAnimating];
                self.loadingLabel.hidden = NO;
                [self.restaurantsTable setFrame:CGRectMake(self.originalPosish.origin.x, self.originalPosish.origin.y + 70,self.originalPosish.size.width, self.originalPosish.size.height)];
            }
           // [self.restaurantsTable setContentInset:UIEdgeInsetsMake(70, 0, 0, 0)];
        }
        else{
            NSLog(@"not updating");
            self.reloading = NO;
            [self.reloadingRests stopAnimating];
            [self.restaurantSpinner stopAnimating];
            self.loadingLabel.hidden = YES;
            [self.restaurantsTable setFrame:self.originalPosish];
            [self.restaurantsTable setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        }
    }
    else{
        [self.reloadingRests stopAnimating];
        self.loadingLabel.hidden = YES;
        [self.restaurantSpinner stopAnimating];
        self.overview.backgroundColor = [UIColor whiteColor];
        self.restaurants.backgroundColor = [UIColor clearColor];
        [self.overview setTitleColor:[Graphics colorWithHexString:@"2d769b"] forState:UIControlStateNormal];
        [self.restaurants setTitleColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:.18] forState:UIControlStateNormal];
        self.restaurantsTable.hidden = YES;
        self.date.hidden = NO;
        self.oneRest.hidden = NO;
        self.rsvpTable.hidden = NO;
        if (self.invitation.scheduled)
            self.timerLabel.hidden = YES;
        else
            self.timerLabel.hidden = NO;
        if (self.invitation.updatingRecommendations > 0 && self.invitation.scheduled){
            [self.oneRestSpinner startAnimating];
            self.oneRestLoadingLabel.hidden = NO;
        }
        else{
            [self.oneRestSpinner stopAnimating];
            self.oneRestLoadingLabel.hidden = YES;
        }
    }
}
-(void)rp{
    NSLog(@"rests pressed");
    if (self.invitation.iResponded || self.invitation.scheduled){
        self.restsPressed = YES;
        [self layoutAccordingToRestsPressed];
    }
    else{
        [self layoutAcceptDecline];
        [self performSegueWithIdentifier:@"inviteToWhat" sender:self];
    }
}
- (IBAction)restsPressed:(id)sender {
    [self rp];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1)
        [User respondNo:self.invitation.num message:[alertView textFieldAtIndex:0].text source:self];
}
//just for declines
-(void) connectionDidFinishLoading:(NSURLConnection*)connection{
    InvitationsViewController* ivc = [self.navigationController viewControllers][[self.navigationController viewControllers].count - 2 ];
    [ivc.upcomingInvitations removeObject:self.invitation];
    [self.navigationController popViewControllerAnimated:YES];
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
    if(((tableView == self.oneRest && self.invitation.scheduled) || (tableView == self.restaurantsTable)) && (self.invitation.restaurants.count > selectedIndexPath.row)) {
        self.selectedIndexPath = indexPath;
        [self performSegueWithIdentifier:@"inviteToRestaurant" sender:self];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.navBar)
        return 1;
    if (tableView == self.rsvpTable){
        if (section == 0)
            return [self.going count];
        if (section == 1)
            return [self.undecided count];
        return [self.notGoing count];}
    else if (tableView == self.restaurantsTable){
        if (self.invitation.updatingRecommendations == 0)
            return MAX(1,[self.invitation.restaurants count]);
        else
            return [self.invitation.restaurants count];
    }
    else if (tableView == self.oneRest)
        return 1;
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
    //NSLog(@"in cfraip");
    //if (tableView == self.oneRest)
      //  NSLog(@"onerest");
    if (tableView == self.navBar){
        CheckAllStarsTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CheckAllStars"];
        [cell setWithInviteVC:self];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }
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

    if (tableView == self.oneRest){
        NSLog(@"one rest laying out");
        if (self.invitation.scheduled){
            RestaurantTableViewCell* cell =  [tableView dequeueReusableCellWithIdentifier:@"restCell2"];
            if (self.invitation.restaurants.count && self.invitation.restaurants[indexPath.row] && (self.invitation.updatingRecommendations == 0)){
                [cell.subviews setValue:@NO forKey:@"hidden"];
                [cell setWithRestaurant:self.invitation.restaurants[indexPath.row] rowInput:indexPath.row ivcInput:self oneRestInput:YES];
            }
            else if (self.invitation.updatingRecommendations == 0 && self.wereDone && (self.invitation.restaurants.count==0)){
                [cell.subviews setValue:@NO forKey:@"hidden"];
                [cell setNothingOpen];
            }
            else{
                [cell.subviews setValue:@YES forKey:@"hidden"];
            }
            return cell;
        }
        else{
            NonScheduledTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"nonScheduled"];
            [cell setWithIVC:self];
            return cell;
        }
        
    }
    else{
        RestaurantTableViewCell* cell =  [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (self.invitation.restaurants.count)
            [cell setWithRestaurant:self.invitation.restaurants[indexPath.row] rowInput:indexPath.row ivcInput:self oneRestInput:NO];
        else
            [cell setNothingOpen];
         return cell;
    }
    
   
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    NSLog(@"received memory warning");
    // Dispose of any resources that can be recreated.
}

@end
