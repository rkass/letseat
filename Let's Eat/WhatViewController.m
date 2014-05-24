//
//  WhatViewController.m
//  Let's Eat
//
//  Created by Ryan Kass on 2/25/14.
//  Copyright (c) 2014 Ryan Kass. All rights reserved.
//

#import "WhatViewController.h"
#import "Graphics.h"
#import "ProgressBarDelegate.h"
#import "CreateMealNavigationController.h"
#import "FoodTypeTableViewCell.h"
#import "CheckAllStarsTableViewCell.h"

@interface WhatViewController ()
@property (strong, nonatomic) IBOutlet UIButton *next;
@property (strong, nonatomic) IBOutlet UITableView* wantTable;
@property (strong, nonatomic) IBOutlet UITableView *starsTableView;
@property (strong, nonatomic) NSMutableArray* typesItems;
@property (strong, nonatomic) NSMutableArray* savedTypes;
@property (strong, nonatomic) IBOutlet UITableView *foodTypeTable;
@property int checkAllState;
@property (strong, nonatomic) IBOutlet UIImageView *one;
@property (strong, nonatomic) UIImageView *two;
@property (strong, nonatomic) UIImageView *three;
@property (strong, nonatomic) UIImageView *four;
@property (strong, nonatomic) UIImageView *five;
@property (strong, nonatomic) UIImageView *six;
@property (strong, nonatomic) UIImageView *seven;
@property (strong, nonatomic) IBOutlet UISearchBar* search;
@property bool searching;
@property (strong, nonatomic) IBOutlet UITableView *typesTable;
@property (strong, nonatomic) IBOutlet UITableView *progressTable;
@property (strong, nonatomic) UITableView *currTbl;
@property (strong, nonatomic) UITableView* currOtherTbl;
@property (strong, nonatomic) NSString* movingCellText;
@property (strong, nonatomic) UIImageView* movingCellImage;
@property (strong, nonatomic) NSMutableArray* source;
@property (strong, nonatomic) NSMutableArray* otherSource;
@property (strong, nonatomic) UIImage* draggable;
@property (strong, nonatomic) NSMutableArray* foodTypesCopy;
@property int movingCellIndex;//row of cell that's being dragged in the table
@property (strong, nonatomic) IBOutlet UIView *spacer2;
@property (strong, nonatomic) IBOutlet UIView *spacer1;
@property int movingCellOtherIndex;
@property int movingCellHeight;
@property int movingCellWidth;
@property float movingDiffx;
@property float movingDiffy;

@property NSMutableArray* expandedState;
@property CGRect inishPosish;
@property (strong, nonatomic) ProgressBarDelegate* progressBarDelegate;
@property bool moved;
@property (strong, nonatomic) NSMutableArray* allFoodTypes;

@end

@implementation WhatViewController
@synthesize wantTable, wantItems, typesItems, typesTable, movingCellOtherIndex, movingCellText, movingCellIndex, movingCellImage, currTbl, currOtherTbl, source, otherSource, draggable, movingDiffx, movingDiffy, moved, inishPosish, two, three;
-(void)setRating:(FoodTypeTableViewCell*)cell{
    NSString* str = cell.foodTypeLabel.text;
    if (cell.category){
        str = [NSString stringWithFormat:@"sub%@", str ];
    }
    self.ratingsDict[str] = [NSNumber numberWithInt:cell.stars];
}
-(bool)categoryRatingsAllTheSame:(NSString*)categoryInput{
    int rating = -1;
    for (NSMutableDictionary* dict in self.foodTypes){
        if ([dict[@"category"] boolValue] && [dict[@"label"] isEqualToString:categoryInput]){
            int newRating;
            for (NSString* subcat in dict[@"subcategories"]){
                newRating = [[self rating:dict[@"label"] childName:subcat] intValue];
                if ((rating != -1) && (rating != newRating)){
                    return NO;
                }
                rating = newRating;
            }
           
            break;
        }
    }
    return YES;
  
}

-(bool)ratingsAllTheSame{
    int rating = -1;
    for (NSMutableDictionary* dict in self.foodTypes){
        if ([dict[@"category"] boolValue]){
            int newRating = [[self rating:nil childName:dict[@"label"]] intValue];
            if ((rating != -1) && (rating != newRating)){
                return NO;
            }
            rating = newRating;
            for (NSString* subcat in dict[@"subcategories"])
                newRating = [[self rating:dict[@"label"] childName:subcat] intValue];
            if ((rating != -1) && (rating != newRating)){
                return NO;
            }
            rating = newRating;
        }
    }
    return YES;
}

