//
//  WhoViewController.m
//  Let's Eat
//
//  Created by Ryan Kass on 2/18/14.
//  Copyright (c) 2014 Ryan Kass. All rights reserved.
//

#import "WhoViewController.h"
#import "Server.h"
#import "User.h"
#import "CreateMealNavigationController.h"
#import "Graphics.h"
#import "CheckAllStarsTableViewCell.h"
#import "ProgressBarDelegate.h"
#import "ProgressBarTableViewCell.h"
#import "FacebookLoginViewManager.h"
#import "CustomIOS7AlertView.h"
@interface WhoViewController ()
@property (strong, nonatomic) IBOutlet UITableView* friendsTable;
@property (strong, nonatomic) IBOutlet UITableView *navBar;
@property (strong, nonatomic) IBOutlet UISearchBar* search;
@property bool alertShowing;
@property (strong, nonatomic) IBOutlet UIButton *nextB;
@property (strong, nonatomic) IBOutlet UITableView *progressBar;
@property (strong, nonatomic) NSMutableArray *friendsCache;
@property (strong, nonatomic) IBOutlet UIView *spacer1;
@property (strong, nonatomic) IBOutlet UIView *spacer2;
@property (strong, nonatomic) UIImage* unchecked;
@property (strong, nonatomic) NSMutableData* responseData;
@property (strong, nonatomic) IBOutlet UIButton *rankTypes;
@property (strong, nonatomic) UIImage* checked;
@property (strong, nonatomic) ProgressBarDelegate* pbd;
@property BOOL initializing;
@property (strong, nonatomic) FBLoginView* fblv;
@end

@implementation WhoViewController
@synthesize friends, unchecked, checked, initializing, responseData;


