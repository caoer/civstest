//
//  AddressBookSelectUI.h
//  ReOrg
//
//  Created by zitao xiong on 8/23/11.
//  Copyright 2011 nanaimostudio.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchDisplayController.h"

@interface AddressBookSelectUI : UITableViewController {
	SearchDisplayController *searchDisplayController_;
	UISearchBar *searchBar_;
    NSMutableArray *contactDataSource_;
    
    NSMutableArray *sectionTitles_;
}

@property (nonatomic, retain) NSMutableArray *sectionTitles;
@property (nonatomic, retain) NSMutableArray *contactDataSource;
@property (nonatomic, retain) SearchDisplayController *searchDisplayController;
@property (nonatomic, retain) UISearchBar *searchBar;

- (void)setupDataSource;
- (NSArray*) arrayStartIgnoreCaptionWith:(NSString*) firstLetter inArray:(NSArray*) array byNameKey:(NSString*) nameKey;
@end
