//
//  SearchDisplayController.m
//
//  Created by Zitao Xiong on 7/12/11.
//  Copyright 2011 Purdue University Calumet. All rights reserved.
//

#import "SearchDisplayController.h"
#import "NSIndexPath+UtilityExtensions.h"
#import "AddressBookSelectUI.h"
#import "Person.h"

#define kNameKey @"name"
#define kIndexKey @"index"
@implementation SearchDisplayController

@synthesize addressBookSelectUIDelegate = addressBookSelectUIDelegate_;
@synthesize searchResultArray = searchResultArray_;


- (void)dealloc
{

	[searchResultArray_ release];
	searchResultArray_ = nil;

	[super dealloc];
}

-(id) initWithSearchBar:(UISearchBar *)searchBar contentsController:(UIViewController *)viewController {
	if ((self = [super initWithSearchBar:searchBar contentsController:viewController])) {

	}
	return self;
}

#pragma mark -
#pragma mark UISearchDisplayControllerDelegate
-(BOOL) searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
	[searchResultArray_ release];
	searchResultArray_ = nil;
    searchResultArray_ = [[NSMutableArray array] retain];
    for (int i = 0; i < [addressBookSelectUIDelegate_ numberOfSectionsInTableView:nil]; i ++) {
        for (int j = 0; j < [addressBookSelectUIDelegate_ tableView:nil numberOfRowsInSection:i]; j ++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:j inSection:i];
            Person *person = [addressBookSelectUIDelegate_ personForIndexPath:indexPath];
            NSString *name = person.fullName;
            if ([name rangeOfString:searchString options:NSCaseInsensitiveSearch].location != NSNotFound) {
                [searchResultArray_ addObject:person];
            }
        }
    }
	return YES;
}

-(void) searchDisplayController:(UISearchDisplayController *)controller willShowSearchResultsTableView:(UITableView *)aTableView {

}

-(void) searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller {
    [[addressBookSelectUIDelegate_ tableView] reloadData];
}
#pragma mark -
#pragma mark Table View Data Source

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [searchResultArray_ count];

}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"DetailCategory";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, 304, 44) reuseIdentifier:cellIdentifier] autorelease];     
    }
	

    Person *person = [searchResultArray_ objectAtIndex:indexPath.row];
    [[cell textLabel] setText:person.fullName];
    if (person.selected) {
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    }
    else {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    
	//    UIImage *indicatorImage = [UIImage imageNamed:@"cell_indicator.png"];
	//    cell.accessoryView = [[[UIImageView alloc] initWithImage:indicatorImage] autorelease];
	//    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    return cell;
} 

#pragma mark -
#pragma mark TableViewDelegate

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Person *person = [searchResultArray_ objectAtIndex:indexPath.row];
    [person toogle];
    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

@end
