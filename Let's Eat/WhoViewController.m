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
#import "JSONKit.h"
#import "CreateMealNavigationController.h"
#import "Graphics.h"


@interface WhoViewController ()
@property (strong, nonatomic) IBOutlet UITableView* friendsTable;
@property (strong, nonatomic) IBOutlet UISearchBar* search;

@property (strong, nonatomic) NSMutableArray *friendsCache;
@property (strong, nonatomic) UIImage* unchecked;
@property (strong, nonatomic) NSMutableData* responseData;
@property (strong, nonatomic) UIImage* checked;

@property BOOL initializing;
@end

@implementation WhoViewController
@synthesize friends, unchecked, checked, initializing, responseData;


- (void)viewDidLoad
{
    [super viewDidLoad];
    [User getFriends:self];
    [self.search setDelegate:self];
    self.friendsTable.dataSource = self;
    self.friendsTable.delegate = self;
    self.responseData = [[NSMutableData alloc] initWithLength:0];
    UIImage* bigunchecked = [UIImage imageNamed:@"unchecked"];
    UIImage* bigchecked = [UIImage imageNamed:@"checked"];
    self.unchecked = [Graphics makeThumbnailOfSize:bigunchecked size:CGSizeMake(20, 20)];
    self.checked = [Graphics makeThumbnailOfSize:bigchecked size:CGSizeMake(20, 20)];
    self.friendsCache = [self loadMutable];
    self.friends = [self.friendsCache mutableCopy];
    [self.friendsTable reloadData];
    CreateMealNavigationController* cmnc = (CreateMealNavigationController*) self.navigationController;
    cmnc.creator = YES;
    self.navigationController.navigationBarHidden = NO;
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
    self.view.backgroundColor = [Graphics colorWithHexString:@"f5f0df"];
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
    //  NSLog(@"here");
    
    NSDictionary *resultsDictionary = [self.responseData objectFromJSONData];
    NSLog(@"Friends: %@", resultsDictionary);
    //   NSLog(@"%@", resultsDictionary);
    // NSLog(@"friends cache %@", self.friendsCache);
    //  NSLog(@"friends%@", self.friends);
    if ([resultsDictionary objectForKey:@"success"])
    {
        [self.friendsCache removeAllObjects];
        for (NSString* key in [resultsDictionary objectForKey:@"friends"])
        {
            
            NSMutableDictionary *dict;
            dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                    key, @"displayName", [[resultsDictionary objectForKey:@"friends"] objectForKey:key], @"numbers", @NO, @"checked", nil];
            [self.friendsCache addObject:dict];
            // NSLog(@"inside");
            
        }
        NSSortDescriptor *nameDescriptor =
        [[NSSortDescriptor alloc] initWithKey:@"displayName"
                                    ascending:YES
                                     selector:@selector(localizedCaseInsensitiveCompare:)];
        
        NSArray *descriptors = [NSArray arrayWithObjects:nameDescriptor, nil];
        NSMutableArray* copi = [self.friendsCache mutableCopy];
        int removalIndex = [self findMe:self.friendsCache];
        NSLog(@"removal index: %d", removalIndex);
        if(removalIndex != -1)
            [copi removeObjectAtIndex:removalIndex];
        self.friendsCache = [[copi sortedArrayUsingDescriptors:descriptors] mutableCopy];
        NSMutableDictionary* meDict = [[NSMutableDictionary alloc] init];
        [meDict setObject:@"Me" forKey:@"displayName"];
        [meDict setObject:@YES forKey:@"checked"];
        [meDict setObject:@YES forKey:@"Me"];
        [self.friendsCache insertObject:meDict atIndex:0];
        [LEViewController setUserDefault:@"friendsCache" data:self.friendsCache];
        [self storeFriends:self.friendsCache];
        
        self.friends = [self.friendsCache mutableCopy];
        [self.friendsTable reloadData];
        
    }

}
- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.responseData appendData:data];

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
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
    cell.backgroundColor = [Graphics colorWithHexString:@"f5f0df"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSMutableDictionary* friend = [self.friends objectAtIndex:indexPath.row];
    if ([friend objectForKey:@"Me" ])
        return;
    if ([friend[@"checked"]  isEqual: @YES])
    {
 
        UIImageView* accUnchecked = [[UIImageView alloc] initWithImage:self.unchecked];
        cell.accessoryView = accUnchecked;
        friend[@"checked"] = @NO;

    }
    else
    {

        UIImageView* accChecked = [[UIImageView alloc] initWithImage:self.checked];
        cell.accessoryView = accChecked;
        friend[@"checked"] = @YES;
    }

    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.friends count];
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
