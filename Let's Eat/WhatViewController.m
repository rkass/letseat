//
//  WhatViewController.m
//  Let's Eat
//
//  Created by Ryan Kass on 2/25/14.
//  Copyright (c) 2014 Ryan Kass. All rights reserved.
//

#import "WhatViewController.h"

@interface WhatViewController ()
@property (strong, nonatomic) IBOutlet UITableView* wantTable;
@property (strong, nonatomic) NSMutableArray* wantItems;
@property (strong, nonatomic) NSMutableArray* typesItems;
@property (strong, nonatomic) NSMutableArray* savedTypes;
@property (strong, nonatomic) IBOutlet UISearchBar* search;
@property (strong, nonatomic) IBOutlet UITableView *typesTable;
@property (strong, nonatomic) UITableView *currTbl;
@property (strong, nonatomic) UITableView* currOtherTbl;
@property (strong, nonatomic) NSString* movingCellText;
@property (strong, nonatomic) UIImageView* movingCellImage;
@property (strong, nonatomic) NSMutableArray* source;
@property (strong, nonatomic) NSMutableArray* otherSource;
@property int movingCellIndex;//row of cell that's being dragged in the table
@property int movingCellOtherIndex;
@property int movingCellHeight;
@property int movingCellWidth;

@end

@implementation WhatViewController
@synthesize wantTable, wantItems, typesItems, typesTable, movingCellOtherIndex, movingCellText, movingCellIndex, movingCellImage, currTbl, currOtherTbl, source, otherSource;


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"What";
    self.wantTable.delegate = self;
    self.wantTable.dataSource = self;
    self.search.delegate = self;
    self.typesTable.delegate = self;
    self.typesTable.dataSource = self;
    self.savedTypes = [[NSMutableArray alloc] init];
    [self.search setDelegate:self];
    UILongPressGestureRecognizer *gesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(receivedLongPress:)];
    gesture.minimumPressDuration = .25;
    UILongPressGestureRecognizer *gesture2 = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(receivedLongPress:)];
    gesture2.minimumPressDuration = .25;
    [self.typesTable addGestureRecognizer:gesture];
    [self.wantTable addGestureRecognizer:gesture2];
    self.wantTable.layer.borderWidth = 2.0;
    self.wantTable.layer.borderColor = [UIColor redColor].CGColor;
    self.wantItems = [[NSMutableArray alloc] init];
    self.typesItems = [@[@"American", @"Chinese", @"Diner", @"Indian", @"Italian", @"Japanese", @"Korean", @"Mediterranean", @"Mexican", @"Seafood", @"Spanish", @"Steakhouse", @"Thai", @"Vietnamese", @"Vegetarian"] mutableCopy];
    self.movingCellIndex = -1;
    self.movingCellOtherIndex = -1;

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 53;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    self.search.text = @"";
    [self.typesItems removeAllObjects];
    for (NSString* type in self.savedTypes)
    {
        if (![self.wantItems containsObject:type])
            [self.typesItems addObject:type];
    }
    [self.typesTable reloadData];
    self.search.showsCancelButton = NO;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    self.search.showsCancelButton = NO;
}
- (void)searchBarTextDidBeginEditing:(UISearchBar*)searchBar
{
    self.savedTypes = [self.typesItems mutableCopy];
    self.search.showsCancelButton = YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    
    [self.typesItems removeAllObjects];
    if ([searchText isEqualToString:@""])
        self.typesItems = [self.savedTypes mutableCopy];
    else
    {
        
        NSArray* splitSearch = [searchText componentsSeparatedByString:@" "];
        for(NSString* type in self.savedTypes)
        {
            
            bool allin = YES;
            
            for (NSString* name in splitSearch){
                
                if ((!([type rangeOfString:name options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch)].length > 0)) && (![name isEqualToString: @""])){
                    allin = NO;
                    break;
                }
            }
            if (allin)
                [self.typesItems addObject:type];
        }
    }
    [self.typesTable reloadData];
}

