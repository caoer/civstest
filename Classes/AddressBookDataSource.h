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
- (NSMutableArray*) alphabetArray;							//alphabetArrayWith # and {search}

-(NSArray *) arrayAtSection:(NSInteger)section;				//section data
-(NSString *) keyAtSection:(NSInteger)section;				//section name

-(Person *) personForIndexPath:(NSIndexPath*) indexPath;	
@end
