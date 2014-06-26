//
//  HomeViewController.m
//  Let's Eat
//
//  Created by Ryan Kass on 2/13/14.
//  Copyright (c) 2014 Ryan Kass. All rights reserved.
//

#import "HomeViewController.h"
#import "CreateMealNavigationController.h"
#import "Graphics.h"
#import "InvitationsViewController.h"
#import "User.h"
#import "CheckAllStarsTableViewCell.h"

@interface HomeViewController ()
@property (strong, nonatomic) IBOutlet UIView *spacer99;
@property (strong, nonatomic) UIViewController* whenViewController;
@property (strong, nonatomic) IBOutlet UILabel *invite;
@property (strong, nonatomic) IBOutlet UITableView *optionsTable;
@property (strong, nonatomic) IBOutlet UIView *spacer2;
@property (strong, nonatomic) IBOutlet UIView *spacer1;
@property (strong, nonatomic) IBOutlet UIView *spacer3;
@property (strong, nonatomic) IBOutlet UIView *spacer4;
@property (strong, nonatomic) IBOutlet UIButton *selectPeople;
@property (strong, nonatomic) IBOutlet UITableView *navBar;

@property int selectedRow;
@end

@implementation HomeViewController
@synthesize whenViewController, selectedRow;

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    self.spacer1.hidden = YES;
    self.spacer2.hidden = YES;
    self.spacer4.hidden = YES;
    self.spacer3.hidden = YES;
    self.spacer99.hidden = YES;
    [self.navBar setDelegate:self];
    [self.navBar setDataSource:self];
    [User sendToken];
        [LEViewController setUserDefault:@"noConnectionAlertShowing" data:[NSNumber numberWithInteger:0]];
   /* [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.spacer1 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationLessThanOrEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:5]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.spacer1 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:self.spacer1 attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:1]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.spacer1 attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationLessThanOrEqual toItem:self.invite attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:1]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.spacer2 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationLessThanOrEqual toItem:self.invite attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:1]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.spacer2 attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationLessThanOrEqual toItem:self.date attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:1]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.spacer3 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationLessThanOrEqual toItem:self.date attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:1 ]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.spacer3 attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationLessThanOrEqual toItem:self.selectPeople attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:1]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.spacer4 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationLessThanOrEqual toItem:self.selectPeople attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:1]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.spacer4 attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationLessThanOrEqual toItem:self.options attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:1]];
    */
/*
    self.selectPeople.translatesAutoresizingMaskIntoConstraints = NO;
    self.spacer2.translatesAutoresizingMaskIntoConstraints = NO;
    self.spacer1.translatesAutoresizingMaskIntoConstraints = NO;
    self.date.translatesAutoresizingMaskIntoConstraints = NO;
    self.optionsTable.translatesAutoresizingMaskIntoConstraints = NO;
    UIView* spacer22 = [[UIView alloc] init];
    [self.view addSubview:spacer22];
    NSLayoutConstraint* c = [NSLayoutConstraint constraintWithItem:self.date attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.spacer1 attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    [self.view addConstraint:c];
    NSLayoutConstraint* c1 = [NSLayoutConstraint constraintWithItem:spacer22 attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.optionsTable attribute:NSLayoutAttributeTop multiplier:1 constant:0];
   [self.view addConstraint:c1];
    NSLayoutConstraint* c2 = [NSLayoutConstraint constraintWithItem:self.spacer1 attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.selectPeople attribute:NSLayoutAttributeTop multiplier:1 constant:0];
  //  [self.view addConstraint:c2];
    NSLayoutConstraint* c3 = [NSLayoutConstraint constraintWithItem:self.selectPeople attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.spacer2 attribute:NSLayoutAttributeTop multiplier:1 constant:0];
  //  [self.view addConstraint:c3];*/
    //self.optionsTable.translatesAutoresizingMaskIntoConstraints = NO;
 //   NSLayoutConstraint* c = [NSLayoutConstraint constraintWithItem:self.optionsTable attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
  // [self.view addConstraint:c];
   
    [self.selectPeople setImage:GET_IMG(@"bignext") forState:UIControlStateNormal];
    [self.selectPeople setImage:GET_IMG(@"bignextpressed") forState:UIControlStateHighlighted];
    self.navigationController.navigationBarHidden = YES;
    self.optionsTable.delegate = self;
    self.optionsTable.dataSource = self;
    self.date.minimumDate = [[NSDate date] dateByAddingTimeInterval:60*15];
    self.view.backgroundColor = [UIColor colorWithPatternImage:GET_IMG(@"bg")];
    [self.date setMinuteInterval:15];

    
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    if (tableView == self.navBar){
        CheckAllStarsTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CheckAllStars"];
        [cell generalSetup];
        return cell;
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    if (indexPath.row == 0){
        cell.textLabel.text = @"Invitations and Meals";
        UIImage *bigImage = [UIImage imageNamed:@"Envelope"];
        cell.imageView.image = [Graphics makeThumbnailOfSize:bigImage size:CGSizeMake(60, 60)];
    }
    else if (indexPath.row == 1){
        cell.textLabel.text = @"Logout";
        UIImage *bigImage = [UIImage imageNamed:@"Logout"];
        cell.imageView.image = [Graphics makeThumbnailOfSize:bigImage size:CGSizeMake(20,20)];
    }
    else if (indexPath.row == 2){
        cell.textLabel.text = @"Tell friends about Let's Eat!";
        UIImage *bigImage = [UIImage imageNamed:@"AddFriend"];
        cell.imageView.image = [Graphics makeThumbnailOfSize:bigImage size:CGSizeMake(20,20)];
        
    }
    else{
        cell.textLabel.text = @"Logout";
        UIImage *bigImage = [UIImage imageNamed:@"Logout"];
        cell.imageView.image = [Graphics makeThumbnailOfSize:bigImage size:CGSizeMake(20,20)];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleDefault];
    cell.imageView.frame = CGRectMake(0,0,30,30);
    cell.imageView.bounds = CGRectMake(0,0, 30, 30);
    cell.textLabel.textColor = [Graphics colorWithHexString:@"2d769b"];
    [cell.textLabel setFont:[UIFont systemFontOfSize:21]];
    //cell.accessoryView = [[UIImageView alloc] initWithImage:[Graphics makeThumbnailOfSize:[UIImage imageNamed:@"bluecarrot"] size:CGSizeMake(10, 10)]];
    return cell;
}
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1){
        [[NSUserDefaults standardUserDefaults] setPersistentDomain:[NSDictionary dictionary] forName:[[NSBundle mainBundle] bundleIdentifier]];
        [self performSegueWithIdentifier:@"homeToInitial" sender:self];
    }
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.navBar)
        return;
    if (indexPath.row == 0){
        self.selectedRow = 0;
        [self performSegueWithIdentifier:@"homeToInvitations" sender:self];
    }
    else if (indexPath.row == 1){
        UIAlertView* lo = [[UIAlertView alloc] initWithTitle:@"Logout?" message:@"" delegate:self cancelButtonTitle:@"Nope" otherButtonTitles:@"Logout", nil];
        [lo show];

        
        
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString: @"homeToInvitations"]){
        InvitationsViewController* ivc = (InvitationsViewController*)segue.destinationViewController;
        if (self.selectedRow == 0)
            ivc.scheduled = YES;
        else
            ivc.scheduled = NO;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.navBar)
        return 44;
    return 140;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
