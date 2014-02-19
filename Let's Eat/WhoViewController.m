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
#import "Friend.h"

@interface WhoViewController ()
@property (strong, nonatomic) IBOutlet UITableView* friendsTable;
@property (strong, nonatomic) NSMutableArray* friends;
@end

@implementation WhoViewController
@synthesize friends;


- (void)viewDidLoad
{
    [super viewDidLoad];
    [User getFriends:self];
    self.friendsTable.dataSource = self;
    self.friendsTable.delegate = self;
    self.friends = [NSMutableArray array];
    
}


- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSDictionary *resultsDictionary = [data objectFromJSONData];
    NSLog(@"%@", resultsDictionary);
   if ([resultsDictionary objectForKey:@"success"])
   {
       for (NSString* key in [resultsDictionary objectForKey:@"friends"])
       {
           [self.friends addObject:[[Friend alloc] init:key numbers:[[resultsDictionary objectForKey:@"friends"] objectForKey:key]]];
       }
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
    Friend *f = [self.friends objectAtIndex:indexPath.row];
    cell.textLabel.text = f.displayName;
        
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