//adjust stars, reload table if necessary
-(void)setState{
    int oldState = self.checkAllState;
    if ([self ratingsAllTheSame]){
        NSLog(@"ratings all the same");
        if ([self.ratingsDict[@"American"] intValue] == 0){
            self.checkAllState = 1;
        }
        else if ([self.ratingsDict[@"American"] intValue] == 1){
            self.checkAllState = 2;
        }
        else if ([self.ratingsDict[@"American"] intValue] == 2){
            self.checkAllState = 3;
        }
    }
    else{
        NSLog(@"ratings not all the same");
        self.checkAllState = 0;
    }
    if (oldState != self.checkAllState){
        CheckAllStarsTableViewCell* cell = (CheckAllStarsTableViewCell*)[self.starsTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        [cell setWithState:self.checkAllState vc:self];
 
    }
}
-(void)statePressed:(int)s{
    NSMutableArray* editIndices = [[NSMutableArray alloc] init];
    int cnt = 0;
    if (self.checkAllState != s){
        for (NSMutableDictionary* dict in self.foodTypes){
            if ([dict[@"category"] boolValue]){
                self.ratingsDict[dict[@"label"]] = [NSNumber numberWithInt:s - 1];
                if ([dict[@"stars"] intValue] != [self.ratingsDict[dict[@"label"]] intValue]){
                    [ editIndices addObject:[NSIndexPath indexPathForRow:cnt inSection:0]];
                    dict[@"stars"] = [NSNumber numberWithInt:s - 1];
                }
                for (NSString* subcat in dict[@"subcategories"]){
                    self.ratingsDict[[NSString stringWithFormat:@"sub%@", subcat]] = [NSNumber numberWithInt:s - 1];
                }
            }
            else{
                if ([dict[@"stars"] intValue] != [self.ratingsDict[[NSString stringWithFormat:@"sub%@",dict[@"label"]] ] intValue]){
                    self.ratingsDict[[NSString stringWithFormat:@"sub%@",dict[@"label"]]] = [NSNumber numberWithInt:s -1];
                    [ editIndices addObject:[NSIndexPath indexPathForRow:cnt inSection:0]];
                }
            }
            cnt += 1;
            NSMutableArray* arr = [[NSMutableArray alloc] init];
            for (NSString* su in self.ratingsDict){
                [arr addObject:su];
            }
            for (NSString* su in arr){
                self.ratingsDict[su] = [NSNumber numberWithInt:s - 1];
            }
        }
    }
     [self setState];
    [self saveRatings];
    [self updateFoodTypesTable:nil editIndices:editIndices removeIndices:nil];
   
    
}
-(void)ratingPressed:(FoodTypeTableViewCell *)cell{
    NSLog(@"rating pressed cell: %@", cell);
    NSMutableArray* editIndices = [[NSMutableArray alloc] init];
   //  NSMutableArray* addIndices = [[NSMutableArray alloc] init];
     //NSMutableArray* deleteIndices = [[NSMutableArray alloc] init];
    cell.stars = (1 + cell.stars) % 3;
    if (cell.category){
        //set all same within category
        NSLog(@"cell category");
        int cnt = 0;
        for (NSMutableDictionary* dict in self.foodTypes){
            if ([dict[@"label"] isEqualToString:cell.foodTypeLabel.text] && [dict[@"category"] boolValue]){
                NSLog(@"category, %@", dict[@"label"]);
                [editIndices addObject:[NSIndexPath indexPathForRow:cnt inSection:0]];
                self.ratingsDict[dict[@"label"]] = [NSNumber numberWithInt:cell.stars];
                for (NSString* subcat in dict[@"subcategories"]){
                    cnt += 1;
                    self.ratingsDict[[NSString stringWithFormat:@"sub%@", subcat] ] = [NSNumber numberWithInt:cell.stars];
                    if (cell.expanded)
                        [editIndices addObject:[NSIndexPath indexPathForRow:cnt inSection:0]];
                }
                break;
            }
            
            cnt += 1;
        }
       
    }
    else{
        NSMutableArray* indices = [self getSelfAndCategory:cell.foodTypeLabel.text];
        int catIndex = [indices[1] intValue];
        int selfIndex = [indices[0] intValue];
        [editIndices addObject:[NSIndexPath indexPathForRow:selfIndex inSection:0]];
        self.ratingsDict[[NSString stringWithFormat:@"sub%@",cell.foodTypeLabel.text]] = [NSNumber numberWithInt:cell.stars];
        NSString* category = self.foodTypes[catIndex][@"label"];
        int oldCatRating = [self.ratingsDict[category] intValue];
        if ([self categoryRatingsAllTheSame:category]){
            NSLog(@"all in cat the same");
            self.ratingsDict[category] = [NSNumber numberWithInt:cell.stars];
        
        }
        else{
            NSLog(@"all in cat not the same");
            self.ratingsDict[category] = [NSNumber numberWithInt:0];
        }
        if (oldCatRating != [self.ratingsDict[category] intValue])
            [editIndices addObject:[NSIndexPath indexPathForRow:catIndex inSection:0]];
        
    }
    [self setState];
    [self saveRatings];
    for (NSIndexPath* ip in editIndices){
        FoodTypeTableViewCell* cell = (FoodTypeTableViewCell*)[self.foodTypeTable cellForRowAtIndexPath:ip];
        cell.stars = [self.foodTypes[ip.row][@"stars"] intValue];
        [cell setRatingButtonWithImage];
    }

    //[self updateFoodTypesTable:addIndices editIndices:editIndices removeIndices:deleteIndices];
            
}
-(NSMutableArray*)getSelfAndCategory:(NSString*)sub
{
    NSMutableArray* ret = [[NSMutableArray alloc] init];
    int cnt = 0;
    for (NSMutableDictionary* dict in self.foodTypes){
        if ([dict[@"category"] boolValue]){
            int innercnt = 1;
            if ([dict[@"expanded"] boolValue]){
                while (innercnt <= ((NSArray*)dict[@"subcategories"]).count){
                    NSString* str = self.foodTypes[innercnt + cnt][@"label"];
                    if ([((NSArray*) dict[@"subcategories"]) indexOfObject:str] == NSNotFound)
                        break;
                    if ([str isEqualToString:sub]){
                        [ret addObject:[NSNumber numberWithInt:innercnt + cnt]];
                        [ret addObject:[NSNumber numberWithInt:cnt]];
                        return ret;
                    }
                    innercnt += 1;
                    
                }
                cnt += innercnt - 1;
            }
        cnt += 1;
        }
      
    }
    return ret;
}
-(NSMutableArray*)loadFoodTypes{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"ratingsDict"])
            self.ratingsDict = [[[NSUserDefaults standardUserDefaults] objectForKey:@"ratingsDict"] mutableCopy];
    else
        self.ratingsDict = [[NSMutableDictionary alloc] init];
    
    //NSArray*tv =[NSArray arrayWithObjects:@"Bagels",@"Diners",@"Brunch", nil];
    NSMutableDictionary* t2 = [[NSMutableDictionary alloc] initWithObjects:[NSArray arrayWithObjects:[NSNumber numberWithBool:YES],[NSNumber numberWithInt:1], @"Breakfast",  nil] forKeys:[NSArray arrayWithObjects:@"category", @"stars", @"label",  nil]];
        t2[@"subcategories"] =[NSArray arrayWithObjects:@"Bagels",@"Diners",@"Brunch", nil];

    //Expand All these
    NSMutableDictionary* t3 = [[NSMutableDictionary alloc] initWithObjects:[NSArray arrayWithObjects:[NSNumber numberWithBool:YES],[NSNumber numberWithInt:1], @"Steakhouse", nil] forKeys:[NSArray arrayWithObjects:@"category", @"stars", @"label",  nil]];
    t3[@"subcategories"] = [NSArray arrayWithObjects:@"Steakhouse", nil];
 
    NSMutableDictionary* t4 = [[NSMutableDictionary alloc] initWithObjects:[NSArray arrayWithObjects:[NSNumber numberWithBool:YES],[NSNumber numberWithInt:1], @"Healthy",  nil] forKeys:[NSArray arrayWithObjects:@"category", @"stars", @"label", nil]];
    t4[@"subcategories"] = [NSArray arrayWithObjects:@"Gluten Free",@"Raw", @"Vegan", @"Vegetarian", nil];

    NSMutableDictionary* t5 = [[NSMutableDictionary alloc] initWithObjects:[NSArray arrayWithObjects:[NSNumber numberWithBool:YES],[NSNumber numberWithInt:1], @"Buffet", nil] forKeys:[NSArray arrayWithObjects:@"category", @"stars", @"label",  nil]];
    t5[@"subcategories"] = [NSArray arrayWithObjects:@"Buffet", @"Cafeteria", nil];

    NSMutableDictionary* t6 = [[NSMutableDictionary alloc] initWithObjects:[NSArray arrayWithObjects:[NSNumber numberWithBool:YES],[NSNumber numberWithInt:1], @"Quick Bite", nil] forKeys:[NSArray arrayWithObjects:@"category", @"stars", @"label" , nil]];
    t6[@"subcategories"] = [NSArray arrayWithObjects:@"Deli", @"Fast Food", @"Food Court", @"Food Stand", @"Hot Dogs", @"Sandwiches", @"Soup", nil];

    NSMutableDictionary* t1 = [[NSMutableDictionary alloc] initWithObjects:[NSArray arrayWithObjects:[NSNumber numberWithBool:YES],[NSNumber numberWithInt:1], @"Italian", nil] forKeys:[NSArray arrayWithObjects:@"category", @"stars", @"label", nil]];
    t1[@"subcategories"] =  [NSArray arrayWithObjects:@"Italian",@"Pizza", nil];

    NSMutableDictionary* t7 = [[NSMutableDictionary alloc] initWithObjects:[NSArray arrayWithObjects:[NSNumber numberWithBool:YES],[NSNumber numberWithInt:1], @"American", nil] forKeys:[NSArray arrayWithObjects:@"category", @"stars", @"label", nil]];
    t7[@"subcategories"] =[NSArray arrayWithObjects:@"American", @"BBQ",@"Burgers",@"Cajun", @"Cheesesteaks",@"Chicken Wings", @"Comfort Food", @"Soul Food", @"Southern Food", nil];

    NSMutableDictionary* t8 = [[NSMutableDictionary alloc] initWithObjects:[NSArray arrayWithObjects:[NSNumber numberWithBool:YES],[NSNumber numberWithInt:1], @"Latin", nil] forKeys:[NSArray arrayWithObjects:@"category", @"stars", @"label",  nil]];
    t8[@"subcategories"] =  [NSArray arrayWithObjects:@"Caribbean",@"Colombian", @"Dominican",@"Haitian",@"Hawaiian", @"Latin American",@"Puetro Rican", @"Salvadoran", @"Trinidadian", @"Venezuelan", nil];

    NSMutableDictionary* t9 = [[NSMutableDictionary alloc] initWithObjects:[NSArray arrayWithObjects:[NSNumber numberWithBool:YES],[NSNumber numberWithInt:1], @"Seafood", nil] forKeys:[NSArray arrayWithObjects:@"category", @"stars", @"label", nil]];
    t9[@"subcategories"] = [NSArray arrayWithObjects:@"Fish & Chips", @"Seafood", nil];

    NSMutableDictionary* t10 = [[NSMutableDictionary alloc] initWithObjects:[NSArray arrayWithObjects:[NSNumber numberWithBool:YES],[NSNumber numberWithInt:1], @"Spanish", nil] forKeys:[NSArray arrayWithObjects:@"category", @"stars", @"label",  nil]];
    t10[@"subcategories"] =  [NSArray arrayWithObjects:@"Spanish", @"Tapas", nil];

    NSMutableDictionary* t11 = [[NSMutableDictionary alloc] initWithObjects:[NSArray arrayWithObjects:[NSNumber numberWithBool:YES],[NSNumber numberWithInt:1], @"Indian", nil] forKeys:[NSArray arrayWithObjects:@"category", @"stars", @"label", nil]];
    t11[@"subcategories"] =  [NSArray arrayWithObjects:@"Indian", nil];
      
    NSMutableDictionary* t12 = [[NSMutableDictionary alloc] initWithObjects:[NSArray arrayWithObjects:[NSNumber numberWithBool:YES],[NSNumber numberWithInt:1], @"Chinese", nil] forKeys:[NSArray arrayWithObjects:@"category", @"stars", @"label", nil]];
    t12[@"subcategories"] =  [NSArray arrayWithObjects:@"Chinese", @"Dim Sum",@"Shanghainese", nil];

    NSMutableDictionary* t13 = [[NSMutableDictionary alloc] initWithObjects:[NSArray arrayWithObjects:[NSNumber numberWithBool:YES],[NSNumber numberWithInt:1], @"Mediterranean",  nil] forKeys:[NSArray arrayWithObjects:@"category", @"stars", @"label", nil]];
       
    t13[@"subcategories"] =[NSArray arrayWithObjects:@"Falafel",@"Greek", @"Halal", @"Lebanese", @"Mediterranean", @"Middle Eastern", @"Slovakian", nil];
        

    NSMutableDictionary* t14 = [[NSMutableDictionary alloc] initWithObjects:[NSArray arrayWithObjects:[NSNumber numberWithBool:YES],[NSNumber numberWithInt:1], @"Japanese/Sushi",  nil] forKeys:[NSArray arrayWithObjects:@"category", @"stars", @"label", nil]];

    t14[@"subcategories"] = [NSArray arrayWithObjects:@"Japanese",@"Sushi", nil];
       
    NSMutableDictionary* t15 = [[NSMutableDictionary alloc] initWithObjects:[NSArray arrayWithObjects:[NSNumber numberWithBool:YES],[NSNumber numberWithInt:1], @"Mexican", nil] forKeys:[NSArray arrayWithObjects:@"category", @"stars", @"label", nil]];
    t15[@"subcategories"] =  [NSArray arrayWithObjects:@"Mexican",@"Tex-Mex", nil];

    NSMutableDictionary* t16 = [[NSMutableDictionary alloc] initWithObjects:[NSArray arrayWithObjects:[NSNumber numberWithBool:YES],[NSNumber numberWithInt:1], @"French",  nil] forKeys:[NSArray arrayWithObjects:@"category", @"stars", @"label", nil]];
    t16[@"subcategories"] =[NSArray arrayWithObjects:@"Brasseries",@"Fondue",@"French", nil];
         
    NSMutableDictionary* t17 = [[NSMutableDictionary alloc] initWithObjects:[NSArray arrayWithObjects:[NSNumber numberWithBool:YES],[NSNumber numberWithInt:1], @"Coffee & Dessert",  nil] forKeys:[NSArray arrayWithObjects:@"category", @"stars", @"label",nil]];
    t17[@"subcategories"] = [NSArray arrayWithObjects:@"Cafe", @"Coffee & Tea",@"Crepery",@"Cupcakes",@"Dessert", @"Donuts", @"Gelato", @"Ice Cream/Frozen Yogurt", @"Juice Bar", nil];

    NSMutableDictionary* t18 = [[NSMutableDictionary alloc] initWithObjects:[NSArray arrayWithObjects:[NSNumber numberWithBool:YES],[NSNumber numberWithInt:1], @"Exotic Others", nil] forKeys:[NSArray arrayWithObjects:@"category", @"stars", @"label", nil]];
    t18[@"subcategories"] = [NSArray arrayWithObjects: @"Afghan",@"Arabian",@"Armenian",@"Austrian",@"Bangladeshi",@"Australian",@"Basque",@"African",@"Senegalese",@"South African",@"Brazilian"    ,@"Belgian",@"British",@"Catalan",@"Burmese",@"Cantonese",@"Cambodian",@"Szechuan",@"Cuban",@"Czech",@"Ethiopian",@"Filipino",@"Vietnamese"    ,@"Gastropubs",@"German",@"Himalayan/Nepalese",@"Hot Pot",@"Hungarian",@"Iberian",@"Indonesian",@"Irish",@"Korean",@"Kosher",@"Laotian",@"Malaysian",@"Egyptian",@"Modern European",@"Mongolian",@"Moroccan",@"Pakistani", @"Persian Iranian",@"Peruvian",@"Polish",@"Portuguese",@"Russian",@"Scandinavian", @"Scottish", @"Singaporean", @"Thai",@"Turkish",@"Ukrainian",@"Taiwanese",@"Asian Fusion",@"Argentine" , nil];
    
    self.foodTypes = [[NSArray arrayWithObjects:t7,t2,t5,t12,t17,t16,t4,t11,t1,t14,t8,t13,t15,t6,t9, t10,t3,t18, nil] mutableCopy];
    for (NSMutableDictionary* dict in self.foodTypes){
        dict[@"stars"] = [self rating:nil childName:dict[@"label"]];
        dict[@"expanded"] = [NSNumber numberWithBool:NO];
    }
    self.allFoodTypes = [self.foodTypes mutableCopy];;
    return  self.foodTypes;
    
}

