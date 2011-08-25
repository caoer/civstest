//
//  AddressBookDataSource.m
//  ReOrg
//
//  Created by zitao xiong on 8/23/11.
//  Copyright 2011 nanaimostudio.com. All rights reserved.
//

#import "AddressBookDataSource.h"


@implementation AddressBookDataSource

@synthesize nameDataSource = nameDataSource_;
@synthesize dataSource = dataSource_;

- (void)dealloc
{
    DLOG(@"Error: try to dealloc sharedInstance!");
	[dataSource_ release];
	dataSource_ = nil;

	[nameDataSource_ release];
	nameDataSource_ = nil;

	[super dealloc];
}
+ (id)sharedInstance
{
	static id master = nil;
	
	@synchronized(self)
	{
		if (master == nil)
			master = [[self alloc] init];
	}
	
    return master;
}

- (id) init
{
    self = [super init];
    if (self != nil) {
        ABAddressBookRef addressBook;
        addressBook = ABAddressBookCreate();
        
        //Setup Datasource
        dataSource_ = (NSArray*) ABAddressBookCopyArrayOfAllPeople(addressBook);    
        [dataSource_ retain];
        
        //Setup NameDataSource
        nameDataSource_ = [[NSMutableArray arrayWithCapacity:[dataSource_ count]] retain];
        for (int i = 0; i < [dataSource_ count]; i ++) {
            ABRecordRef record = (ABRecordRef*) [dataSource_ objectAtIndex:i];
            NSString *firstname = (NSString*) ABRecordCopyValue(record, kABPersonFirstNameProperty);
            NSString *lastname = (NSString*) ABRecordCopyValue(record, kABPersonLastNameProperty);
            NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
            
            if (firstname != nil) {
                [dictionary setValue:firstname forKey:kFirstName];
            }
            else {
                [dictionary setValue:@"" forKey:kFirstName];
            }
            
            if (lastname != nil) {
                [dictionary setValue:lastname forKey:kLastName];
            }
            else {
                [dictionary setValue:@"" forKey:kLastName];
            }

            [nameDataSource_ addObject:dictionary];
        }
        
    }
    return self;
}

- (NSString*)firstNameAtIndex:(int) index {
    return [[[nameDataSource_ objectAtIndex:index] valueForKey:kFirstName] copy];
}

- (NSString*)lastNameAtIndex:(int) index {
    return [[[nameDataSource_ objectAtIndex:index] valueForKey:kLastName] copy];
}

- (NSString*)nameAtIndex:(int) index {
    return [[NSString stringWithFormat:@"%@ %@",[self firstNameAtIndex:index], [self lastNameAtIndex:index]] copy];
}

- (int) count {
    return [nameDataSource_ count];
}


@end
