//
//  TellFriendsViewController.m
//  Let's Eat
//
//  Created by Ryan Kass on 3/16/14.
//  Copyright (c) 2014 Ryan Kass. All rights reserved.
//

#import "TellFriendsViewController.h"
#import "Graphics.h"
#import "CreateMealNavigationController.h"
#import "WhoViewController.h"
#import "User.h"
#import "JSONKit.h"

@interface TellFriendsViewController ()
@property (strong, nonatomic) IBOutlet UITableView *table;
@property (strong, nonatomic) CreateMealNavigationController* nav;
@property (strong, nonatomic) IBOutlet UISearchBar *search;
@property NSMutableArray* invitees;
@property NSMutableArray* inviteesCache;
@property (strong, nonatomic) UIImage* unchecked;
@property (strong, nonatomic) UIImage* checked;
@property (strong, nonatomic) UIAlertView* warningAlert;
@property (strong, nonatomic) UIAlertView* sentAlert;

@end

@implementation TellFriendsViewController

@synthesize nav, invitees, checked, unchecked, search, inviteesCache, table, warningAlert, sentAlert;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.inviteesCache = [self loadMutable];
    self.invitees = [self.inviteesCache mutableCopy];
    [User getNonFriends:self];
    self.nav = (CreateMealNavigationController*)self.navigationController;
    
    if ([[self.nav viewControllers][[[self.nav viewControllers] count] - 2] isKindOfClass:[WhoViewController class]]){
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

    }
    else{
        [self.navigationController setNavigationBarHidden:NO];
        UIImage *bigImg = [UIImage imageNamed:@"HomeBack"];
        UIImage* backImg = [Graphics makeThumbnailOfSize:bigImg size:CGSizeMake(37,22)];
        UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
        back.bounds = CGRectMake( 0, 0, backImg.size.width, backImg.size.height );
        [back setImage:backImg forState:UIControlStateNormal];
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:back];
        [back addTarget:self action:@selector(backPressed:) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.leftBarButtonItem = backItem;
    }

    [self.table reloadData];
    self.title = @"Add Friends";
    self.view.backgroundColor = [Graphics colorWithHexString:@"f5f0df"];
    self.table.dataSource = self;
    self.table.delegate = self;
    self.search.delegate = self;
    UIImage* bigunchecked = [UIImage imageNamed:@"unchecked"];
    UIImage* bigchecked = [UIImage imageNamed:@"checked"];
    self.unchecked = [Graphics makeThumbnailOfSize:bigunchecked size:CGSizeMake(20, 20)];
    self.checked = [Graphics makeThumbnailOfSize:bigchecked size:CGSizeMake(20, 20)];
}
-(void)homePressed:(UIBarButtonItem*)sender{
    [self.navigationController popToRootViewControllerAnimated:YES];
    self.navigationController.navigationBarHidden = YES;
}
-(void)backPressed:(UIBarButtonItem*)sender{
    [self.navigationController popViewControllerAnimated:YES];
    if (![[self.nav viewControllers][[[self.nav viewControllers] count] - 1] isKindOfClass:[WhoViewController class]])
        [self.navigationController setNavigationBarHidden:YES];
    
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    self.search.text = @"";
    [self.invitees removeAllObjects];
    self.invitees = [self.inviteesCache mutableCopy];
    [self.table reloadData];
    self.search.showsCancelButton = NO;
}
-(NSMutableArray*)getChecked{
    NSMutableArray* ret = [[NSMutableArray alloc] init];
    for (NSMutableDictionary* dict in self.invitees){
        if ([dict[@"checked"] isEqual: @YES]){
            for (NSString* number in dict[@"numbers"])
                 [ret addObject:number];
        }
    }
    return ret;
}

