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


@interface WhoViewController ()
@property (strong, nonatomic) IBOutlet UITableView* friendsTable;
@property (strong, nonatomic) IBOutlet UISearchBar* search;

@property (strong, nonatomic) NSMutableArray *friendsCache;
@property (strong, nonatomic) UIImage* unchecked;
@property (strong, nonatomic) UIImage* checked;
@property (strong, nonatomic) IBOutlet UIButton* transition;
@property BOOL initializing;
@end

@implementation WhoViewController
@synthesize friends, unchecked, checked, initializing, transition;


- (void)viewDidLoad
{
    [super viewDidLoad];
    [User getFriends:self];
    [self.search setDelegate:self];
    self.friendsTable.dataSource = self;
    self.friendsTable.delegate = self;
    self.unchecked = [UIImage imageNamed:@"unchecked.png"];
    self.checked = [UIImage imageNamed:@"checked.png"];
    self.friendsCache = [self loadMutable];
    self.friends = [self.friendsCache mutableCopy];
    [self.friendsTable reloadData];
    
}

-(NSMutableArray*)loadMutable
{
    NSArray *friendsCacheLoaded = [[NSUserDefaults standardUserDefaults] arrayForKey:@"friendsCache"];
    NSMutableArray* ret = [[NSMutableArray alloc] init];
    for (NSDictionary* dict in friendsCacheLoaded)
    {
        NSMutableDictionary* mutDict = [dict mutableCopy];
        mutDict[@"checked"] = @NO;
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
               
                if ((!([[dict objectForKey:@"displayName"] rangeOfString:name options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch)].length > 0)) && (![name isEqualToString: @""])){
                    allin = NO;
                    break;
                }
            }
            if (allin)
                [self.friends addObject:dict];
        }
    }
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

- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSDictionary *resultsDictionary = [data objectFromJSONData];
   if ([resultsDictionary objectForKey:@"success"])
   {
       for (NSString* key in [resultsDictionary objectForKey:@"friends"])
       {
           if (![self cacheContainsContact:key])
           {
               NSMutableDictionary *dict;
               dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                   key, @"displayName", [[resultsDictionary objectForKey:@"friends"] objectForKey:key], @"numbers", @NO, @"checked", nil];
               [self.friendsCache addObject:dict];
           }
        }
       NSSortDescriptor *nameDescriptor =
       [[NSSortDescriptor alloc] initWithKey:@"displayName"
                                   ascending:YES
                                    selector:@selector(localizedCaseInsensitiveCompare:)];

       NSArray *descriptors = [NSArray arrayWithObjects:nameDescriptor, nil];

       self.friendsCache = [[[self.friendsCache copy] sortedArrayUsingDescriptors:descriptors] mutableCopy];

       [LEViewController setUserDefault:@"friendsCache" data:self.friendsCache];
       [self storeFriends:self.friendsCache];

       self.friends = [self.friendsCache mutableCopy];
       [self.friendsTable reloadData];
      
   }


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
    
        
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSMutableDictionary* friend = [self.friends objectAtIndex:indexPath.row];
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
    if ([self atLeastOneChecked])
    {
        [self.transition setTitle:@"Eat with Them^^" forState:UIControlStateNormal];
    }
    else{
        [self.transition setTitle:@"Eat Solo" forState:UIControlStateNormal];
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