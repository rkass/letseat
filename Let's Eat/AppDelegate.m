//
//  AppDelegate.m
//  Let's Eat
//
//  Created by Ryan Kass on 2/10/14.
//  Copyright (c) 2014 Ryan Kass. All rights reserved.
//

#import "AppDelegate.h"
#import "CreateMealNavigationController.h"
#import "InviteViewController.h"
#import "InvitationsViewController.h"
#import "InviteTransitionConnectionHandler.h"
#import "User.h"

#define loadNotification(userInfo)\
{\
    if ([userInfo[@"link"] isEqualToString:@"invitations" ]){\
        [self loadInvitations:[userInfo[@"scheduled"] boolValue]];\
    }\
    else if ([userInfo[@"link"] isEqualToString:@"invite"]){\
    [self loadInvite:[userInfo[@"num"] integerValue]];\
    }\
}

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSLog(@"In did finish launching with options: %@", launchOptions);
    // initialize defaults
    NSString *dateKey = @"dateKey";
    NSDate *lastRead = (NSDate *)[[NSUserDefaults standardUserDefaults] objectForKey:dateKey];
    if (lastRead == nil)     // App first run: set up user defaults.
    {
        NSDictionary *appDefaults  = [NSDictionary dictionaryWithObjectsAndKeys:[NSDate date], dateKey, nil];
        
        // do any other initialization you want to do here - e.g. the starting default values.
        // [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"should_play_sounds"];
        
        // sync the defaults to disk
        [[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }

    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:dateKey];
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    if (launchOptions != nil) {
        NSLog(@"Launched from push notification");
        NSDictionary *notification = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        NSLog(@"notification dict: %@", notification);
    }
        // Do something with the notification dictionary
  //      self.myViewController = [LaunchFromNotificationViewController alloc] init];
    //} else {
      //  self.myViewController = [OrdinaryLaunchViewController alloc] init];
    //}
    
    //self.window.rootViewController = self.myViewController;
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    UIViewController *viewController =  [storyboard instantiateViewControllerWithIdentifier:@"Initial"];
    if ([[NSUserDefaults standardUserDefaults] stringForKey:@"auth_token"]){
        viewController = [storyboard instantiateViewControllerWithIdentifier:@"navController"];
    }
    self.window.rootViewController = viewController;
    [self.window makeKeyAndVisible];
    NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    
    if(userInfo)
    {
        loadNotification(userInfo);
    }
    return YES;

}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    [[NSUserDefaults standardUserDefaults] setObject:deviceToken forKey:@"deviceToken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    NSLog(@"Failed to get token, error: %@", error);
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    NSLog(@"In application will resign active");
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    NSLog(@"In application did enter background");
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    NSLog(@"In application will enter foreground");
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    /*NSLog(@"In application did become active");
    CreateMealNavigationController* cm = (CreateMealNavigationController*)self.window.rootViewController;
    if ([[cm.viewControllers lastObject] isKindOfClass:[InvitationsViewController class]]){
        NSLog(@"refresh");
    }
    else{
        InvitationsViewController* iv = [[InvitationsViewController alloc] init];
        [cm pushViewController:iv animated:NO];
        NSLog(@"segue to it");
    }*/
    
}

-(void)loadInvitations:(bool)scheduled{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CreateMealNavigationController* cm = (CreateMealNavigationController*)self.window.rootViewController;
    [cm setNavigationBarHidden:NO];
    [LEViewController setUserDefault:@"mealsPressed" data:[NSNumber numberWithBool:scheduled]];
    if ([[cm.viewControllers lastObject] isKindOfClass:[InvitationsViewController class]]){
        [[cm.viewControllers lastObject] refreshView];
    }
    else{
        InvitationsViewController* iv = (InvitationsViewController*)[storyboard instantiateViewControllerWithIdentifier:@"Invitations"];
        [cm pushViewController:iv animated:NO];
    }

}
-(void)loadInvite:(int)num{
  //  UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CreateMealNavigationController* cm = (CreateMealNavigationController*)self.window.rootViewController;
    [cm setNavigationBarHidden:NO];
    if ([[cm.viewControllers lastObject] isKindOfClass:[InviteViewController class]]){
        InviteViewController* iv = (InviteViewController*)[cm.viewControllers lastObject];
        iv.invitation.num = num;
        iv.date.text = @"Loading new invitation, hold on a sec...";
        [iv.inviteSpinner startAnimating];
        [iv recall];
    }
    else{
        InviteTransitionConnectionHandler* ivtch = [[InviteTransitionConnectionHandler alloc] initWithNav:cm];
        [User getInvitation:num source:ivtch];
    }
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"Received remote notification with info %@", userInfo);
    NSLog(@"Application State: %d", application.applicationState);
    if (application.applicationState == UIApplicationStateActive)
        NSLog(@"display notification");
    else{
        loadNotification(userInfo);
    }


}


- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    NSLog(@"In application will terminate");
}

@end
