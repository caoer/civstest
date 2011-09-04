//
//  AddressBookSelectUI.m
//  ReOrg
//
//  Created by zitao xiong on 8/23/11.
//  Copyright 2011 nanaimostudio.com. All rights reserved.
//

#import "AddressBookSelectUI.h"
#import "AddressBookDataSource.h"
#import "AddressBookUICell.h"
#import "Person.h"

#define kSectionTitleKey @"sectionTitle"
#define kSectionValueKey @"sectionValue"
#define kSelectedKey @"isSelected"

@implementation AddressBookSelectUI

@synthesize contactDataSource = contactDataSource_;
@synthesize searchDisplayController = searchDisplayController_;
@synthesize searchBar = searchBar_;

#pragma mark -
#pragma mark Memory management
- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)cleanUp {
    
    [searchDisplayController_ release];
	searchDisplayController_ = nil;
    
	[searchBar_ release];
	searchBar_ = nil;
    
    [contactDataSource_ release];
	contactDataSource_ = nil;
    
    
}

- (void)viewDidUnload {
    [self cleanUp];
}


- (void)dealloc {
    [self cleanUp];

    [super dealloc];
}


#pragma mark -
#pragma mark Initialization
-(void) setupSearchDisaplayController {
	searchBar_ = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 304, 44)];
	searchBar_.tintColor = globalBarTintColor();
	searchDisplayController_ = [[SearchDisplayController alloc] initWithSearchBar:searchBar_ contentsController:self];
	searchDisplayController_.delegate = searchDisplayController_;
	searchDisplayController_.searchResultsDataSource = searchDisplayController_;
	searchDisplayController_.searchResultsDelegate = searchDisplayController_;
	searchDisplayController_.addressBookSelectUIDelegate = self;
    
	[self.tableView setTableHeaderView:searchBar_];
	
}

- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {

    }
    return self;
}



#pragma mark -
#pragma mark DataSource
-(NSMutableArray *) contactDataSource {
    return [[AddressBookDataSource sharedInstance] contactDataSource];
}

-(Person *) personForIndexPath:(NSIndexPath*) indexPath {
    return [[AddressBookDataSource sharedInstance] personForIndexPath:indexPath];
}

#pragma mark -
#pragma mark View lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setupSearchDisaplayController];
    [self.tableView setContentOffset:CGPointMake(0, 44)];
}

#pragma mark -
#pragma mark Table view data source
-(NSArray *) sectionIndexTitlesForTableView:(UITableView *)tableView {
    return [[AddressBookDataSource sharedInstance] alphabetArray];
}

-(NSInteger) tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)aTitle atIndex:(NSInteger)index {
    if ([aTitle isEqualToString:@"{search}"]) {
        [self.tableView setContentOffset:CGPointMake(0, 0)];
        return -1;
    }

    for (int i = 0; i < [self.contactDataSource count]; i ++) {
        NSDictionary *dic = [self.contactDataSource objectAtIndex:i];
        NSString *key = [dic valueForKey:kSectionTitleKey];
        if ([key isEqualToString:aTitle]) {
            return i;
        }
    }
    return [self.contactDataSource count];
}

-(NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [[self.contactDataSource objectAtIndex:section] valueForKey:kSectionTitleKey];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return [[AddressBookDataSource sharedInstance] numberOfSections];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return  [[AddressBookDataSource sharedInstance] numberOfRowsInSection:section];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"ADDRESSBOOKCELL";
    
    AddressBookUICell *cell =  (AddressBookUICell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[AddressBookUICell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.backgroundColor = [UIColor clearColor];
    }
    
    Person *person = [self personForIndexPath:indexPath];
    
    cell.textLabel.text = person.fullName;
    
    if (person.selected) {
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    }
    else {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }

    return cell;
}


#pragma mark -
#pragma mark Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Person *person = [[AddressBookDataSource sharedInstance] personForIndexPath:indexPath];
    [person toogle];
     
    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}




@end

