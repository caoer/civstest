//
//  AddressBookDataSource.h
//  ReOrg
//
//  Created by zitao xiong on 8/23/11.
//  Copyright 2011 nanaimostudio.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>
#import "Person.h"

#define kFirstName @"firstName"
#define kLastName @"lastName"

@interface AddressBookDataSource : NSObject {
    NSArray *dataSource_;
    NSMutableArray *nameDataSource_;
    NSMutableArray *contactDataSource_;
}

@property (nonatomic, retain) NSMutableArray *contactDataSource;
@property (nonatomic, retain) NSMutableArray *nameDataSource;
@property (nonatomic, retain) NSArray *dataSource;
+(id) sharedInstance;

-(NSString *) firstNameAtIndex:(int)index;
-(NSString *) lastNameAtIndex:(int)index;
-(NSString *) nameAtIndex:(int)index;
-(int) count;
- (NSMutableArray*) alphabetArray;

-(NSArray *) arrayAtSection:(NSInteger)section;
-(NSString *) keyAtSection:(NSInteger)section;

-(Person *) personForIndexPath:(NSIndexPath*) indexPath;
@end