- (IBAction)messageApp:(id)sender {
    MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
    picker.messageComposeDelegate = self;
    NSLog(@"get checked: %@", self.getChecked);
    picker.recipients = [self getChecked];
    picker.body = @"Check out Let's Eat! It helps you and your friends pick which restaurant to go: http://letseatapp.com/";
    [self presentViewController:picker animated:YES completion:nil];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        
    }
    NSMutableDictionary *i = [self.invitees objectAtIndex:indexPath.row];
    if ([i[@"checked"]  isEqual: @YES])
    {
        UIImageView* accChecked = [[UIImageView alloc] initWithImage:self.checked];
        cell.accessoryView = accChecked;
    }
    else
    {
        UIImageView* accUnchecked = [[UIImageView alloc] initWithImage:self.unchecked];
        cell.accessoryView = accUnchecked;
    }
    
    cell.textLabel.text = [i objectForKey:@"displayName"];
    cell.backgroundColor = [Graphics colorWithHexString:@"f5f0df"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (BOOL) cacheContainsContact:(NSString *)name
{
    for (NSMutableDictionary* element in self.inviteesCache)
    {
        if ([[element objectForKey:@"displayName"] isEqualToString:name])
            return YES;
    }
    return NO;
}


- (void) storeInvitees:(NSMutableArray*) array
{
    
    [LEViewController setUserDefault:@"inviteesCache" data:array];
}

- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    
    NSDictionary *resultsDictionary = [data objectFromJSONData];
    NSLog(@"Invitees: %@", resultsDictionary);
    if ([resultsDictionary objectForKey:@"success"])
    {
        [self.inviteesCache removeAllObjects];
        for (NSString* key in [resultsDictionary objectForKey:@"friends"])
        {
            
                NSMutableDictionary *dict;
                dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                        key, @"displayName", [[resultsDictionary objectForKey:@"friends"] objectForKey:key], @"numbers", @NO, @"checked", nil];
                [self.inviteesCache addObject:dict];
                // NSLog(@"inside");

        }
        NSLog(@"invitees cache 1%@", self.inviteesCache);
        NSSortDescriptor *nameDescriptor =
        [[NSSortDescriptor alloc] initWithKey:@"displayName"
                                    ascending:YES
                                     selector:@selector(localizedCaseInsensitiveCompare:)];
        
        NSArray *descriptors = [NSArray arrayWithObjects:nameDescriptor, nil];
        NSMutableArray* copi = [self.inviteesCache mutableCopy];
        self.inviteesCache = [[copi sortedArrayUsingDescriptors:descriptors] mutableCopy];
        [LEViewController setUserDefault:@"inviteesCache" data:self.inviteesCache];
        [self storeInvitees:self.inviteesCache];
        self.invitees = [self.inviteesCache mutableCopy];
        [self.table reloadData];
        NSLog(@"invitees cache %@", self.inviteesCache);
        NSLog(@"invitees %@", self.invitees);
    }
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSMutableDictionary* invitee = [self.invitees objectAtIndex:indexPath.row];
    if ([invitee[@"checked"]  isEqual: @YES])
    {
        
        UIImageView* accUnchecked = [[UIImageView alloc] initWithImage:self.unchecked];
        cell.accessoryView = accUnchecked;
        invitee[@"checked"] = @NO;
        
    }
    else
    {
        
        UIImageView* accChecked = [[UIImageView alloc] initWithImage:self.checked];
        cell.accessoryView = accChecked;
        invitee[@"checked"] = @YES;
    }
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.invitees count];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSMutableArray*)loadMutable
{
    NSArray *inviteesCacheLoaded = [[NSUserDefaults standardUserDefaults] arrayForKey:@"inviteesCache"];
    NSMutableArray* ret = [[NSMutableArray alloc] init];
    for (NSDictionary* dict in inviteesCacheLoaded)
    {
        NSMutableDictionary* mutDict = [dict mutableCopy];
        mutDict[@"checked"] = @NO;
        [ret addObject:mutDict];
    }
    return ret;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    self.search.showsCancelButton = NO;
}
- (void)searchBarTextDidBeginEditing:(UISearchBar*)searchBar
{
    self.search.showsCancelButton = YES;
}
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    [self.navigationController popToRootViewControllerAnimated:YES];
    self.navigationController.navigationBarHidden = YES;
    
}
-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    NSLog(@"pressed");
    switch (result) {
        case MessageComposeResultCancelled:{
            NSLog(@"cancelled");
            [self dismissViewControllerAnimated:YES completion:nil];
            break;
        }
            
        case MessageComposeResultFailed:
        {
            NSLog(@"send failed");
            self.warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to send SMS!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [warningAlert show];
            [self dismissViewControllerAnimated:YES completion:nil];
            break;
        }
            
        case MessageComposeResultSent:{
            NSLog(@"sent");
            [self dismissViewControllerAnimated:YES completion:nil];
            self.sentAlert = [[UIAlertView alloc] initWithTitle:@"Sent" message:@"Invited friends to Let's Eat!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [sentAlert show];

        }
            
        default:
            break;
    }
    

}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self.invitees removeAllObjects];
    if ([searchText isEqualToString:@""])
        self.invitees = [self.inviteesCache mutableCopy];
    else
    {
        
        NSArray* splitSearch = [searchText componentsSeparatedByString:@" "];
        for(NSMutableDictionary *dict in self.inviteesCache)
        {
            
            bool allin = YES;
            
            for (NSString* name in splitSearch){
                //   NSLog(@"split search: %@", name);
                // NSLog(@"display name: %@", [dict objectForKey:@"displayName"]);
                if ((!([[dict objectForKey:@"displayName"] rangeOfString:name options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch)].length > 0)) && (![name isEqualToString: @""])){
                    allin = NO;
                    // NSLog(@"not in");
                    break;
                }
            }
            if (allin){
                //  NSLog(@"adding object %@", [dict objectForKey:@"displayName"]);
                [self.invitees addObject:dict];
            }
        }
    }
    //  NSLog(@"friends %@", self.friends);
    [self.table reloadData];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