-(NSNumber*) rating:(NSString*)parentName childName:(NSString*)childName{

    if (parentName){
        if (!self.ratingsDict[[NSString stringWithFormat:@"sub%@",childName] ])
            self.ratingsDict[[NSString stringWithFormat:@"sub%@",childName] ] = [self.ratingsDict[parentName] copy];
        return self.ratingsDict[[NSString stringWithFormat:@"sub%@",childName] ];
    }
    else{
        if (!self.ratingsDict[childName])
            self.ratingsDict[childName] = [NSNumber numberWithInt:1];
    }
    return self.ratingsDict[childName];
}
-(void)saveRatings{
    for (NSMutableDictionary* dict in self.foodTypes){
       if ([dict[@"category"] boolValue])
           dict[@"stars"] = self.ratingsDict[dict[@"label"]];
        else
            dict[@"stars"] = self.ratingsDict[[NSString stringWithFormat:@"sub%@", dict[@"label"]] ];
    }

    [LEViewController setUserDefault:@"ratingsDict" data:self.ratingsDict];
}

-(void)updateFoodTypesTable:(NSMutableArray*)addIndices editIndices:(NSMutableArray*)editIndices removeIndices:(NSMutableArray*)removeIndices{

    [self.foodTypeTable beginUpdates];
    if (removeIndices)
        [self.foodTypeTable deleteRowsAtIndexPaths:removeIndices withRowAnimation:UITableViewRowAnimationAutomatic];
    if (addIndices)
        [self.foodTypeTable insertRowsAtIndexPaths:addIndices withRowAnimation:UITableViewRowAnimationAutomatic];
   if(editIndices)
       [self.foodTypeTable reloadRowsAtIndexPaths:editIndices withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.foodTypeTable endUpdates];
   

}
-(void)modifyCategory:(bool)expanded categoryInput:(NSString*)categoryInput
{
    self.expandedState = nil;
    NSMutableArray* addIndices = [[NSMutableArray alloc] init];
    NSMutableArray* removeIndices = [[NSMutableArray alloc] init];
    NSMutableArray* reloadIndices = [[NSMutableArray alloc] init];
    NSMutableArray* newFoodTypes = [self.foodTypes mutableCopy] ;
    int size = self.foodTypes.count;
    int cnt = 0;
    int reloadIndex;
    int oldCnt = cnt;
    bool skip = NO;
    for (NSMutableDictionary* dict in self.foodTypes){
        if ([dict[@"label"] isEqualToString:categoryInput] && [dict[@"category"] boolValue]){
            skip = YES;
  
            dict[@"expanded"] = [NSNumber numberWithBool:(expanded)];
            reloadIndex = cnt;
            [reloadIndices addObject:[NSIndexPath indexPathForRow:oldCnt inSection:0]];
            for (NSString* subcat in dict[@"subcategories"]){
                 cnt += 1;
                if (expanded){
                    NSNumber* myRating = [self rating:dict[@"label"] childName:subcat];
 

                    NSArray* inserts = [NSArray arrayWithObjects:[NSNumber numberWithBool:NO],myRating, subcat, nil];
 
                    [newFoodTypes insertObject:[[NSMutableDictionary alloc] initWithObjects:inserts forKeys:[NSArray arrayWithObjects:@"category", @"stars", @"label", nil] ]atIndex:cnt];
                    [addIndices addObject:[NSIndexPath indexPathForRow:cnt inSection:0]];
                }
                else{
                    [newFoodTypes removeObjectAtIndex:reloadIndex + 1];
                    [removeIndices addObject:[NSIndexPath indexPathForRow:cnt inSection:0]];
                }
               
            }
        }
        else if([dict[@"category"] boolValue] || (!skip)){
            skip = NO;
            [reloadIndices addObject:[NSIndexPath indexPathForRow:oldCnt inSection:0]];
        }
        cnt += 1;
        oldCnt += 1;
    }
    self.foodTypes = newFoodTypes;
    NSMutableArray* reloadObjects = [[NSMutableArray alloc] init];
    cnt = 0;
    while (cnt < size){
        [reloadObjects addObject:[NSIndexPath indexPathForRow:cnt inSection:0]];
        cnt += 1;
    }
    [self updateFoodTypesTable:addIndices editIndices:[[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:reloadIndex inSection:0],nil] mutableCopy ]removeIndices:removeIndices] ;
    [self saveRatings];
}


