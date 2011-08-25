//
//  SearchDisplayController.m
//
//  Created by Zitao Xiong on 7/12/11.
//  Copyright 2011 Purdue University Calumet. All rights reserved.
//

#import "SearchDisplayController.h"
#import "NSIndexPath+UtilityExtensions.h"

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
	
    [[cell textLabel] setText:@""];
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
