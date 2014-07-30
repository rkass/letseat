//
//  User.m
//  Let's Eat
//
//  Created by Ryan Kass on 2/13/14.
//  Copyright (c) 2014 Ryan Kass. All rights reserved.
//

#import "User.h"
#import "Server.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

#import "LEViewController.h"

@implementation User

@synthesize auth_token, username;
-(User *) init
{
    self = [super init];
    if (!self) return nil;
    return self;
}
+ (void) createAccountFB:(NSString *)facebookid source:(NSObject *)source{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:facebookid, @"facebook_id", nil];
    dict[@"deviceToken"] = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] dataForKey:@"deviceToken"]];
    [Server postRequest:@"register" data:dictToJSON(dict) source:source];
}
+ (void) createAccount:(NSString *)phoneNumber usernameAttempt:(NSString *)usernameAttempt password:(NSString *)password source:(NSObject *)source
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:phoneNumber, @"phoneNumber", usernameAttempt, @"username", password, @"password", nil];
    dict[@"deviceToken"] = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] dataForKey:@"deviceToken"]];
    [Server postRequest:@"register" data:dictToJSON(dict) source:source];
    
}
+ (void) createInvitation:(NSMutableDictionary*)preferences source:(NSObject*)source{
    NSMutableDictionary* dict = preferences;
    NSTimeZone* x = [NSTimeZone localTimeZone];
    [dict setObject:[NSNumber numberWithInt:x.secondsFromGMT] forKey:@"secondsFromGMT"];
    setAuthToken;
    [Server postRequest:@"create_invitation" data:dictToJSON(dict) source:source];
}
+ (void) sendToken{
   // NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] stringForKey:@"auth_token"], @"auth_token", nil];// [[NSUserDefaults standardUserDefaults] dataForKey:@"deviceToken"], @"token", nil];
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] stringForKey:@"auth_token"], @"auth_token", [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] dataForKey:@"deviceToken"]], @"token", nil];
    [Server postRequest:@"update_token" data:dictToJSON(dict) source:nil];
}
+ (void) respondYes:(int)num preferences:(NSMutableDictionary*)preferences source:(NSObject*)source{
    NSMutableDictionary* dict = preferences;
    [dict setObject:[NSNumber numberWithInt:num] forKey:@"id"];
    setAuthToken;
    [Server postRequest:@"respond_yes" data:dictToJSON(dict) source:source];
}
+ (void) respondNo:(int)num message:(NSString*)message source:(NSObject*)source
{
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    [dict setObject:message forKey:@"message"];
    [dict setObject:[NSNumber numberWithInt:num] forKey:@"id"];
    setAuthToken;
    [Server postRequest:@"respond_no" data:dictToJSON(dict) source:source];
}


+ (void) getInvitations:(NSObject *) source
{
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    setAuthToken;
    [Server postRequest:@"get_invitations" data:dictToJSON(dict) source:source];
}
+ (void) getMeals:(NSObject *) source
{
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    setAuthToken;
    [Server postRequest:@"get_meals" data:dictToJSON(dict) source:source];
}
+ (void) verifyUser:(NSString*)auth_token source:(NSObject*)source{
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[[NSUserDefaults standardUserDefaults] stringForKey:@"username"] forKey:@"username"];
    [dict setObject:auth_token forKey:@"auth_token"];
    [Server postRequest:@"verify_user" data:dictToJSON(dict) source:source];
}

+ (void) castVote:(NSMutableDictionary*)dict source:(NSObject*)source{
    setAuthToken;
    [Server postRequest:@"cast_vote" data:dictToJSON(dict) source:source];
}
+ (void) castUnvote:(NSMutableDictionary*)dict source:(NSObject*)source{
    setAuthToken;
    [Server postRequest:@"cast_unvote" data:dictToJSON(dict) source:source];
}
+ (void) getInvitation:(int)num source:(NSObject*)source{
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[NSNumber numberWithInt:num] forKey:@"id"];
    setAuthToken;
    [Server postRequest:@"get_invitation" data:dictToJSON(dict) source:source];
}
+ (void) getRestaurants:(int)num source:(NSObject*)source{
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[NSNumber numberWithInt:num] forKey:@"id"];
    setAuthToken;
    [Server postRequest:@"get_restaurants" data:dictToJSON(dict)  source:source];
}

