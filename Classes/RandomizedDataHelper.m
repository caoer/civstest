//
//  RandomizedDataHelper.m
//  ReOrg
//
//  Created by Zitao Xiong on 9/15/11.
//  Copyright 2011 Purdue University Calumet. All rights reserved.
//

#import "RandomizedDataHelper.h"
#import "AddressBookDataSource.h"
#import "TitleDataSources.h"

@implementation RandomizedDataHelper

@synthesize datasource = datasource_;

- (void)dealloc
{
	[datasource_ release];
	datasource_ = nil;

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

- (void) shuffle {
	if (datasource_ != nil) {
		[datasource_ release];
		datasource_ = nil;
	}
	
	datasource_ = [[NSMutableArray array] retain];
	
	
}

@end
