//
//  SearchDisplayController.m
//
//  Created by Zitao Xiong on 7/12/11.
//  Copyright 2011 Purdue University Calumet. All rights reserved.
//

#import "SearchDisplayController.h"
#import "NSIndexPath+UtilityExtensions.h"

#define kNameKey @"name"
#define kIndexKey @"index"
@implementation SearchDisplayController

@synthesize searchResultArray = searchResultArray_;
@synthesize datasource = datasource_;


- (void)dealloc
{

	[searchResultArray_ release];
	searchResultArray_ = nil;

	[super dealloc];
}
-(id) initWithSearchBar:(UISearchBar *)searchBar contentsController:(UIViewController *)viewController {
	if ((self = [super initWithSearchBar:searchBar contentsController:viewController])) {
		datasource_ = [AddressBookDataSource sharedInstance];
	}
	return self;
}

#pragma mark -
#pragma mark UISearchDisplayControllerDelegate
-(BOOL) searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
	[searchResultArray_ release];
	searchResultArray_ = nil;
    searchResultArray_ = [[NSMutableArray array] retain];
    for (int i = 0; i < [[[AddressBookDataSource sharedInstance] nameDataSource] count]; i ++) {
        NSString *name = [[AddressBookDataSource sharedInstance] nameAtIndex:i];
        if ([name rangeOfString:searchString options:NSCaseInsensitiveSearch].location != NSNotFound
            ) {
            [searchResultArray_ addObject:
             [NSDictionary dictionaryWithObjectsAndKeys:
              name, kNameKey, 
              [NSNumber numberWithInt:i], kIndexKey,
              nil]];
        }
    }
	return YES;
}
-(void) searchDisplayController:(UISearchDisplayController *)controller willShowSearchResultsTableView:(UITableView *)aTableView {

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
	
    NSDictionary *dic = [searchResultArray_ objectAtIndex:indexPath.row];
    [[cell textLabel] setText:[dic valueForKey:kNameKey]];
	[cell setAccessoryType:UITableViewCellAccessoryNone];
	
	
	//    UIImage *indicatorImage = [UIImage imageNamed:@"cell_indicator.png"];
	//    cell.accessoryView = [[[UIImageView alloc] initWithImage:indicatorImage] autorelease];
	//    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    return cell;
} 
#pragma mark -
#pragma mark TableViewDelegate

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

@end
