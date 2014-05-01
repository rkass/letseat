//
//  WhatViewController.m
//  Let's Eat
//
//  Created by Ryan Kass on 2/25/14.
//  Copyright (c) 2014 Ryan Kass. All rights reserved.
//

#import "WhatViewController.h"
#import "Graphics.h"
#import "CreateMealNavigationController.h"

@interface WhatViewController ()
@property (strong, nonatomic) IBOutlet UITableView* wantTable;
@property (strong, nonatomic) NSMutableArray* typesItems;
@property (strong, nonatomic) NSMutableArray* savedTypes;
@property (strong, nonatomic) IBOutlet UIImageView *one;
@property (strong, nonatomic) UIImageView *two;
@property (strong, nonatomic) UIImageView *three;
@property (strong, nonatomic) UIImageView *four;
@property (strong, nonatomic) UIImageView *five;
@property (strong, nonatomic) UIImageView *six;
@property (strong, nonatomic) UIImageView *seven;
@property (strong, nonatomic) IBOutlet UISearchBar* search;
@property (strong, nonatomic) IBOutlet UITableView *typesTable;
@property (strong, nonatomic) UITableView *currTbl;
@property (strong, nonatomic) UITableView* currOtherTbl;
@property (strong, nonatomic) NSString* movingCellText;
@property (strong, nonatomic) UIImageView* movingCellImage;
@property (strong, nonatomic) NSMutableArray* source;
@property (strong, nonatomic) NSMutableArray* otherSource;
@property (strong, nonatomic) UIImage* draggable;
@property int movingCellIndex;//row of cell that's being dragged in the table
@property (strong, nonatomic) IBOutlet UIView *spacer2;
@property (strong, nonatomic) IBOutlet UIView *spacer1;
@property int movingCellOtherIndex;
@property int movingCellHeight;
@property int movingCellWidth;
@property float movingDiffx;
@property float movingDiffy;
@property CGRect inishPosish;
@property bool moved;
@end

@implementation WhatViewController
@synthesize wantTable, wantItems, typesItems, typesTable, movingCellOtherIndex, movingCellText, movingCellIndex, movingCellImage, currTbl, currOtherTbl, source, otherSource, draggable, movingDiffx, movingDiffy, moved, inishPosish, two, three;


