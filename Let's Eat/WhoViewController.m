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

@interface WhoViewController ()
@property (strong, nonatomic) IBOutlet UITableView* friendsTable;
@property (strong, nonatomic) IBOutlet UISearchBar* search;
@property (strong, nonatomic) NSMutableArray *friends;
@property (strong, nonatomic) NSMutableArray *friendsCache;
@end

@implementation WhoViewController
@synthesize friends;


- (void)viewDidLoad
{
    [super viewDidLoad];
    [User getFriends:self];
    [self.search setDelegate:self];
    self.friendsTable.dataSource = self;
    self.friendsTable.delegate = self;
    self.friends = [NSMutableArray array];
    NSArray *friendsCacheLoaded = [[NSUserDefaults standardUserDefaults] arrayForKey:@"friendsCache"];
    if (friendsCacheLoaded != nil)
        self.friendsCache = [friendsCacheLoaded mutableCopy];
    else
        self.friendsCache = [[NSMutableArray alloc] init];
    
    [self.friends addObjectsFromArray:self.friendsCache];
    [self.friendsTable reloadData];
    
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self.friends removeAllObjects];
    if ([searchText isEqualToString:@""])
        self.friends = [self.friendsCache mutableCopy];
    else
    {
        NSArray* splitSearch = [searchText componentsSeparatedByString:@" "];
        for(NSDictionary *dict in self.friendsCache)
        {

            bool allin = YES;
           
            for (NSString* name in splitSearch){
                NSLog(@"name %@", name);
                if ((!([[dict objectForKey:@"displayName"] rangeOfString:name options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch)].length > 0)) && (![name isEqualToString: @""])){
                    allin = NO;
                    break;
                }
            }
            if (allin)
                [self.friends addObject:dict];
        }
    }

            /*
    [self.friends removeAllObjects];
    if ([searchText isEqualToString:@""])
        self.friends = [self.friendsCache mutableCopy];
    else
    {
        for(NSDictionary *dict in self.friendsCache)
        {
            NSArray* splitName = [[dict objectForKey:@"displayName"] componentsSeparatedByString:@" "];
            NSArray* splitSearch = [searchText componentsSeparatedByString:@" "];
            if ([splitName count] == [splitSearch count]){
                int counter = 0;
                bool allSame = YES;
                for (NSString* name in splitName){
                    if (![name isEqualToString:[splitSearch objectAtIndex:counter]]){
                        allSame = NO;
                        break;
                    }
                    counter++;
                }
                if (allSame)
                    [self.friends addObject:dict]
                }
            }
            if ([[dict objectForKey:@"displayName"] rangeOfString:searchText options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch)].length > 0)
                [self.friends addObject:dict];

        }
    }*/
    [self.friendsTable reloadData];
}


- (BOOL) cacheContainsContact:(NSString *)name
{
    for (NSDictionary* element in self.friendsCache)
    {
        if ([[element objectForKey:@"displayName"] isEqualToString:name])
            return YES;
    }
    return NO;
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
               NSDictionary *dict;
               dict = [NSDictionary dictionaryWithObjectsAndKeys:
                   key, @"displayName", [resultsDictionary objectForKey:@"friends"], @"numbers", nil];
               [self.friendsCache addObject:dict];
           }
        }
       NSSortDescriptor *nameDescriptor =
       [[NSSortDescriptor alloc] initWithKey:@"displayName"
                                   ascending:YES
                                    selector:@selector(localizedCaseInsensitiveCompare:)];
       NSArray *descriptors = [NSArray arrayWithObjects:nameDescriptor, nil];
       NSArray *array = [[self.friendsCache copy] sortedArrayUsingDescriptors:descriptors];
       [LEViewController setUserDefault:@"friendsCache" data:array];
       self.friendsCache = [array mutableCopy];
       self.friends = [array mutableCopy];
       [self.friendsTable reloadData];
   }


}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType=UITableViewCellAccessoryCheckmark;
    }
    NSDictionary *f = [self.friends objectAtIndex:indexPath.row];
    cell.textLabel.text = [f objectForKey:@"displayName"];
        
    return cell;
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
