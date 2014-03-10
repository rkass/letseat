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

@interface HomeViewController ()
@property (strong, nonatomic) UIViewController* whenViewController;
@property (strong, nonatomic) IBOutlet UITableView *optionsTable;
@property (strong, nonatomic) IBOutlet UIDatePicker *date;
@property (strong, nonatomic) IBOutlet UITableView *options;
@end

@implementation HomeViewController
@synthesize whenViewController;

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    self.optionsTable.delegate = self;
    self.optionsTable.dataSource = self;
    self.date.minimumDate = [NSDate date];
    
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        
    }
    if (indexPath.row == 0){
        cell.textLabel.text = @"My Invitations";
        UIImage *bigImage = [UIImage imageNamed:@"Envelope"];
        cell.imageView.image = [Graphics makeThumbnailOfSize:bigImage size:CGSizeMake(20,20)];
    }
    else if (indexPath.row == 1){
        cell.textLabel.text = @"Tell friends about Let's Eat!";
        UIImage *bigImage = [UIImage imageNamed:@"AddFriend"];
        cell.imageView.image = [Graphics makeThumbnailOfSize:bigImage size:CGSizeMake(20,20)];
        
    }
    else{
        cell.textLabel.text = @"Logout";
        UIImage *bigImage = [UIImage imageNamed:@"Logout"];
        cell.imageView.image = [Graphics makeThumbnailOfSize:bigImage size:CGSizeMake(20,20)];
    }
    cell.imageView.frame = CGRectMake(0,0,10,10);
    cell.imageView.bounds = CGRectMake(0,0, 10, 10);
    cell.textLabel.textColor = [Graphics colorWithHexString:@"b8a37e"];
    cell.accessoryView = [[UIImageView alloc] initWithImage:[Graphics makeThumbnailOfSize:[UIImage imageNamed:@"OrangeCarrot"] size:CGSizeMake(10, 10)]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return 48;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
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
