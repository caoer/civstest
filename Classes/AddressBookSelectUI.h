//
//  AddressBookSelectUI.h
//  ReOrg
//
//  Created by zitao xiong on 8/23/11.
//  Copyright 2011 nanaimostudio.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchDisplayController.h"
#import "Person.h"

@interface AddressBookSelectUI : UITableViewController {
	SearchDisplayController *searchDisplayController_;
	UISearchBar *searchBar_;
    NSMutableArray *contactDataSource_;
    
    NSMutableArray *choosedArray;
}

@property (nonatomic, retain) NSMutableArray *contactDataSource;
@property (nonatomic, retain) SearchDisplayController *searchDisplayController;
@property (nonatomic, retain) UISearchBar *searchBar;

-(Person *) personForIndexPath:(NSIndexPath*) indexPath;
@end