- (void)viewDidLoad
{
    [super viewDidLoad];

    UIImage* bigDraggable = [UIImage imageNamed:@"Draggable"];
    self.draggable = [Graphics makeThumbnailOfSize:bigDraggable size:CGSizeMake(15, 15)];
    self.title = @"What";
    self.wantTable.delegate = self;
    self.wantTable.dataSource = self;
    self.search.delegate = self;
    self.typesTable.delegate = self;
    self.typesTable.dataSource = self;
    self.savedTypes = [[NSMutableArray alloc] init];
    [self.search setDelegate:self];
    self.inishPosish = self.one.frame;
    UIImage* twoImg = [UIImage imageNamed:@"YellowTwo"];
    //UIImage* threeImg = [UIImage imageNamed:@"Three)"];
    self.two = [[UIImageView alloc ] initWithImage:twoImg];
    self.spacer1.hidden = YES;
    self.spacer2.hidden = YES;
    CGRect converted = [self.one convertRect:self.one.frame toView:self.view];
    [self.two setFrame:CGRectMake(converted.origin.x, converted.origin.y + 55, self.inishPosish.size.width, self.inishPosish.size.height)];
    [self.view addSubview:self.two];
    UIImage* threeImg = [UIImage imageNamed:@"YellowThree"];
    self.three = [[UIImageView alloc ] initWithImage:threeImg];
    [self.three setFrame:CGRectMake(converted.origin.x, converted.origin.y + 110, self.inishPosish.size.width, self.inishPosish.size.height)];
    [self.view addSubview:self.three];
    
    UIImage* fourImg = [UIImage imageNamed:@"YellowFour"];
    self.four = [[UIImageView alloc ] initWithImage:fourImg];
    [self.four setFrame:CGRectMake(converted.origin.x, converted.origin.y + 165, self.inishPosish.size.width, self.inishPosish.size.height)];

    
    UIImage* fiveImg = [UIImage imageNamed:@"YellowFive"];
    self.five = [[UIImageView alloc ] initWithImage:fiveImg];
    [self.five setFrame:CGRectMake(converted.origin.x, converted.origin.y + 220, self.inishPosish.size.width, self.inishPosish.size.height)];

    
    UIImage* sixImg = [UIImage imageNamed:@"YellowSix"];
    self.six = [[UIImageView alloc ] initWithImage:sixImg];
    [self.six setFrame:CGRectMake(converted.origin.x, converted.origin.y + 275, self.inishPosish.size.width, self.inishPosish.size.height)];

    
    UIImage* sevenImg = [UIImage imageNamed:@"YellowSeven"];
    self.seven = [[UIImageView alloc ] initWithImage:sevenImg];
    [self.seven setFrame:CGRectMake(converted.origin.x, converted.origin.y + 330, self.inishPosish.size.width, self.inishPosish.size.height)];

    
    UILongPressGestureRecognizer *gesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(receivedLongPress:)];
    gesture.minimumPressDuration = .1;
    UILongPressGestureRecognizer *gesture2 = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(receivedLongPress:)];
    gesture2.minimumPressDuration = .1;
    [self.typesTable addGestureRecognizer:gesture];
    [self.wantTable addGestureRecognizer:gesture2];
    self.wantItems = [[NSMutableArray alloc] init];
    self.typesItems = [@[@"American",@"Cafe", @"Chinese",@"Dessert", @"Diner", @"Indian", @"Italian", @"Japanese", @"Korean", @"Mediterranean", @"Mexican", @"Seafood", @"Spanish", @"Steakhouse", @"Thai", @"Vegetarian", @"Vietnamese"] mutableCopy];
    self.movingCellIndex = -1;
    self.movingCellOtherIndex = -1;
    UIImage *backImg = [UIImage imageNamed:@"BackBrownCarrot"];
    //UIImage* homeImg = [Graphics makeThumbnailOfSize:bigImage size:CGSizeMake(37,22)];
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    back.bounds = CGRectMake( 0, 0, backImg.size.width, backImg.size.height );
    [back setImage:backImg forState:UIControlStateNormal];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:back];
    [back addTarget:self action:@selector(backPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = backItem;
    UIImage *bigImage = [UIImage imageNamed:@"Home"];
    UIImage* homeImg = [Graphics makeThumbnailOfSize:bigImage size:CGSizeMake(30,30)];
    UIButton *home = [UIButton buttonWithType:UIButtonTypeCustom];
    home.bounds = CGRectMake( 0, 0, homeImg.size.width, homeImg.size.height );
    [home setImage:homeImg forState:UIControlStateNormal];
    UIBarButtonItem *homeItem = [[UIBarButtonItem alloc] initWithCustomView:home];
    [home addTarget:self action:@selector(homePressed:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = homeItem;
    self.title = @"Rank Preferences";
    self.view.backgroundColor = [Graphics colorWithHexString:@"f5f0df"];
    UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Chalkboard"]];
    [tempImageView setFrame:self.wantTable.frame];
    self.wantTable.backgroundView = tempImageView;
   // [self.view bringSubviewToFront:self.one];
   // [self.view sendSubviewToBack:self.chalkboard];

}
-(void)viewWillAppear:(BOOL)animated{
    NSLog(@"what's gonna appear");
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}
-(void)homePressed:(UIBarButtonItem*)sender{
    [self.navigationController popToRootViewControllerAnimated:YES];
    self.navigationController.navigationBarHidden = YES;
}
-(void)backPressed:(UIBarButtonItem*)sender{
    [self.navigationController popViewControllerAnimated:YES];
    

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
    [self reloadTable:self.typesTable];//[self.typesTable reloadData];
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
    [self reloadTable:self.typesTable];//[self.typesTable reloadData];
}

-(void)swapTables:(UITableView*)tableView indexPath:(NSIndexPath*)indexPath
{
    NSMutableArray* lsource = self.wantItems;
    NSMutableArray* lotherSource = self.typesItems;
    UITableView* otherTableView = self.wantTable;
    if (tableView == otherTableView)
        otherTableView = self.typesTable;
    if (tableView == self.typesTable){
        lsource = self.typesItems;
        lotherSource = self.wantItems;
    }
    UITableViewCell* cell =[tableView cellForRowAtIndexPath:indexPath];
    NSString* txt = [[[[cell.textLabel.text componentsSeparatedByCharactersInSet:
                       [[NSCharacterSet letterCharacterSet] invertedSet]] componentsJoinedByString:@""] stringByReplacingOccurrencesOfString:@")" withString:@""] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    [lsource removeObjectAtIndex:indexPath.row];
    if (lotherSource == self.wantItems){
        [lotherSource addObject:txt];
        if ([lotherSource count] == 7){//
            NSString* removeit = lotherSource[5];
            int count = 0;
            for (NSString* food in lsource)
            {
                if ([removeit compare:food] ==  NSOrderedAscending){
                    [lsource insertObject:removeit atIndex:count];
                    break;
                }
                count += 1;
            }
            if (! [lsource containsObject:removeit])
                [lsource addObject:removeit];
            [lotherSource removeObjectAtIndex:5];

        }
    }
    else{
        int count = 0;
        for (NSString* food in lotherSource)
        {
            if ([txt compare:food] ==  NSOrderedAscending){
                [lotherSource insertObject:txt atIndex:count];
                break;
            }
            count += 1;
        }
        if (! [lotherSource containsObject:txt])
            [lotherSource addObject:txt];
    }

    [self reloadTable:self.wantTable];//[self.wantTable reloadData];
    [self reloadTable:self.typesTable];//[self.typesTable reloadData];
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
                [imgView setFrame:CGRectMake([rectVal CGRectValue].origin.x, [rectVal CGRectValue].origin.y, viewImage.size.width, viewImage.size.height)];
                imgView.alpha = .5;
                self.moved = NO;
                self.movingDiffx = point.x -[rectVal CGRectValue].origin.x;
                self.movingDiffy = point.y - [rectVal CGRectValue].origin.y;
                //[imgView setFrame:CGRectMake(point.x - viewImage.size.width / 2, point.y - viewImage.size.height / 2, viewImage.size.width, viewImage.size.height)];
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
                        self.moved = YES;
                        [self.source exchangeObjectAtIndex:count withObjectAtIndex:self.movingCellIndex];
                    }
                    self.movingCellIndex = count;
                    [self reloadTable:self.currTbl];//[self.currTbl reloadData];
                    [self.currTbl cellForRowAtIndexPath:[NSIndexPath indexPathForRow:count inSection:0]].hidden = YES;
                    inAny = YES;
                }
                count ++;
            }
            if (!inAny && self.movingCellIndex != -1){
                self.moved = YES;
                [self.source removeObjectAtIndex:self.movingCellIndex];
                [self reloadTable:self.currTbl];//[self.currTbl reloadData];
                self.movingCellIndex = -1;
            }
            if (self.movingCellOtherIndex != -1){
                [self.otherSource removeObjectAtIndex:self.movingCellOtherIndex];
                [self reloadTable:self.currOtherTbl];//[self.currOtherTbl reloadData];
                self.movingCellOtherIndex = -1;
            }
        }
        else{
            self.moved = YES;
            inAny = NO;
            count = 0;
            for (NSValue *rectVal in [self getRectForTable:self.currOtherTbl]){
                if (CGRectContainsPoint([rectVal CGRectValue], point)){
                    if (self.movingCellOtherIndex == -1){
                        [self.otherSource insertObject:self.movingCellText atIndex:count];

                    }
                    else if (self.movingCellOtherIndex != count){
                        self.moved = YES;
                        [self.otherSource exchangeObjectAtIndex:count withObjectAtIndex:self.movingCellOtherIndex];
                    }
                    self.movingCellOtherIndex = count;
                    [self reloadTable:self.currOtherTbl];//[self.currOtherTbl reloadData];
                    if ([self.currOtherTbl cellForRowAtIndexPath:[NSIndexPath indexPathForRow:count inSection:0]]){
                        [self.currOtherTbl cellForRowAtIndexPath:[NSIndexPath indexPathForRow:count inSection:0]].hidden = YES;
                    }
                    inAny = YES;
                }
                count++;
            }
            if (!inAny && movingCellOtherIndex != -1)
            {
                self.moved = YES;
                [self.otherSource removeObjectAtIndex:self.movingCellOtherIndex];
                [self reloadTable:self.currOtherTbl];//[self.currOtherTbl reloadData];
                self.movingCellOtherIndex = -1;
            }
            if (self.movingCellIndex != -1){
                [self.source removeObjectAtIndex:self.movingCellIndex];
                [self reloadTable:self.currTbl];//[self.currTbl reloadData];
                self.movingCellIndex = -1;
            }
        }
        [self.movingCellImage setFrame:CGRectMake(point.x - self.movingDiffx, point.y - self.movingDiffy, self.movingCellWidth, self.movingCellHeight)];
    }
    else if (gestureRecognizer.state == 3 && self.movingCellText){
        if (!self.moved){
            [self swapTables:self.currTbl indexPath:[NSIndexPath indexPathForRow:self.movingCellIndex inSection:0]];
            [self.movingCellImage removeFromSuperview];
            return;
        }
        if (CGRectContainsPoint([self.currTbl frame], point))
        {
            count = 0;
            inAny = NO;
            for (NSValue *rectVal in [self getRectForTable:self.currTbl]){
                if (CGRectContainsPoint([rectVal CGRectValue], point)){
                    [self.currTbl cellForRowAtIndexPath:[NSIndexPath indexPathForRow:count inSection:0]].hidden = NO;
                    [self reloadTable:self.currTbl];//[self.currTbl reloadData];
                    inAny = YES;
                }
                count++;
            }
            if (!inAny)
            {
                [self.source addObject:self.movingCellText];
                [self reloadTable:self.currTbl];//[self.currTbl reloadData];
            }
        }
        else
        {
            count = 0;
            inAny = NO;
            for (NSValue *rectVal in [self getRectForTable:self.currOtherTbl]){
                if (CGRectContainsPoint([rectVal CGRectValue], point)){
                    [self.currOtherTbl cellForRowAtIndexPath:[NSIndexPath indexPathForRow:count inSection:0]].hidden = NO;
                    [self reloadTable:self.currOtherTbl];//[self.currOtherTbl reloadData];
                    inAny = YES;
                }
                count++;
            }
            if (!inAny)
            {
                [self.otherSource addObject:self.movingCellText];
                [self reloadTable:self.currOtherTbl];//[self.currOtherTbl reloadData];
            }
        }
        [self.movingCellImage removeFromSuperview];
        self.movingCellText = nil;
        self.movingCellOtherIndex = -1;
        self.movingCellIndex = -1;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self swapTables:tableView indexPath:indexPath];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray *arr;
    if (tableView == self.typesTable)
        arr = self.typesItems;
    else
        arr = self.wantItems;
    NSLog(@"Loading cell for table %@ with array %@", tableView, arr);
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
    }
    if (tableView == self.wantTable){
        cell.textLabel.text = [NSString stringWithFormat:@"  %@",[self.wantItems objectAtIndex:indexPath.row]];
        cell.textLabel.font = [UIFont fontWithName:@"Chalkduster" size:11.5 ];
        cell.textLabel.textColor = [Graphics colorWithHexString:@"ddd10a"];
    }
    else{
        cell.textLabel.text = [self.typesItems objectAtIndex:indexPath.row];
         cell.textLabel.font = [UIFont systemFontOfSize:14.0];
    }
    cell.backgroundColor = [Graphics colorWithHexString:@"f5f0df"];
    if (tableView == self.wantTable)
        cell.backgroundColor = [UIColor clearColor];
    UIImageView* accDraggable = [[UIImageView alloc] initWithImage:self.draggable];
    if ((!(indexPath.row >= [self.wantItems count])) || (tableView == self.typesTable)){
        cell.accessoryView = accDraggable;
    }
    else
        cell.accessoryView = nil;
    //[cell.textLabel sizeToFit];
    [self.view bringSubviewToFront:cell];
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView == self.wantTable)
       return MIN(6,[self.wantItems count]);//
    return [self.typesItems count];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(void)reloadTable:(UITableView* )tableView{
    [tableView reloadData];
    if ([self.wantItems count] == 7){//
        [self.typesItems addObject:self.wantItems[6]] ;//
        [self.wantItems removeLastObject];
    }
    self.one.frame = self.inishPosish;
    if ([self.wantItems count] > 3)
        [self.view addSubview:self.four];
    else if ([self.view.subviews containsObject:self.four])
        [self.four removeFromSuperview];
    if ([self.wantItems count] > 4)
        [self.view addSubview:self.five];
    else if ([self.view.subviews containsObject:self.five])
        [self.five removeFromSuperview];
    if ([self.wantItems count] > 5)
        [self.view addSubview:self.six];
    else if ([self.view.subviews containsObject:self.six])
        [self.six removeFromSuperview];

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
        [NSString stringWithFormat:@"%@",string];
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
