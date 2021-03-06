//
//  RestaurantTableViewCell.m
//  Let's Eat
//
//  Created by Ryan Kass on 3/25/14.
//  Copyright (c) 2014 Ryan Kass. All rights reserved.
//
#import "User.h"
#import "RestaurantTableViewCell.h"
#import "LEViewController.h"
#import "Graphics.h"
#import "InviteTransitionConnectionHandler.h"


@implementation RestaurantTableViewCell
@synthesize snippetImg, ratingImg, name, address, votes, price, vote, types, restaurant, responseData, row, ivc, oneRest;
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
    @synchronized(self.connector){
        
        NSDictionary *resultsDictionary = JSONTodict(self.responseData);
        badLogin(resultsDictionary, self.ivc);
        if (resultsDictionary){
        NSLog(@"results dict in tabe view cell: %@", resultsDictionary);
    Invitation* i = [InviteTransitionConnectionHandler loadInvitation:resultsDictionary locationInput:self.ivc.myLocation];
    self.ivc.invitation = i;
    [self.ivc layoutView];
    for (NSMutableDictionary* rest in resultsDictionary[@"invitation"][@"restaurants"])
        [i.restaurants addObject:[[Restaurant alloc] init:rest[@"address"] nameInput:rest[@"name"] percentMatchInput:rest[@"percent_match"] priceInput:rest[@"price"] ratingImgInput:rest[@"rating_img"] snippetImgInput:rest[@"snippet_img"] votesInput:rest[@"votes"] typesInput:rest[@"types_list"] iVotedInput:[rest[@"user_voted"] boolValue] urlInput:rest[@"url"] myLocationInput:self.ivc.myLocation invitationInput:i.num]];
    NSLog(@"finished: %@", resultsDictionary);
    self.restaurant.votes = [resultsDictionary[@"restaurant"][@"votes"] integerValue];
    self.restaurant.iVoted = [resultsDictionary[@"restaurant"][@"user_voted"] boolValue];
    [self setWithRestaurant:self.restaurant rowInput:self.row ivcInput:self.ivc oneRestInput:self.oneRest];
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
    }}
- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSLog(@"appending");
    [self.responseData appendData:data];
    
}


-(void)setVotesText{
    if (self.restaurant.votes == 1)
        self.votes.text = [NSString stringWithFormat:@"%u Vote", self.restaurant.votes];
    else if (self.restaurant.votes == 0)
        self.votes.text = [NSString stringWithFormat:@""];
    else
        self.votes.text = [NSString stringWithFormat:@"%u Votes", self.restaurant.votes];
}

- (IBAction)votePressed:(id)sender {

    if (self.restaurant.iVoted){
        self.ivc.voteChanged = YES;
        [self.vote setBackgroundImage:[UIImage imageNamed:@"votebackground"] forState:UIControlStateNormal];
        [self.vote setTitle:@"" forState:UIControlStateNormal];
        self.restaurant.iVoted = NO;
        self.restaurant.votes -= 1;
        [self setVotesText];
        [User castUnvote:[self.restaurant serialize] source:self];
        
    }
    else{
        self.ivc.voteChanged = YES;
        [self.vote setBackgroundImage:[UIImage imageNamed:@"votedbackground"] forState:UIControlStateNormal];
        [self.vote setTitle:@"" forState:UIControlStateNormal];
        self.restaurant.iVoted = YES;
        self.restaurant.votes += 1;
        [self setVotesText];
        [User castVote:[self.restaurant serialize] source:self];
    }
}

-(void)setNothingOpen{
    self.name.text = @"No open restaurants";
    [self.ratingImg setHidden:YES];
    [self.price setHidden:YES];
    [self.percentMatch setHidden:YES];
    [self.snippetImg setHidden:YES];
    [self.yelpCredit setHidden:YES];
    [self.address setHidden:YES];
    [self.types setHidden:YES];
    [self.votes setHidden:YES];
}

-(void)setWithRestaurant:(Restaurant*)restaurantInput rowInput:(int)rowInput ivcInput:(InviteViewController*)ivcInput oneRestInput:(BOOL)oneRestInput{
    [self.ratingImg setHidden:NO];
    [self.price setHidden:NO];
    [self.percentMatch setHidden:NO];
    [self.snippetImg setHidden:NO];
    [self.yelpCredit setHidden:NO];
    [self.address setHidden:NO];
    [self.types setHidden:NO];
    [self.votes setHidden:NO];
    self.connector = [NSNumber numberWithInt:1];
    self.oneRest = oneRestInput;
    if (self.responseData)
        [self.responseData setLength:0];
    self.ivc = ivcInput;
    self.responseData = [[NSMutableData alloc] initWithLength:0];
    self.restaurant = restaurantInput;
    self.row = rowInput;
    self.selectionStyle = UITableViewCellSelectionStyleDefault;
    NSURL *imageURL;
    if (self.restaurant.snippetImg && (![self.restaurant.snippetImg isEqual:[NSNull null]])){
    imageURL = [NSURL URLWithString:self.restaurant.snippetImg];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // Update the UI
        
                self.snippetImg.image = [UIImage imageWithData:imageData];
        });
    });
    }

    imageURL = [NSURL URLWithString:self.restaurant.ratingImg];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // Update the UI
            self.ratingImg.image = [UIImage imageWithData:imageData];
        });
    });
    [self.yelpCredit setImage:GET_IMG(@"yelpCredit")];
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
    NSLog(@"table layout thinks distance is %f", self.restaurant.distance);
//    if (self.restaurant.distance != -1)
  //      self.price.text = [NSString stringWithFormat:@"%@, %.1f mi.", self.price.text, self.restaurant.distance];
    self.percentMatch.text = [NSString stringWithFormat:@"%u%% Match", self.restaurant.percentMatch];
    if (self.restaurant.iVoted){
        [self.vote setBackgroundImage:[UIImage imageNamed:@"votedbackground"] forState:UIControlStateNormal];
        [self.vote setTitle:@"" forState:UIControlStateNormal];
        self.restaurant.iVoted = YES;
    }
    else{
        [self.vote setBackgroundImage:[UIImage imageNamed:@"votebackground"] forState:UIControlStateNormal];
        [self.vote setTitle:@"VOTE" forState:UIControlStateNormal];
        self.restaurant.iVoted = NO;
    }

    if (self.ivc.invitation.scheduled && (!oneRest)){
       // [self.vote removeFromSuperview];
       // [self.name setFrame:CGRectMake(self.name.frame.origin.x, self.name.frame.origin.y, self.superview.frame.size.width - self.name.frame.origin.x, self.name.frame.size.height)];
    }
    if (self.oneRest){
        [self.vote removeFromSuperview];
        self.name.text = self.restaurant.name;
        [self.name setFrame:CGRectMake(self.name.frame.origin.x, self.frame.origin.y, 320 - self.name.frame.origin.x, self.name.frame.size.height)];
        [self setBackgroundColor:[UIColor whiteColor]];

    }
    else{
        [self setBackgroundColor:[UIColor clearColor]];
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