- (void)receivedLongPress:(UIGestureRecognizer *)gestureRecognizer {
    CGPoint point = [gestureRecognizer locationInView:Nil];
    int count;
    BOOL inAny;
    if (gestureRecognizer.state == 1){
        if (CGRectContainsPoint([self.wantTable frame], point)){
            [self.search resignFirstResponder];
            self.search.showsCancelButton = NO;
            self.currTbl = self.wantTable;
            self.currOtherTbl = self.typesTable;
            self.source = self.wantItems;
            self.otherSource = self.typesItems;
        }
        else{
            self.currTbl = self.typesTable;
            self.currOtherTbl = self.wantTable;
            self.source = self.typesItems;
            self.otherSource = self.wantItems;
        }
        count = 0;
        for (NSValue *rectVal in [self getRectForTable:self.currTbl]){
            if (CGRectContainsPoint([rectVal CGRectValue], point)){
                UITableViewCell *cell = [self.currTbl cellForRowAtIndexPath:[NSIndexPath indexPathForRow:count inSection:0]];
                [cell setHighlighted:YES];
                if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)])
                    UIGraphicsBeginImageContextWithOptions(cell.frame.size, NO, [UIScreen mainScreen].scale); //retina display
                else
                    UIGraphicsBeginImageContext(cell.frame.size);
                [cell.layer renderInContext:UIGraphicsGetCurrentContext()];
                UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                UIImageView* imgView = [[UIImageView alloc] initWithImage:viewImage];
                [imgView setFrame:CGRectMake(point.x - viewImage.size.width / 2, point.y - viewImage.size.height / 2, viewImage.size.width, viewImage.size.height)];
                self.movingCellText = [self.source objectAtIndex:count];
                self.movingCellImage = imgView;
                [self.view addSubview:imgView];
                self.movingCellIndex = count;
                cell.hidden = YES;
                self.movingCellWidth = viewImage.size.width;
                self.movingCellHeight = viewImage.size.height;
            }
            count++;
        }
    }
    else if (gestureRecognizer.state == 2 && self.movingCellText){
        if (CGRectContainsPoint([self.currTbl frame], point)){
            inAny = NO;
            count = 0;
            for (NSValue *rectVal in [self getRectForTable:self.currTbl]){
                if (CGRectContainsPoint([rectVal CGRectValue], point)){
                    if (self.movingCellIndex == -1){
                        [self.source insertObject:self.movingCellText atIndex:count];
                    }
                    else if (self.movingCellIndex != count){
                        [self.source exchangeObjectAtIndex:count withObjectAtIndex:self.movingCellIndex];
                    }
                    self.movingCellIndex = count;
                    [self.currTbl reloadData];
                    [self.currTbl cellForRowAtIndexPath:[NSIndexPath indexPathForRow:count inSection:0]].hidden = YES;
                    inAny = YES;
                }
                count ++;
            }
            if (!inAny && self.movingCellIndex != -1){
                [self.source removeObjectAtIndex:self.movingCellIndex];
                [self.currTbl reloadData];
                self.movingCellIndex = -1;
            }
            if (self.movingCellOtherIndex != -1){
                [self.otherSource removeObjectAtIndex:self.movingCellOtherIndex];
                [self.currOtherTbl reloadData];
                self.movingCellOtherIndex = -1;
            }
        }
        else{
            inAny = NO;
            count = 0;
            for (NSValue *rectVal in [self getRectForTable:self.currOtherTbl]){
                if (CGRectContainsPoint([rectVal CGRectValue], point)){
                    if (self.movingCellOtherIndex == -1){
                        [self.otherSource insertObject:self.movingCellText atIndex:count];
                    }
                    else if (self.movingCellOtherIndex != count){
                        [self.otherSource exchangeObjectAtIndex:count withObjectAtIndex:self.movingCellOtherIndex];
                    }
                    self.movingCellOtherIndex = count;
                    [self.currOtherTbl reloadData];
                    [self.currOtherTbl cellForRowAtIndexPath:[NSIndexPath indexPathForRow:count inSection:0]].hidden = YES;
                    inAny = YES;
                }
                count++;
            }
            if (!inAny && movingCellOtherIndex != -1)
            {
                [self.otherSource removeObjectAtIndex:self.movingCellOtherIndex];
                [self.currOtherTbl reloadData];
                self.movingCellOtherIndex = -1;
            }
            if (self.movingCellIndex != -1){
                [self.source removeObjectAtIndex:self.movingCellIndex];
                [self.currTbl reloadData];
                self.movingCellIndex = -1;
            }
        }
        [self.movingCellImage setFrame:CGRectMake(point.x - self.movingCellWidth / 2, point.y - self.movingCellHeight / 2, self.movingCellWidth, self.movingCellHeight)];
    }
    else if (gestureRecognizer.state == 3 && self.movingCellText){
        if (CGRectContainsPoint([self.currTbl frame], point))
        {
            count = 0;
            inAny = NO;
            for (NSValue *rectVal in [self getRectForTable:self.currTbl]){
                if (CGRectContainsPoint([rectVal CGRectValue], point)){
                    [self.currTbl cellForRowAtIndexPath:[NSIndexPath indexPathForRow:count inSection:0]].hidden = NO;
                    [self.currTbl reloadData];
                    inAny = YES;
                }
                count++;
            }
            if (!inAny)
            {
                [self.source addObject:self.movingCellText];
                [self.currTbl reloadData];
            }
        }
        else
        {
            count = 0;
            inAny = NO;
            for (NSValue *rectVal in [self getRectForTable:self.currOtherTbl]){
                if (CGRectContainsPoint([rectVal CGRectValue], point)){
                    [self.currOtherTbl cellForRowAtIndexPath:[NSIndexPath indexPathForRow:count inSection:0]].hidden = NO;
                    [self.currOtherTbl reloadData];
                    inAny = YES;
                }
                count++;
            }
            if (!inAny)
            {
                [self.otherSource addObject:self.movingCellText];
                [self.currOtherTbl reloadData];
            }
        }
        [self.movingCellImage removeFromSuperview];
        self.movingCellText = nil;
        self.movingCellOtherIndex = -1;
        self.movingCellIndex = -1;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
    }
    if (tableView == self.wantTable)
        cell.textLabel.text = [self.wantItems objectAtIndex:indexPath.row];
    else
        cell.textLabel.text = [self.typesItems objectAtIndex:indexPath.row];
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.wantTable)
        return [self.wantItems count];
    return [self.typesItems count];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSArray*)getRectForTable:(UITableView*)tbl
{
    NSMutableArray *s;
    if (tbl == self.wantTable)
        s = self.wantItems;
    else
        s = self.typesItems;
    NSMutableArray* ret = [[NSMutableArray alloc] init];
    int count = 0;
    for (NSString* string in s)
    {
        [ret addObject:[NSValue valueWithCGRect:[tbl convertRect:[tbl rectForRowAtIndexPath:[NSIndexPath indexPathForRow:count inSection:0]] toView:[tbl superview]]]];
        count++;
    }
    return ret;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
