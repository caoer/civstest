//
//  SearchDisplayController.h
//
//  Created by Zitao Xiong on 7/12/11.
//  Copyright 2011 Purdue University Calumet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "AddressBookDataSource.h"

@interface SearchDisplayController : UISearchDisplayController<UITableViewDelegate,UITableViewDataSource,UISearchDisplayDelegate> {
	NSMutableArray *searchResultArray_;
	AddressBookDataSource *datasource_;
}

@property (nonatomic, retain) NSMutableArray *searchResultArray;
@property (nonatomic, retain) AddressBookDataSource *datasource;

@end
