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
#import "JSONKit.h"

@implementation User

@synthesize auth_token, username;
-(User *) init
{
    self = [super init];
    if (!self) return nil;
    return self;
}

+ (void) createAccount:(NSString *)phoneNumber usernameAttempt:(NSString *)usernameAttempt password:(NSString *)password source:(NSObject *)source
{
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:phoneNumber, @"phoneNumber", usernameAttempt, @"username", password, @"password", nil];
    [Server postRequest:@"register" data:[dict JSONData] source:source];

}

+ (void) createInvitation:(NSMutableDictionary*)preferences{}

+ (void) getFriends:(NSObject *) source
{
    
    [Server postRequest:@"get_friends" data:[User jsonifyContacts] source:source];
}

+ (void)login:(NSString *)usernameAttempt password:(NSString *)password source:(NSObject*)source
{
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:usernameAttempt, @"username", password, @"password", nil];
    [Server postRequest:@"sign_in" data:[dict JSONData] source:source];
    
}

//Returns contacts and auth_token
+(NSData *)jsonifyContacts
{
    NSArray* contacts = [User getContacts];
    NSMutableDictionary* request = [[NSMutableDictionary alloc] init];
    [request setObject:contacts forKey:@"contacts"];
    [request setObject:[[NSUserDefaults standardUserDefaults] stringForKey:@"auth_token"] forKey:@"auth_token"];
    return [request JSONData];

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
            
            ABMultiValueRef multiPhones = ABRecordCopyValue(person, kABPersonPhoneProperty);
            for(CFIndex i=0;i<ABMultiValueGetCount(multiPhones);i++) {
                
                CFStringRef phoneNumberRef = ABMultiValueCopyValueAtIndex(multiPhones, i);
                NSString *phoneNumber = (__bridge NSString *) phoneNumberRef;
                [phoneNumbers addObject:phoneNumber];
                
                //NSLog(@"All numbers %@", phoneNumbers);
                
            }
            
            
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