-(void)collapseCategory:(NSString*)categoryInput{

        [self modifyCategory:NO categoryInput:categoryInput];
}

-(void)expandCategory:(NSString*)categoryInput{

    [self modifyCategory:YES categoryInput:categoryInput];
    bool allSubcellsVisible = YES;
    int cnt = 0;
    int categoryIndex = -1;
    int lastSubcategoryIndex = -1;
    for (NSMutableDictionary* dict in self.foodTypes){
        if (([dict[@"label"] isEqualToString:categoryInput]) && ([dict[@"category"] boolValue])){
            categoryIndex = cnt;
            lastSubcategoryIndex = cnt + ((NSArray*)dict[@"subcategories"]).count;
            for (NSString* subcat in dict[@"subcategories"]){
                cnt += 1;
                if (![self.foodTypeTable cellForRowAtIndexPath:INDEX_PATH(cnt, 0)]){
                    allSubcellsVisible = NO;
                    break;
                }
            }
            break;
        }
        cnt += 1;
    }
    if (!allSubcellsVisible){

        if ([self tableViewFits:self.foodTypeTable indexStart:categoryIndex indexEnd:lastSubcategoryIndex])
            [self.foodTypeTable scrollToRowAtIndexPath:INDEX_PATH(lastSubcategoryIndex + 1, 0) atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        else
            [self.foodTypeTable scrollToRowAtIndexPath:INDEX_PATH(categoryIndex, 0) atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
  

}
-(bool)tableViewFits:(UITableView*)tableView indexStart:(int)indexStart indexEnd:(int)indexEnd{
    return (tableView.visibleCells.count >= ((indexEnd - indexStart) + 1)) ;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.next setImage:GET_IMG(@"nextpressed") forState:UIControlStateHighlighted];
    self.foodTypes = [self loadFoodTypes];
    [self setState];
    self.searching = NO;
    self.progressBarDelegate = [[ProgressBarDelegate alloc] initWithTitle:@"Create Invitation"];
    [self.progressTable setDelegate:self.progressBarDelegate];
    [self.progressTable setDataSource:self.progressBarDelegate];
    [self.foodTypeTable setDelegate:self];
    [self.foodTypeTable setDataSource:self];
    self.starsTableView.dataSource = self;
    self.starsTableView.delegate = self;
    UIImage* bigDraggable = [UIImage imageNamed:@"Draggable"];
    self.draggable = [Graphics makeThumbnailOfSize:bigDraggable size:CGSizeMake(15, 15)];
    self.navigationController.navigationBarHidden = YES;
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
    self.view.backgroundColor = [UIColor colorWithPatternImage:GET_IMG(@"bg")];
    UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Chalkboard"]];
    [tempImageView setFrame:self.wantTable.frame];
    self.wantTable.backgroundView = tempImageView;
   // [self.view bringSubviewToFront:self.one];
   // [self.view sendSubviewToBack:self.chalkboard];

    /*UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tgr.delegate = self;
    [self.foodTypeTable addGestureRecognizer:tgr];*/
}

- (void)viewTapped:(UITapGestureRecognizer *)tgr
{
    NSLog(@"view tapped");
    // remove keyboard
}
-(void)viewWillAppear:(BOOL)animated{

}

-(void)homePressed:(UIBarButtonItem*)sender{
    [self.navigationController popToRootViewControllerAnimated:YES];
    self.navigationController.navigationBarHidden = YES;
}
-(void)backPressed:(UIBarButtonItem*)sender{
    [self.navigationController popViewControllerAnimated:YES];
    

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.foodTypeTable){
        if ([self.foodTypes[indexPath.row][@"category"] boolValue])
            return 40;
        else
            return 35;
    }
    else if (tableView == self.starsTableView){
        return 44;
    }
    return 0;
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    self.search.text = @"";
    self.search.showsCancelButton = NO;
    [self exitSearch];
}
-(void)exitSearch{
    NSMutableArray* newFoodTypes = [[NSMutableArray alloc] init];

    int cnt = 0;
    for (NSMutableDictionary* dict in self.allFoodTypes){
        if ([dict[@"category"] boolValue]){
            if (self.expandedState)
                dict[@"expanded"] = self.expandedState[cnt];
            [newFoodTypes addObject:dict];
            if ([dict[@"expanded"] boolValue]){
                for (NSString* str in dict[@"subcategories"]){
                    NSMutableDictionary* newDict = [[NSMutableDictionary alloc] init];
                    newDict[@"label"] = str;
                    newDict[@"category"] = [NSNumber numberWithBool:NO];
                    newDict[@"expanded"] = [NSNumber numberWithBool:NO];
                    newDict[@"stars"] = [self rating:dict[@"label"] childName:str];
                    [newFoodTypes addObject:newDict];
                }
            }
            cnt += 1;
        }
    }
    self.foodTypes = newFoodTypes;

    self.expandedState = nil;
    [self reloadTable:self.foodTypeTable];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    self.search.showsCancelButton = NO;
    
   // [self exitSearch:NO];
}
-(NSMutableArray*)copyFoodTypes{
    NSMutableArray* ret = [[NSMutableArray alloc] init];
    for (NSMutableDictionary* dict in self.foodTypes)
        [ret addObject:[dict mutableCopy]];
    return ret;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar*)searchBar
{
    self.expandedState = [[NSMutableArray alloc] init];
    for (NSMutableDictionary* dict in self.foodTypes){
        if ([dict[@"category"] boolValue])
            [self.expandedState addObject:dict[@"expanded"]];
    }
    //enter searching if not in it
  //  //if (!self.searching){
    //NSMutableArray* cats = [[NSMutableArray alloc] init];
    //self.foodTypesCopy = [self copyFoodTypes];
    //for (NSMutableDictionary* dict in self.foodTypesCopy){
      //  if ([dict[@"category"] boolValue]){
        //    if (![dict[@"expanded"] boolValue])
          //      [cats addObject:dict[@"label"]];
        //}
    //}
    //for (NSString* cat in cats){
      //  [self expandCategory:cat];
    //}
      //self.searching = YES;
    //self.allFoodTypes = [self.foodTypes mutableCopy];
    //}
    //self.foodTypes = [self.allFoodTypes mutableCopy];

    self.search.showsCancelButton = YES;
}
-(void)expandAll{
  //  NSLog(@"all food types %@", self.allFoodTypes);
    NSMutableArray* newFoodTypes = [[NSMutableArray alloc] init];
    for (NSMutableDictionary* dict in self.allFoodTypes){
        if ([dict[@"category"] boolValue]){
            dict[@"expanded"] = [NSNumber numberWithBool:YES];
            [newFoodTypes addObject:dict];
            for (NSString* str in dict[@"subcategories"]){
                NSMutableDictionary* newDict = [[NSMutableDictionary alloc] init];
                newDict[@"label"] = str;
                newDict[@"category"] = [NSNumber numberWithBool:NO];
                newDict[@"expanded"] = [NSNumber numberWithBool:NO];
                newDict[@"stars"] = [self rating:dict[@"label"] childName:str];
                [newFoodTypes addObject:newDict];
            }
        }
    }
    self.foodTypes = newFoodTypes;
    
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    
    [self expandAll];
    if ([searchText isEqualToString:@""])
    {}
    else
    {
        NSMutableArray* removals = [[NSMutableArray alloc] init];
        int cnt = 0;
        for (NSMutableDictionary* dict in self.foodTypes){
            bool anyIn = NO;
            if ([dict[@"category"] boolValue]){
                int innercnt = 1;
                if([[self.foodTypes[cnt][@"label"] lowercaseString] rangeOfString:[searchText lowercaseString]].location != NSNotFound){
                    anyIn = YES;
                }
                if (!anyIn) {
                    while (innercnt <= ((NSArray*)dict[@"subcategories"]).count){
                        if ([[self.foodTypes[cnt + innercnt ][@"label"] lowercaseString] rangeOfString:[searchText lowercaseString]].location != NSNotFound){
                            anyIn = YES;
                        }
                        else{
                        [removals addObject:self.foodTypes[cnt + innercnt]];
                        }
                        innercnt += 1;
                    }
                }
                else{
                    innercnt = ((NSArray*) dict[@"subcategories"]).count + 1;
                }
                if (!anyIn)
                    [removals addObject:self.foodTypes[cnt]];
                cnt += innercnt - 1;
                cnt += 1;
            }
        }
        for (NSMutableDictionary* dict in removals)
             [self.foodTypes removeObject:dict];
    }
    [self.foodTypeTable reloadData];
    /*    for(NSString* type in self.savedTypes)
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
    [self reloadTable:self.typesTable];//[self.typesTable reloadData];*/
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
    if (tableView == self.foodTypeTable){
        FoodTypeTableViewCell* cell = (FoodTypeTableViewCell*)[self.foodTypeTable cellForRowAtIndexPath:indexPath];
        if (cell.category)
            [cell expandCollapse];

    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.foodTypeTable){
        NSDictionary* member = self.foodTypes[indexPath.row];
        FoodTypeTableViewCell* cell;
        if ([member[@"category"] boolValue])
            cell = [tableView dequeueReusableCellWithIdentifier:@"FoodType"];
        else
            cell = [tableView dequeueReusableCellWithIdentifier:@"yelpFood"];
        [cell setLayout:[self.foodTypes[indexPath.row] mutableCopy] vc:self];
        if (cell.category)
            [cell setSelectionStyle:UITableViewCellSelectionStyleDefault];
        else
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }
    if (tableView == self.starsTableView){
        CheckAllStarsTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CheckAllStars"];
        [cell setWithState:self.checkAllState vc:self];
         [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }
    NSMutableArray *arr;
    if (tableView == self.typesTable)
        arr = self.typesItems;
    else
        arr = self.wantItems;

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
    if (tableView == self.foodTypeTable)
        return self.foodTypes.count;
    else if (tableView == self.starsTableView){
        return 1;
    }
    return 0;
    //if (tableView == self.wantTable)
      // return MIN(6,[self.wantItems count]);//
    //return [self.typesItems count];
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