- (void)viewDidLoad
{
    [super viewDidLoad];
   // [LEViewController setUserDefault:@"auth_token" data:@"6de9f6d09ca4849446c63ddl08a387e6362c40dc"];
    [User getFriends:self];
    [self.navBar setDelegate:self];
    [self.navBar setDataSource:self];
    [self.search setDelegate:self];
    self.pbd = [[ProgressBarDelegate alloc] initWithTitle:@"CI"];
    [self.progressBar setDelegate:self.pbd];
    [self.progressBar setDataSource:self.pbd];
    self.friendsTable.dataSource = self;
    self.friendsTable.delegate = self;
    self.spacer1.hidden = YES;
    self.spacer2.hidden = YES;
    [self.nextB setImage:GET_IMG(@"nextpressed") forState:UIControlStateHighlighted];
    self.responseData = [[NSMutableData alloc] initWithLength:0];
    UIImage* bigunchecked = [UIImage imageNamed:@"unchecked"];
    UIImage* bigchecked = [UIImage imageNamed:@"checked"];
    self.unchecked = bigunchecked;
    self.checked = bigchecked;
    self.friendsCache = [self loadMutable];
    self.friends = [self.friendsCache mutableCopy];
    self.rankTypes.titleLabel.textColor = [Graphics colorWithHexString:@"ffa500"];
    [self.friendsTable reloadData];
    CreateMealNavigationController* cmnc = (CreateMealNavigationController*) self.navigationController;
    cmnc.creator = YES;
    [cmnc.invitees removeAllObjects];
    self.navigationController.navigationBarHidden = YES;
    self.title = @"Invitation";
    UIImage *bigImage = [UIImage imageNamed:@"HomeBack"];
    UIImage* homeImg = [Graphics makeThumbnailOfSize:bigImage size:CGSizeMake(37,22)];
    UIButton *home = [UIButton buttonWithType:UIButtonTypeCustom];
    home.bounds = CGRectMake( 0, 0, homeImg.size.width, homeImg.size.height );
    [home setImage:homeImg forState:UIControlStateNormal];
    UIBarButtonItem *homeItem = [[UIBarButtonItem alloc] initWithCustomView:home];
    [home addTarget:self action:@selector(backPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = homeItem;
    UIImage *bigImage2 = [UIImage imageNamed:@"AddFriend"];
    UIImage* addFriendImg = [Graphics makeThumbnailOfSize:bigImage2 size:CGSizeMake(22,22)];
    UIButton *addFriends = [UIButton buttonWithType:UIButtonTypeCustom];
    addFriends.bounds = CGRectMake( 0, 0, addFriendImg.size.width, addFriendImg.size.height );
    [addFriends setImage:addFriendImg forState:UIControlStateNormal];
    UIBarButtonItem *addFriendsItem = [[UIBarButtonItem alloc] initWithCustomView:addFriends];
    [addFriends addTarget:self action:@selector(addFriends:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = addFriendsItem;
    //self.view.backgroundColor = [UIColor colorWithPatternImage:GET_IMG(@"bg")];
    NSMutableDictionary* meDict = [[NSMutableDictionary alloc] init];
    [meDict setObject:@"Me" forKey:@"displayName"];
    [meDict setObject:@YES forKey:@"checked"];
    [meDict setObject:@YES forKey:@"Me"];
    BOOL addMe = YES;
    for (NSMutableDictionary* dict in self.friendsCache){
        if ([dict objectForKey:@"Me"])
            addMe = NO;
    }
    if (addMe)
        [self.friendsCache insertObject:meDict atIndex:0];
    if ([[NSUserDefaults standardUserDefaults] stringForKey:@"facebook_id"]){
        NSLog(@"heeyaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
        [FacebookLoginViewManager sharedManager].currVC = self;
        [FBRequestConnection startWithGraphPath:@"me/friends"
                              completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                                  if (!error) {
                                      // Sucess! Include your code to handle the results here
                                      NSLog(@"user friends: %@", result);
                                      NSMutableArray* preserves = [[NSMutableArray alloc] init];
                                      for (NSMutableDictionary* dict in self.friendsCache){
                                          if (!(dict[@"facebook_id"]))
                                              [preserves addObject:dict];
                                      }
                                      NSMutableArray *checkedx = [[NSMutableArray alloc] init];
                                      for (NSMutableDictionary* djj in self.friendsCache){
                                          if ([djj[@"checked"]  isEqual: @YES])
                                              [checkedx addObject:djj[@"displayName"]];
                                      }
                                      [self.friendsCache removeAllObjects];

                                      for (NSMutableDictionary* dict in preserves){
                                          [self.friendsCache addObject:dict];
                                      }
                                      if (result[@"data"]){
                                          for (NSDictionary* dicshon in result[@"data"]){
                                              NSLog(@"adding...");
                                              NSMutableDictionary *dict;
                                              dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                      dicshon[@"name"], @"displayName", dicshon[@"id"], @"facebook_id", @NO, @"checked", nil];
                                              if ([checkedx indexOfObject:dict[@"displayName"]]!= NSNotFound)
                                                  dict[@"checked"] = @YES;
                                              [self.friendsCache addObject:dict];
                                          }
                                      }
                                      NSSortDescriptor *nameDescriptor =
                                      [[NSSortDescriptor alloc] initWithKey:@"displayName"
                                                                  ascending:YES
                                                                   selector:@selector(localizedCaseInsensitiveCompare:)];
                                      
                                      NSArray *descriptors = [NSArray arrayWithObjects:nameDescriptor, nil];
                                      NSMutableArray* copi = [self.friendsCache mutableCopy];
                                      NSLog(@"friends cache %@", self.friendsCache);
                                      int removalIndex = [self findMe:self.friendsCache];
                                      NSLog(@"removal index: %d", removalIndex);
                                      if(removalIndex != -1)
                                          [copi removeObjectAtIndex:removalIndex];
                                      self.friendsCache = [[copi sortedArrayUsingDescriptors:descriptors] mutableCopy];
                                      NSMutableDictionary* meDict = [[NSMutableDictionary alloc] init];
                                      [meDict setObject:@"Me" forKey:@"displayName"];
                                      [meDict setObject:@YES forKey:@"checked"];
                                      [meDict setObject:@NO forKey:@"Me"];
                                      [self.friendsCache insertObject:meDict atIndex:0];
                                      
                                      [LEViewController setUserDefault:@"friendsCache" data:self.friendsCache];
                                      [self storeFriends:self.friendsCache];
                                      
                                      self.friends = [self.friendsCache mutableCopy];
                                      [self.friendsTable reloadData];
                                  } else {
                                      // An error occurred, we need to handle the error
                                      // See: https://developers.facebook.com/docs/ios/errors
                                  }
                              }];

    }
    
}
-(void)viewWillAppear:(BOOL)animated{
    NSLog(@"Who's gonna appear");
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.friendsTable)
        return self.friends.count;
    return 1;
}


-(int) findMe:(NSMutableArray*)arr{
    int count = 0;
    for (NSMutableDictionary* dict in arr){
        if ([dict objectForKey:@"Me"]){
            NSLog(@"count: %d", count);
            return count;
        }

        count += 1;
    }
    NSLog(@"neg one");
    return -1;
}
- (void) backPressed:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
    self.navigationController.navigationBarHidden = YES;
}
-(void)addFriends:(UIBarButtonItem*) sender{
    [self performSegueWithIdentifier: @"whoToTellFriends" sender: self];   
}

-(NSMutableArray*)loadMutable
{
    NSArray *friendsCacheLoaded = [[NSUserDefaults standardUserDefaults] arrayForKey:@"friendsCache"];
    NSMutableArray* ret = [[NSMutableArray alloc] init];
    for (NSDictionary* dict in friendsCacheLoaded)
    {
        NSMutableDictionary* mutDict = [dict mutableCopy];
        mutDict[@"checked"] = @NO;
        if ([mutDict objectForKey:@"Me"])
            mutDict[@"checked"] = @YES;
        [ret addObject:mutDict];
    }
    return ret;
}

- (BOOL) atLeastOneChecked
{
    for (NSMutableDictionary* dict in self.friends)
    {
        if ([dict[@"checked"]  isEqual: @YES])
            return YES;
        
    }
    return NO;
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    self.search.text = @"";
    [self.friends removeAllObjects];
    self.friends = [self.friendsCache mutableCopy];
    [self.friendsTable reloadData];
    self.search.showsCancelButton = NO;
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

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self.friends removeAllObjects];
    if ([searchText isEqualToString:@""])
        self.friends = [self.friendsCache mutableCopy];
    else
    {
        
        NSArray* splitSearch = [searchText componentsSeparatedByString:@" "];
        for(NSMutableDictionary *dict in self.friendsCache)
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
                [self.friends addObject:dict];
            }
        }
    }
  //  NSLog(@"friends %@", self.friends);
    [self.friendsTable reloadData];
}