+ (void) getFriends:(NSObject *) source
{
    
    [Server postRequest:@"get_friends" data:[User jsonifyContacts] source:source];
}

+ (void) getNonFriends:(NSObject *) source
{
    
    [Server postRequest:@"get_non_friends" data:[User jsonifyContacts] source:source];
}

+ (void)login:(NSString *)usernameAttempt password:(NSString *)password source:(NSObject*)source
{
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:usernameAttempt, @"username", password, @"password", nil];
    [Server postRequest:@"sign_in" data:dictToJSON(dict)  source:source];
    
}

//If phone number in contacts, return the name, else return the phone
//number
+ (NSString*)contactNameForNumber:(NSString*)phoneNumber
{
    NSString* ret;
    if (phoneNumber == (id)[NSNull null]) {
        
    }
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"phone_number"] isEqualToString:phoneNumber] || [[[NSUserDefaults standardUserDefaults] objectForKey:@"facebook_id"] isEqualToString:phoneNumber])
        return @"You";
    if ([[NSUserDefaults standardUserDefaults] stringForKey:[@"pn" stringByAppendingString:phoneNumber]])
        return [[NSUserDefaults standardUserDefaults] stringForKey:[@"pn" stringByAppendingString:phoneNumber]];
    for (NSDictionary* dict in [User getContacts]){
        for (NSString* number in dict[@"phone_numbers"]){
            NSString * newnum = [number stringByReplacingOccurrencesOfString:@"[^0-9]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, [number length])];
            if ([[newnum substringToIndex:1] isEqualToString:@"1"])
                newnum = [newnum substringFromIndex:1];
            if ([newnum isEqualToString:phoneNumber]){
                if (dict[@"last_name"] && dict[@"last_name"]){
                   ret =  [[dict[@"first_name"] stringByAppendingString:@ " "] stringByAppendingString:dict[@"last_name"]];
                    break;}
                if (dict[@"first_name"]){
                    ret = dict[@"first_name"];
                    break;
                }
                if (dict[@"last_name"]){
                    ret = dict[@"last_name"];
                    break;
                }
            }
        }
    }
    if (!ret){
        NSArray *friendsCacheLoaded = [[NSUserDefaults standardUserDefaults] arrayForKey:@"friendsCache"];
        NSLog(@"yeah yeah here friendscache: %@", friendsCacheLoaded);
        for (NSDictionary* dict in friendsCacheLoaded)
        {
            if (dict[@"facebook_id"] && [dict[@"facebook_id"] isEqualToString:phoneNumber])
                ret = dict[@"displayName"];
        }
    }
    if (!ret)
        ret = phoneNumber;
    else
        [LEViewController setUserDefault:[@"pn" stringByAppendingString:phoneNumber] data:ret];
    return ret;
}

