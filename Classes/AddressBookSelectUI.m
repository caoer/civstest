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

#define kSectionTitleKey @"sectionTitle"
#define kSectionValueKey @"sectionValue"
#define kSelectedKey @"isSelected"

@implementation AddressBookSelectUI

@synthesize sectionTitles = sectionTitles_;
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
    
	[sectionTitles_ release];
	sectionTitles_ = nil;
    
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
	
	[self.tableView setTableHeaderView:searchBar_];
	
}

- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        [self setupDataSource];

    }
    return self;
}



#pragma mark -
#pragma mark DataSource

- (void)setupDataSource {
    contactDataSource_ = [[NSMutableArray array] retain];
    
    sectionTitles_ = [[NSMutableArray array] retain];
    
    for (int i = 0; i < 26; i++) {
        NSString *key = [[NSString stringWithFormat:@"%c", i+97] capitalizedString];
        [sectionTitles_ addObject:key];
    }
    
    NSMutableArray *removeArray = [NSMutableArray array];
    
    for (int i = 0; i < [sectionTitles_ count]; i++) {
        NSString *key = [sectionTitles_ objectAtIndex:i];
        NSMutableDictionary *contactSection = [NSMutableDictionary dictionary];
        [contactSection setObject:key forKey:kSectionTitleKey];
        
        NSArray *contactArray = [self arrayStartIgnoreCaptionWith:key inArray:[[AddressBookDataSource sharedInstance] nameDataSource] byNameKey:kFirstName];
        [contactSection setObject:contactArray forKey:kSectionValueKey];
        
        if ([contactArray count] != 0) {
            [contactDataSource_ addObject:contactSection];
        }
        else {
            [removeArray addObject:key];
        }
    }
    
    [sectionTitles_ removeObjectsInArray:removeArray];
}



- (NSArray*) arrayStartIgnoreCaptionWith:(NSString*) firstLetter inArray:(NSArray*) array byNameKey:(NSString*) nameKey{
    NSIndexSet* indexSet = [array indexesOfObjectsPassingTest:^(id obj, NSUInteger idx, BOOL *stop) {
        //NSAssert1([obj isKindOfClass:[NSDictionary class]], @"%@ is not a NSDictionary", [obj class]);
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
    return result;
}

-(NSArray*) contactArrayAtSection:(int) section {
    return [[self.contactDataSource objectAtIndex:section] valueForKey:kSectionValueKey];
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
    //[self.tableView setBackgroundColor:[UIColor greenColor]];
}

#pragma mark -
#pragma mark Table view data source
-(NSArray *) sectionIndexTitlesForTableView:(UITableView *)tableView {
    NSMutableArray *sectionTitleArray = [NSMutableArray array];
    for (int i = 0; i<26; i++) {
        NSString *letter = [[NSString stringWithFormat:@"%c",i+97] capitalizedString];
        [sectionTitleArray addObject:letter];
    }
    return sectionTitleArray;
}
-(NSInteger) tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)aTitle atIndex:(NSInteger)index {
    int count = 0; //used for avoid error;
    TTDINFO(@":%@",aTitle);
    while (![self.sectionTitles containsObject:aTitle]) {
        aTitle = [NSString stringWithFormat:@"%c", [aTitle characterAtIndex:0] +1];
        
        count ++;
        if (count > [[self sectionTitles] count]) {
            DLOG(@"can't find match in sectionTitles");
            return [self.sectionTitles count] -1;
        }
    }
    TTDINFO(@"%d:%@", [[self sectionTitles] indexOfObject:aTitle], aTitle);
    return [[self sectionTitles] indexOfObject:aTitle];
}

-(NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [[self.contactDataSource objectAtIndex:section] valueForKey:kSectionTitleKey];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return [self.contactDataSource count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return  [[self contactArrayAtSection:section] count];
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
    
    NSArray *contactArray = [self contactArrayAtSection:indexPath.section];
    NSDictionary *cellDict = [contactArray objectAtIndex:indexPath.row];
    BOOL selected = [[cellDict valueForKey:kSelectedKey] boolValue];

    cell.textLabel.text = [cellDict valueForKey:kFirstName];
    
    if (selected) {
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
    
    NSDictionary *choosedDict = [[self contactArrayAtSection:indexPath.section] objectAtIndex:indexPath.row];
    BOOL selected = [[choosedDict valueForKey:kSelectedKey] boolValue];
    [choosedDict setValue:[NSNumber numberWithBool:!selected] forKey:kSelectedKey];
     
    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}




@end

