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
#import <Crashlytics/Crashlytics.h>
#import <FacebookSDK/FacebookSDK.h>

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
  [Crashlytics startWithAPIKey:@"b3a27e822c60b992e914123e5a22e88a2002500d"];
     [FBLoginView class];
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
    if( [currentUser isEqualToString:@"kkwan" ]){
        [LEViewController setUserDefault:@"auth_token" data:@"6de9f6d09ca4849446c63dd908a387e6362c40dc"];
        [LEViewController setUserDefault:@"phone_number" data:@"6463317888"];
    }
    else if ([currentUser isEqualToString:@"badlogin"]){
        [LEViewController setUserDefault:@"auth_token" data:@"6de9f6d09ca4849446c63ddl08a387e6362c40dc"];
        [LEViewController setUserDefault:@"phone_number" data:@"6403317888"];
    }
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
        self.blocker =  [[UIView alloc] initWithFrame:CGRectMake(0,0,[UIApplication sharedApplication].keyWindow.frame.size.width , [UIApplication sharedApplication].keyWindow.frame.size.height)];
        self.blocker.backgroundColor = [UIColor clearColor];
        [[UIApplication sharedApplication].keyWindow addSubview:self.blocker];
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
    [LEViewController setUserDefault:@"mealsPressed" data:[NSNumber numberWithBool:scheduled]];
    if ([[cm.viewControllers lastObject] isKindOfClass:[InvitationsViewController class]]){
        [[cm.viewControllers lastObject] refreshView];
    }
    else{
        InvitationsViewController* iv = (InvitationsViewController*)[storyboard instantiateViewControllerWithIdentifier:@"Invitations"];
      
        [cm pushViewController:iv animated:NO];
    }
      [self.blocker removeFromSuperview];
}
-(void)connectionDidFinishLoading:(NSURLConnection*)connection{
    
    NSDictionary* resultsDictionary = JSONTodict(self.responseData);
    self.responseData = [[NSMutableData alloc] initWithLength:0];
    //conn 1
    NSLog(@"resultsDictionary: %@", resultsDictionary);
    if ([resultsDictionary[@"validated"] boolValue]){
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:0]  forKey:@"badCredentials"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [LEViewController setUserDefault:@"auth_token" data:resultsDictionary[@"auth_token"]];
        [LEViewController setUserDefault:@"phone_number" data:resultsDictionary[@"phone_number"]];
    }
    else{
        UIAlertView* av = [[UIAlertView alloc] initWithTitle:@"Bad login, please register again." message:@"" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [av show];
    }
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    UIViewController *viewController =  [storyboard instantiateViewControllerWithIdentifier:@"Initial"];
    if ([[NSUserDefaults standardUserDefaults] stringForKey:@"auth_token"]){
        viewController = [storyboard instantiateViewControllerWithIdentifier:@"navController"];
    }
    self.window.rootViewController = viewController;
    [self.window makeKeyAndVisible];

    
}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [self.responseData appendData:data];
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
     NSString* urlString = [NSString stringWithFormat:@"%@", url];
    if ([urlString rangeOfString:@"fb355364134639864"].location != NSNotFound) {
        NSLog(@"we in here faceook bitches");
        return [FBAppCall handleOpenURL:url
                      sourceApplication:sourceApplication];
    }
   
    NSRange range = [urlString rangeOfString:@"register"];
    self.responseData = [[NSMutableData alloc] initWithLength:0];
    NSString* auth_token = [urlString substringFromIndex:range.length + range.location + 1];
    NSLog(@"auth token: %@", auth_token);
    [User verifyUser:auth_token source:self];
    return YES;
}
-(void)loadInvite:(int)num{
  //  UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CreateMealNavigationController* cm = (CreateMealNavigationController*)self.window.rootViewController;
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
      [self.blocker removeFromSuperview];
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
