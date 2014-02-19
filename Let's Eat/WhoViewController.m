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
@end

@implementation WhoViewController
@synthesize friends;


- (void)viewDidLoad
{
    [super viewDidLoad];
    [User getFriends:self];
    self.friendsTable.dataSource = self;
    self.friendsTable.delegate = self;
    
}


- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSDictionary *resultsDictionary = [data objectFromJSONData];
   if ([resultsDictionary objectForKey:@"success"])
   {
       
   }


}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"cell for row");
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = @"Hey";
        
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"rows in section");
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSLog(@"num sections");
    return 1;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
