//
//  Person.m
//  ReOrg
//
//  Created by zitao xiong on 9/2/11.
//  Copyright 2011 nanaimostudio.com. All rights reserved.
//

#import "Person.h"
#import "Title.h"

@implementation Person

@synthesize title = title_;
@synthesize firstName = firstName_;
@synthesize lastName = lastName_;
@synthesize fullName;
@synthesize selected;

- (void)dealloc
{
	[firstName_ release];
	firstName_ = nil;
	[lastName_ release];
	lastName_ = nil;

	[title_ release];
	title_ = nil;

	[super dealloc];
}

-(NSString *) fullName {
    return [NSString stringWithFormat:@"%@ %@", self.firstName, self.lastName];
}

-(void) toogle {
    if (!selected) {
        selected = YES;
    }
    else {
        selected = NO;
    }

}
@end