//Returns contacts and auth_token
+(NSData *)jsonifyContacts
{
    NSArray* contacts = [User getContacts];
    if (!contacts){
         UIAlertView* av = [[UIAlertView alloc] initWithTitle:@"Oof" message:@"We need access to your contacts, in order to find your friends.  Please grant Let's Eat access to your contacts in Settings" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [av show];
        contacts = [[NSArray alloc] init];
    }
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    [dict setObject:contacts forKey:@"contacts"];
    setAuthToken;
    //return [request JSONData];
    return dictToJSON(dict);


}

+(NSString*)transformNumber:(NSString*)num{
    return [[[[[[num stringByReplacingOccurrencesOfString:@"(" withString:@""] stringByReplacingOccurrencesOfString:@")" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""] stringByReplacingOccurrencesOfString:@"+" withString:@""] stringByReplacingOccurrencesOfString:@"-" withString:@""] stringByReplacingOccurrencesOfString:@"." withString:@""];
}

+(NSArray *)getContacts
{
    
    CFErrorRef *error = nil;
    
    
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, error);
    
    __block BOOL accessGranted = NO;
    if (ABAddressBookRequestAccessWithCompletion != NULL) { // we're on iOS 6
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            accessGranted = granted;
            dispatch_semaphore_signal(sema);
        });
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        
    }
    else { // we're on iOS 5 or older
        accessGranted = YES;
    }
    
    if (accessGranted) {
        
        
        
        ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, error);
        ABRecordRef source = ABAddressBookCopyDefaultSource(addressBook);
        CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeopleInSourceWithSortOrdering(addressBook, source, kABPersonSortByFirstName);
        CFIndex nPeople = CFArrayGetCount(allPeople);
        NSMutableArray* items = [NSMutableArray arrayWithCapacity:nPeople];
        
        
        for (int i = 0; i < nPeople; i++)
        {
            NSMutableDictionary *personDict = [[NSMutableDictionary alloc] init];
            
            ABRecordRef person = CFArrayGetValueAtIndex(allPeople, i);
            
            //get First Name and Last Name
            
            [personDict setValue:(__bridge NSString*)ABRecordCopyValue(person, kABPersonFirstNameProperty) forKey:@"first_name"];
            [personDict setValue:(__bridge NSString*)ABRecordCopyValue(person, kABPersonLastNameProperty) forKey:@"last_name"];
            
            /*Don't care about pictures now, maybe in later versions
             // get contacts picture, if pic doesn't exists, show standart one
             
             NSData  *imgData = (__bridge NSData *)ABPersonCopyImageData(person);
             contacts.image = [UIImage imageWithData:imgData];
             if (!contacts.image) {
             contacts.image = [UIImage imageNamed:@"NOIMG.png"];
             }
             */
            //get Phone Numbers
            
            NSMutableArray *phoneNumbers = [[NSMutableArray alloc] init];
            bool add = YES;
            ABMultiValueRef multiPhones = ABRecordCopyValue(person, kABPersonPhoneProperty);
            for(CFIndex i=0;i<ABMultiValueGetCount(multiPhones);i++) {
                
                CFStringRef phoneNumberRef = ABMultiValueCopyValueAtIndex(multiPhones, i);
                NSString *phoneNumber = (__bridge NSString *) phoneNumberRef;
                [phoneNumbers addObject:phoneNumber];
                if ([[User transformNumber:phoneNumber] isEqualToString:[User transformNumber:[[NSUserDefaults standardUserDefaults] stringForKey:@"phone_number"]]])
                     add = NO;
                if ([personDict[@"first_name"] rangeOfString:@"Casey"].location != NSNotFound) {
                    NSLog(@"phone number: %@", phoneNumber);
                    NSLog(@"first name: %@", personDict[@"first_name"]);
                }
            }
            
            if (add)
                [personDict setValue:phoneNumbers forKey:@"phone_numbers"];
            
            /*Don't care about emails, maybe one day we will
             //get Contact email
             
             NSMutableArray *contactEmails = [NSMutableArray new];
             ABMultiValueRef multiEmails = ABRecordCopyValue(person, kABPersonEmailProperty);
             
             for (CFIndex i=0; i<ABMultiValueGetCount(multiEmails); i++) {
             CFStringRef contactEmailRef = ABMultiValueCopyValueAtIndex(multiEmails, i);
             NSString *contactEmail = (__bridge NSString *)contactEmailRef;
             
             [contactEmails addObject:contactEmail];
             // NSLog(@"All emails are:%@", contactEmails);
             
             }
             
             [contacts setEmails:contactEmails];
             
             */
            
            [items addObject:personDict];
            
        }
        return items;
        
        
        
    } else {
        return NO;
        
        
    }
    
}


@end
