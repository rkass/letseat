//
//  WhatViewController.m
//  Let's Eat
//
//  Created by Ryan Kass on 2/25/14.
//  Copyright (c) 2014 Ryan Kass. All rights reserved.
//

#import "WhatViewController.h"

@interface WhatViewController ()

@property (strong, nonatomic) IBOutlet UIButton* italian;
@property (strong, nonatomic) IBOutlet UITableView* wantTable;
@property (strong, nonatomic) NSMutableArray* wantItems;
@property (strong, nonatomic) NSMutableDictionary* buttons;//Image name -> buttons
@property (strong, nonatomic) NSString* movingCellText;
@property (strong, nonatomic) UIImage* cellImage;
@property int movingCellIndex;//row of cell that's being dragged in the table
@property int movingButtonIndex;//row of button that's been dragged into the table
@property int movingCellHeight;
@property int movingCellWidth;

@end

@implementation WhatViewController
@synthesize italian, wantTable, wantItems, movingButtonIndex, movingCellText, movingCellIndex, cellImage, buttons;


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.wantTable.delegate = self;
    self.wantTable.dataSource = self;
    [italian addTarget:self action:@selector(buttonMoved:withEvent:) forControlEvents:UIControlEventTouchDragInside];
    [italian addTarget:self action:@selector(buttonReleased:withEvent:) forControlEvents:UIControlEventTouchUpInside];
    UILongPressGestureRecognizer *gesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(receivedLongPress:)];
    gesture.minimumPressDuration = .001;
    [self.wantTable addGestureRecognizer:gesture];
    [self.italian setTitle:@"Italian.png" forState:UIControlStateNormal];
    self.italian.titleLabel.hidden = YES;
    self.wantItems = [[NSMutableArray alloc] init];
    [self.wantItems addObject:@"Chinese.png"];
    [self.wantItems addObject:@"Indian.png"];
    self.movingButtonIndex = -1;
    self.buttons = [[NSMutableDictionary alloc] init];

}

- (void)receivedLongPress:(UIGestureRecognizer *)gestureRecognizer {
    CGPoint point = [gestureRecognizer locationInView:Nil];
    NSArray* wantRects = [self getRectForTable];
    int count;
    if (gestureRecognizer.state == 1){
        self.movingCellText = nil;
        count = 0;
        for (NSValue *rectVal in wantRects){
            if (CGRectContainsPoint([rectVal CGRectValue], point)){
                UITableViewCell *cell = [self.wantTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:count inSection:0]];
                UIButton* button = [[UIButton alloc] init];
                [button setImage:cell.imageView.image forState:UIControlStateNormal];
                [button setFrame:CGRectMake(point.x - 2 * cell.imageView.image.size.width / 3, point.y - 2 * cell.imageView.image.size.height / 3, cell.imageView.image.size.width, cell.imageView.image.size.height )];
                self.movingCellText = [self.wantItems objectAtIndex:count];
                [self.buttons setObject:button forKey:self.movingCellText];
                [self.view addSubview:button];
                self.movingCellIndex = count;
                cell.hidden = YES;
                self.movingCellWidth = cell.imageView.image.size.width;
                self.movingCellHeight = cell.imageView.image.size.height;
            }
            count++;
        }
    }
    else if (gestureRecognizer.state == 2 && self.movingCellText){
        UIButton *button = [self.buttons objectForKey:self.movingCellText];
        if (CGRectContainsPoint([self.wantTable frame], point))
        {
            count = 0;
            for (NSValue *rectVal in wantRects){
                if (CGRectContainsPoint([rectVal CGRectValue], point) && count != self.movingCellIndex){
                    if (self.movingCellIndex == -1)
                        [self.wantItems insertObject:self.movingCellText atIndex:count];
                    else
                        [self.wantItems exchangeObjectAtIndex:count withObjectAtIndex:self.movingCellIndex];
                    self.movingCellIndex = count;
                    [self.wantTable reloadData];
                    [self.wantTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:count inSection:0]].hidden = YES;
                }
                count ++;
            }
        }
        else{
            if (self.movingCellIndex != -1)
            {
                [self.wantItems removeObjectAtIndex:self.movingCellIndex];
                self.movingCellIndex = -1;
                [self.wantTable reloadData];
            }
        }
        [button setFrame:CGRectMake(point.x - 2 * self.movingCellWidth / 3, point.y - 2 * self.movingCellHeight / 3, self.movingCellWidth, self.movingCellHeight)];
    }
    else if (gestureRecognizer.state == 3 && self.movingCellText){
        UIButton *button = [self.buttons objectForKey:self.movingCellText];
        if (CGRectContainsPoint([self.wantTable frame], point))
        {
            count = 0;
            bool inAny = NO;
            for (NSValue *rectVal in wantRects){
                if (CGRectContainsPoint([rectVal CGRectValue], point)){
                    [self.wantTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:count inSection:0]].hidden = NO;
                    [self.wantTable reloadData];
                    inAny = YES;
                }
                count++;
            }
            if (!inAny)
            {
                [self.wantItems addObject:self.movingCellText];
                [self.wantTable reloadData];
            }
            [button removeFromSuperview];
        }
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
    }
    cell.imageView.image = [UIImage imageNamed:[self.wantItems objectAtIndex:indexPath.row]];
    
    
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.wantItems count];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (IBAction) buttonReleased:(id) sender withEvent:(UIEvent *) event
{
    UIButton *button = (UIButton *)sender;
    if (self.movingButtonIndex != -1)
         [button removeFromSuperview];
}

- (IBAction) buttonMoved:(id) sender withEvent:(UIEvent *) event
{
    CGPoint point = [[[event allTouches] anyObject] locationInView:self.view];
    UIButton *button = (UIButton *)sender;
    UIControl *control = sender;
    control.center = point;
    NSArray* wantRects = [self getRectForTable];
    CGRect wantRect = [self.wantTable frame];
    int count;
    BOOL inAny;
    if (CGRectContainsPoint(wantRect, point))
    {
        count = 0;
        inAny = NO;
        for (NSValue *rectVal in wantRects){
            if (CGRectContainsPoint([rectVal CGRectValue], point)){
                inAny = YES;
                if (self.movingButtonIndex == -1){
                    [self.wantItems insertObject:button.currentTitle atIndex:count];
                    [self.wantTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:count inSection:0]].hidden = YES;
                    
                }
                else if (self.movingButtonIndex  != count){
                    [self.wantItems exchangeObjectAtIndex:count withObjectAtIndex:self.movingButtonIndex];
                }
                self.movingButtonIndex = count;
            }
            count++;
        }
        if (!inAny)
        {
            self.movingButtonIndex = -1;
        }
    }
    else if (self.movingButtonIndex != -1)
    {
        [self.wantItems removeObjectAtIndex:self.movingButtonIndex];
        self.movingButtonIndex = -1;
    }
    [self.wantTable reloadData];
}

- (NSArray*)getRectForTable
{
    NSMutableArray* source = self.wantItems;
    UITableView* tableView = self.wantTable;
    NSMutableArray* ret = [[NSMutableArray alloc] init];
    int count = 0;
    for (NSString* string in source)
    {
        [ret addObject:[NSValue valueWithCGRect:[tableView convertRect:[tableView rectForRowAtIndexPath:[NSIndexPath indexPathForRow:count inSection:0]] toView:[tableView superview]]]];
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
