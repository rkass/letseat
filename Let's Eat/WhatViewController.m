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
@property (strong, nonatomic) NSMutableDictionary* buttonIndices;
@property int inTableAt;

@end

@implementation WhatViewController
@synthesize italian, wantTable, wantItems, inTableAt, buttonIndices;


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.wantTable.delegate = self;
    self.wantTable.dataSource = self;
    self.inTableAt = -1;
    [italian addTarget:self action:@selector(buttonMoved:withEvent:) forControlEvents:UIControlEventTouchDragInside];
    [italian addTarget:self action:@selector(buttonReleased:withEvent:) forControlEvents:UIControlEventTouchUpInside];
    UILongPressGestureRecognizer *gesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(receivedLongPress:)];
    [self.wantTable addGestureRecognizer:gesture];
    self.wantItems = [[NSMutableArray alloc] init];
    [self.wantItems addObject:@"Chinese"];
    [self.wantItems addObject:@"Indian"];
    self.buttonIndices = [[NSMutableDictionary alloc] init];
    [self.buttonIndices setObject:[NSNumber numberWithInt:-1] forKey:self.italian.currentTitle];
    
}

- (void)receivedLongPress:(UIGestureRecognizer *)gestureRecognizer {
    NSLog(@"here");
    CGPoint point = [gestureRecognizer locationInView:Nil];
    NSArray* wantRects = [self getRectForTable];
    int count = 0;
    BOOL inAny = NO;
    for (NSValue *rectVal in wantRects){
        if (CGRectContainsPoint([rectVal CGRectValue], point)){
           // [self.wantItems insertObject:button.currentTitle atIndex:count];
            NSLog(@"xxxxcontained in want table at row %d", count);
            inAny = YES;
        }
        count++;
    }
    if (!inAny)
    {
        NSLog(@"xxxat the end of want table");
    //    [self.wantItems addObject:button.currentTitle];
    }
    
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
    }

    cell.textLabel.text = [self.wantItems objectAtIndex:indexPath.row];
    
    
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
    if ([self.buttonIndices[button.currentTitle] intValue] != -1){
        [self.buttonIndices removeObjectForKey:button.currentTitle];
         [button removeFromSuperview];
    }
    
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
                if ([self.buttonIndices[button.currentTitle] intValue] == -1){
                    [self.wantItems insertObject:button.currentTitle atIndex:count];
                }
                else if (self.inTableAt != count){
                    [self.wantItems exchangeObjectAtIndex:count withObjectAtIndex:[self.buttonIndices[button.currentTitle] intValue]];
                }
                [self.buttonIndices setObject:[NSNumber numberWithInt:count] forKey:self.italian.currentTitle];
                inAny = YES;
            }
            count++;
        }
        if (!inAny)
        {
            if ([self.buttonIndices[button.currentTitle] intValue] == -1){
                [self.wantItems addObject:button.currentTitle];
                [self.buttonIndices setObject:[NSNumber numberWithInt:([self.wantItems count] - 1)] forKey:self.italian.currentTitle];
            }
            
        }
        [self.wantTable reloadData];
    }
    else if ([self.buttonIndices[button.currentTitle] intValue] != -1)
    {
        [self.wantItems removeObjectAtIndex:[self.buttonIndices[button.currentTitle] intValue]];
        [self.buttonIndices setObject:[NSNumber numberWithInt:-1] forKey:button.currentTitle];
        [self.wantTable reloadData];
    }
    
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
