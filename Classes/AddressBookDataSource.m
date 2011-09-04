//
//  AddressBookDataSource.m
//  ReOrg
//
//  Created by zitao xiong on 8/23/11.
//  Copyright 2011 nanaimostudio.com. All rights reserved.
//

#import "AddressBookDataSource.h"

#define kSectionTitleKey @"sectionTitle"
#define kSectionValueKey @"sectionValue"
#define kSelectedKey @"isSelected"

@implementation AddressBookDataSource

@synthesize contactDataSource = contactDataSource_;
@synthesize nameDataSource = nameDataSource_;
@synthesize dataSource = dataSource_;

- (void)dealloc
{
    DLOG(@"Error: try to dealloc sharedInstance!");
	[dataSource_ release];
	dataSource_ = nil;

	[nameDataSource_ release];
	nameDataSource_ = nil;

	[contactDataSource_ release];
	contactDataSource_ = nil;

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
    return [NSString stringWithFormat:@"%@ %@",[self firstNameAtIndex:index], [self lastNameAtIndex:index]];
}

- (int) count {
    return [nameDataSource_ count];
}

- (NSMutableArray*) alphabetArray {
    NSMutableArray *alphabetArray_ = [NSMutableArray array];
    [alphabetArray_ addObject:@"{search}"];
    for (int i = 0; i < 26; i++) {
        NSString *key = [[NSString stringWithFormat:@"%c", i+97] uppercaseString];
        [alphabetArray_ addObject:key];
    }
    [alphabetArray_ addObject:@"#"];
    return alphabetArray_;
}

- (NSArray*) arrayStartIgnoreCaptionWith:(NSString*) firstLetter inArray:(NSArray*) array byNameKey:(NSString*) nameKey{
    NSIndexSet* indexSet = [array indexesOfObjectsPassingTest:^(id obj, NSUInteger idx, BOOL *stop) {
        NSDictionary *nameDict = (NSDictionary*) obj;
        NSString *name = [nameDict valueForKey:nameKey];
        if ([name hasPrefix:firstLetter] || [name hasPrefix:[firstLetter lowercaseString]]) {
            return YES;
        }
        else {
            return NO;
        }
    }];
    
    NSArray *result = [array objectsAtIndexes:indexSet];
    NSMutableArray *resultPeople = [NSMutableArray arrayWithCapacity:[result count]];
    
    for (NSDictionary *nameDict in result) {
        Person *person = [[Person alloc] init];
        person.firstName = [nameDict valueForKey:kFirstName];
        person.lastName = [nameDict valueForKey:kLastName];
        [resultPeople addObject:person];
        [person release];
    }
    return resultPeople;
}

-(NSMutableArray *) contactDataSource {
    if (contactDataSource_ == nil) {
        contactDataSource_ = [[NSMutableArray array] retain];
        
        /**
         *  dataSourceArray-> sectionDictionary-> SectionTitle
         *                                     -> SectionArray -> Peoples
         *
         *  sectionTitles_-> sectionDictionary -> SectionTitle
         *                                     -> 
         *
         **/
        
        for (int i = 0; i < [[self alphabetArray] count]; i++) {
            NSMutableDictionary *contactSection = [NSMutableDictionary dictionary];
            
            NSString *key = [[self alphabetArray] objectAtIndex:i];
            [contactSection setObject:key forKey:kSectionTitleKey];
            NSArray *contactArray = [self arrayStartIgnoreCaptionWith:key inArray:[[AddressBookDataSource sharedInstance] nameDataSource] byNameKey:kFirstName];
            [contactSection setObject:contactArray forKey:kSectionValueKey];
            
            if ([contactArray count] != 0) {
                [contactDataSource_ addObject:contactSection];
            }
        }
        
        NSArray *allArray = [[AddressBookDataSource sharedInstance] nameDataSource];
        NSMutableArray *unicodeArray = [NSMutableArray array];
        for (int i = 0; i < [allArray count]; i++) {
            NSDictionary *nameDict = [allArray objectAtIndex:i];
            
            if ([[nameDict valueForKey:kFirstName] length] == 0) {
                continue;
            }
            
            NSUInteger firstChar = [[nameDict valueForKey:kFirstName] characterAtIndex:0] ;
            if (
                !(
                  (firstChar> 65 && firstChar <91)
                  ||
                  (firstChar> 71 && firstChar <123)
                  )
                )//that not in ABCDEFGHIJKLMNOPQRSTUVWXYZ
            {
                Person *person = [[Person alloc] init];
                person.firstName = [nameDict valueForKey:kFirstName];
                person.lastName = [nameDict valueForKey:kLastName];
                [unicodeArray addObject:person];
                [person release];
            }
            
        }
        
        [unicodeArray sortUsingDescriptors:[NSArray arrayWithObject:[[NSSortDescriptor alloc] initWithKey:@"firstName" ascending:YES]]];
        
        [contactDataSource_ addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                       unicodeArray, kSectionValueKey,
                                       @"#", kSectionTitleKey,nil]];
    }
    return contactDataSource_;
}

- (NSInteger)numberOfSections {
    return [self.contactDataSource count];
}

- (NSInteger)numberOfRowsInSection:(NSInteger) section {
    return [[[self.contactDataSource objectAtIndex:section] valueForKey:kSectionValueKey] count];
}

- (NSArray*) arrayAtSection:(NSInteger) section {
    return [[self.contactDataSource objectAtIndex:section] valueForKey:kSectionValueKey];
}

- (NSString*) keyAtSection:(NSInteger) section {
    return [[self.contactDataSource objectAtIndex:section] valueForKey:kSectionTitleKey];
}

-(Person *) personForIndexPath:(NSIndexPath *)indexPath {
    NSArray *contactArray = [self arrayAtSection:indexPath.section];
    Person *person = [contactArray objectAtIndex:indexPath.row];
    return person;
}
@end
