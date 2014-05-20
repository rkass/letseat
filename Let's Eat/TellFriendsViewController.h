//
//  TellFriendsViewController.h
//  Let's Eat
//
//  Created by Ryan Kass on 3/16/14.
//  Copyright (c) 2014 Ryan Kass. All rights reserved.
//

#import "LEViewController.h"
#import <MessageUI/MessageUI.h>
@class CheckAllStarsTableViewCell;
@class ProgressBarDelegate;
@class ProgressBarTableViewCell;
@interface TellFriendsViewController : LEViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, MFMessageComposeViewControllerDelegate, UIAlertViewDelegate>

@end