- (BOOL) cacheContainsContact:(NSString *)name
{
    for (NSMutableDictionary* element in self.friendsCache)
    {
        if ([[element objectForKey:@"displayName"] isEqualToString:name])
            return YES;
    }
    return NO;
}
        
        
- (void) storeFriends:(NSMutableArray*) array
{

    [LEViewController setUserDefault:@"friendsCache" data:array];
}

- (void)connectionDidFinishLoading:(NSURLConnection*)connection{

    NSDictionary *resultsDictionary = JSONTodict(self.responseData)
    self.responseData = [[NSMutableData alloc] initWithLength:0];
    badLogin(resultsDictionary, self);
    NSLog(@"Friends: %@", resultsDictionary);
    //   NSLog(@"%@", resultsDictionary);
    // NSLog(@"friends cache %@", self.friendsCache);
    //  NSLog(@"friends%@", self.friends);
    if ([resultsDictionary[@"success"] boolValue])
    {
        NSLog(@"friends: %@", resultsDictionary[@"friends"]);
        NSMutableArray* preserves = [[NSMutableArray alloc] init];
        for (NSMutableDictionary* dict in self.friendsCache){
            if (dict[@"facebook_id"])
                [preserves addObject:dict];
        }
        NSMutableArray* checkedx = [[NSMutableArray alloc] init];
        for (NSMutableDictionary* djj in self.friendsCache){
            if ([djj[@"checked"]  isEqual: @YES])
                [checkedx addObject:djj[@"displayName"]];
            
        }
        [self.friendsCache removeAllObjects];
        for (NSMutableDictionary* dict in preserves){
            [self.friendsCache addObject:dict];
        }
        for (NSString* key in [resultsDictionary objectForKey:@"friends"])
        {
            
            NSMutableDictionary *dict;
            dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                    key, @"displayName", [[resultsDictionary objectForKey:@"friends"] objectForKey:key], @"numbers", @NO, @"checked", nil];
            if ([checkedx indexOfObject:dict[@"displayName"]] != NSNotFound )
                dict[@"checked"] = @YES;
            [self.friendsCache addObject:dict];
            // NSLog(@"inside");
            
        }

        NSSortDescriptor *nameDescriptor =
        [[NSSortDescriptor alloc] initWithKey:@"displayName"
                                    ascending:YES
                                     selector:@selector(localizedCaseInsensitiveCompare:)];
        
        NSArray *descriptors = [NSArray arrayWithObjects:nameDescriptor, nil];
        NSMutableArray* copi = [self.friendsCache mutableCopy];
        NSLog(@"friends cache %@", self.friendsCache);
        int removalIndex = [self findMe:self.friendsCache];
        NSLog(@"removal index: %d", removalIndex);
        if(removalIndex != -1)
            [copi removeObjectAtIndex:removalIndex];
        self.friendsCache = [[copi sortedArrayUsingDescriptors:descriptors] mutableCopy];
        NSMutableDictionary* meDict = [[NSMutableDictionary alloc] init];
        [meDict setObject:@"Me" forKey:@"displayName"];
        [meDict setObject:@YES forKey:@"checked"];
        [meDict setObject:@NO forKey:@"Me"];
        [self.friendsCache insertObject:meDict atIndex:0];

        [LEViewController setUserDefault:@"friendsCache" data:self.friendsCache];
        [self storeFriends:self.friendsCache];
        
        self.friends = [self.friendsCache mutableCopy];
        [self.friendsTable reloadData];
        if (YES)/*([[[NSUserDefaults standardUserDefaults] objectForKey:@"getFriends"] intValue] == 0))*/{
            [LEViewController setUserDefault:@"getFriends" data:[NSNumber numberWithInt:1]];
          //  UIAlertView* av = [[UIAlertView alloc] initWithTitle:@"Add some friends" message:@"Invite friends to use Let's Eat by clicking the top right menu button" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
       //     [[FacebookLoginViewManager sharedManager].fblv setFrame:CGRectMake(0, 10, 40, 40)];
       //     [av setValue:customContentView forKey:@"accessoryView"];
          //  if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
             //    [[FacebookLoginViewManager sharedManager].fblv setFrame:CGRectMake(0, 10, 80, 40)];
           //     [av setValue:[FacebookLoginViewManager sharedManager].fblv forKey:@"accessoryView"];
               // v.backgroundColor = [UIColor yellowColor];
           //     [av show];//works only in iOS7
             [[FacebookLoginViewManager sharedManager].fblv setFrame:CGRectMake(0, 10, 200, 40)];
            CustomIOS7AlertView *alertView = [[CustomIOS7AlertView alloc] init];
            [alertView setContainerView:[FacebookLoginViewManager sharedManager].fblv ];
            [alertView show];
        }
        
                //UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(220, 10, 40, 40)];
           // [av addSubview:[FacebookLoginViewManager sharedManager].fblv];
            //[av show];
       // }
    }

}
- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.responseData appendData:data];

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    if (tableView == self.navBar){
        CheckAllStarsTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CheckAllStars"];
        [cell setWithWhoVC:self];
        return cell;
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];

    
    }
    NSMutableDictionary *f = [self.friends objectAtIndex:indexPath.row];
    if ([f[@"checked"]  isEqual: @YES])
    {
        UIImageView* accChecked = [[UIImageView alloc] initWithImage:self.checked];
        cell.accessoryView = accChecked;
    }
    else
    {
        UIImageView* accUnchecked = [[UIImageView alloc] initWithImage:self.unchecked];
        cell.accessoryView = accUnchecked;
    }
        
    cell.textLabel.text = [f objectForKey:@"displayName"];
    cell.backgroundColor = [UIColor clearColor];
    if (indexPath.row == 0)
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    else
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    

    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSMutableDictionary* friend = [self.friends objectAtIndex:indexPath.row];
    NSLog(@"friend: %@", friend);
    if ([friend objectForKey:@"Me" ])
        ;
    else if ([friend[@"checked"]  isEqual: @YES])
    {
 
        UIImageView* accUnchecked = [[UIImageView alloc] initWithImage:self.unchecked];
        cell.accessoryView = accUnchecked;
        friend[@"checked"] = @NO;
        //  NSLog(@"here");

    }
    else
    {

        UIImageView* accChecked = [[UIImageView alloc] initWithImage:self.checked];
        cell.accessoryView = accChecked;
        friend[@"checked"] = @YES;

    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
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
