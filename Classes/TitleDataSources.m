//
//  TitileDataSources.m
//  ReOrg
//
//  Created by Zitao Xiong on 9/15/11.
//  Copyright 2011 Purdue University Calumet. All rights reserved.
//

#import "TitleDataSources.h"


@implementation TitleDataSources
- (void) dealloc {
	NSAssert(NO,@"Error: try to dealloc sharedInstance!");
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
		datasources_ = [[NSMutableArray array] retain];
		
		NSArray *titleArray = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"titles" ofType:@"plist"]];
		
		for (int i = 0; i < [titleArray count]; i ++) {
			NSArray *titleSource = [titleArray objectAtIndex:i];
			Title *title = [Title titleWithDesignedArray:titleSource];
			[datasources_ addObject:title];
		}
		NSLog(@"%@", [datasources_ description]);

	}
	return self;
}

-(NSUInteger) count {
	return [datasources_ count];
}

-(Title* ) titleAtIndex:(int)index {
	return [datasources_ objectAtIndex:index];
}
@end
