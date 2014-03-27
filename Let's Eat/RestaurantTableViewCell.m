//
//  RestaurantTableViewCell.m
//  Let's Eat
//
//  Created by Ryan Kass on 3/25/14.
//  Copyright (c) 2014 Ryan Kass. All rights reserved.
//
#import "User.h"
#import "RestaurantTableViewCell.h"
#import "JSONKit.h"
#import "LEViewController.h"

@implementation RestaurantTableViewCell
@synthesize snippetImg, ratingImg, name, address, votes, price, vote, types, restaurant, responseData, row, ivc;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    NSLog(@"initting with style");
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)connectionDidFinishLoading:(NSURLConnection*)connection{
    //  NSLog(@"here");
    
    NSDictionary *resultsDictionary = [self.responseData objectFromJSONData];
    NSLog(@"finished: %@", resultsDictionary);
    self.restaurant.votes = [resultsDictionary[@"restaurant"][@"votes"] integerValue];
    self.restaurant.iVoted = [resultsDictionary[@"restaurant"][@"user_voted"] boolValue];
    [self setWithRestaurant:self.restaurant rowInput:self.row ivcInput:self.ivc];
    NSMutableArray* rests = [[NSMutableArray alloc] init];
    for (NSData* data in [[NSUserDefaults standardUserDefaults] arrayForKey:
                          [@"restaurants" stringByAppendingString:[NSString stringWithFormat:@"%d", self.restaurant.invitation]]])
    {
        NSMutableDictionary* dict = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        if ([dict[@"url"] isEqualToString:self.restaurant.url])
            [rests addObject:self.restaurant];
        else
            [rests addObject:[[Restaurant alloc] initWithData:data]];
        
    }
    NSMutableArray* serialzedRests = [[NSMutableArray alloc] init];
    for (Restaurant* r in rests)
        [serialzedRests addObject:[r serializeToData]];
    [LEViewController setUserDefault:[@"restaurants" stringByAppendingString:[NSString stringWithFormat:@"%d", self.restaurant.invitation]] data:serialzedRests];
}

- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSLog(@"appending");
    [self.responseData appendData:data];
    
}


-(void)setVotesText{
    if (self.restaurant.votes == 1)
        self.votes.text = [NSString stringWithFormat:@"%u Vote", self.restaurant.votes];
    else if (self.restaurant.votes == 0)
        self.votes.text = [NSString stringWithFormat:@"No Votes"];
    else
        self.votes.text = [NSString stringWithFormat:@"%u Votes", self.restaurant.votes];
}

- (IBAction)votePressed:(id)sender {
    if (self.restaurant.iVoted){
        self.ivc.voteChanged = YES;
        [self.vote setBackgroundImage:[UIImage imageNamed:@"VoteBackground"] forState:UIControlStateNormal];
        [self.vote setTitle:@"" forState:UIControlStateNormal];
        self.restaurant.iVoted = NO;
        self.restaurant.votes -= 1;
        [User castUnvote:[self.restaurant serialize] source:self];
        
    }
    else{
        self.ivc.voteChanged = YES;
        [self.vote setBackgroundImage:[UIImage imageNamed:@"VotedBackground"] forState:UIControlStateNormal];
        [self.vote setTitle:@"" forState:UIControlStateNormal];
        self.restaurant.iVoted = YES;
        self.restaurant.votes += 1;
        [User castVote:[self.restaurant serialize] source:self];
    }
}

-(void)setWithRestaurant:(Restaurant*)restaurantInput rowInput:(int)rowInput ivcInput:(InviteViewController*)ivcInput{
    if (self.responseData)
        [self.responseData setLength:0];
    self.ivc = ivcInput;
    self.responseData = [[NSMutableData alloc] initWithLength:0];
    self.restaurant = restaurantInput;
    self.row = rowInput;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    NSURL *imageURL = [NSURL URLWithString:self.restaurant.snippetImg];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // Update the UI
            self.snippetImg.image = [UIImage imageWithData:imageData];
        });
    });
    imageURL = [NSURL URLWithString:self.restaurant.ratingImg];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // Update the UI
            self.ratingImg.image = [UIImage imageWithData:imageData];
        });
    });
    self.name.text = [NSString stringWithFormat:@"%u.%@", self.row + 1, self.restaurant.name];
    self.address.text = [self.restaurant.address componentsSeparatedByString:@","][0];
    [self setVotesText];

    self.types.text = [self.restaurant.types componentsJoinedByString:@", "];
    self.price.text = @"";
    int count = 0;
    while (count < self.restaurant.price){
        self.price.text = [self.price.text stringByAppendingString:@"$"];
        count += 1;
    }
    self.percentMatch.text = [NSString stringWithFormat:@"%u%% Match", self.restaurant.percentMatch];
    if (self.restaurant.iVoted){
        [self.vote setBackgroundImage:[UIImage imageNamed:@"VotedBackground"] forState:UIControlStateNormal];
        [self.vote setTitle:@"" forState:UIControlStateNormal];
        self.restaurant.iVoted = YES;
    }
    else{
        [self.vote setBackgroundImage:[UIImage imageNamed:@"VoteBackground"] forState:UIControlStateNormal];
        [self.vote setTitle:@"VOTE" forState:UIControlStateNormal];
        self.restaurant.iVoted = NO;
    }


 
}

- (void)awakeFromNib
{
  
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
