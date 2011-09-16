//
//  Title.m
//  ReOrg
//
//  Created by Zitao Xiong on 9/15/11.
//  Copyright 2011 Purdue University Calumet. All rights reserved.
//

#import "Title.h"
#import "NSIndexPath+UtilityExtensions.h"


@implementation Title

@synthesize isSelected;
@synthesize name = name_;
@synthesize abbreviation = abbreviation_;
@synthesize rank = rank_;
@synthesize isMultipleTitle;
@synthesize isAbbr;

- (void)dealloc
{
	[name_ release];
	name_ = nil;
	[abbreviation_ release];
	abbreviation_ = nil;
	[rank_ release];
	rank_ = nil;


	[super dealloc];
}

+(id) titleWithDesignedArray:(NSArray*) array {
	Title *title = [[[Title alloc] init] autorelease];
	title.rank = [[NSIndexPath indexPathWithString:[array objectAtIndex:0]] retain];
	title.name = [[array objectAtIndex:1] copy];
	title.abbreviation = [[array objectAtIndex:2] copy];
	if ([@"Y" isEqualToString:[array objectAtIndex:3]]) {
		title.isMultipleTitle = YES;
	}
	if ([@"Y" isEqualToString:[array objectAtIndex:4]]) {
		title.isAbbr = YES;
	}
	return title;
}

-(NSString *) description {
	return [NSString stringWithFormat:@"title:%@, abbr:%@, rank:%@, isMulti:%d, isAbbr:%d", name_, abbreviation_, [rank_ stringByJoinComma], isMultipleTitle, isAbbr];
}

-(void) toogleSelect {
	if (isSelected) {
		isSelected = NO;
	}
	else {
		isSelected = YES;
	}

}

-(NSString *) title {
	if (isAbbr) {
		return [[abbreviation_ copy] autorelease];
	}
	else {
		return [[name_ copy] autorelease];
	}

}
@end
