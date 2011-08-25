//
//  NSIndexPath+UtilityExtensions.m
//  Word Tracer
//
//  Created by Zitao Xiong on 7/10/11.
//  Copyright 2011 Purdue University Calumet. All rights reserved.
//

#import "NSIndexPath+UtilityExtensions.h"


@implementation NSIndexPath (UtilityExtensions)
-(NSString*) stringByJoinComma {
	if ([self length] == 0) {
		return @"";
	}
	NSString *string = @"";
	for (int i = 0; i < [self length]; i++) {
		string = [string stringByAppendingFormat:@",%d",[self indexAtPosition:i]];
	}
	string = [string substringFromIndex:1];
	return string;
}
+(NSIndexPath*) indexPathWithString:(NSString*) stringValue {
	NSArray *compoents = [stringValue componentsSeparatedByString:@","];
	NSIndexPath *indexPath = [[[NSIndexPath alloc] init] autorelease];
	if ([compoents count] == 0) {
		return nil;
	}
	for (int i = 0; i < [compoents count]; i++) {
		NSString *stringNumber = [compoents objectAtIndex:i];
		indexPath = [indexPath indexPathByAddingIndex:[stringNumber intValue]];
	}
	return indexPath;
}
+(NSIndexPath*) indexPathWithInt:(int) firstObject, ... {
	id eachObject;
	va_list argumentList;
	NSString *stringValue = @""; 

	stringValue = [stringValue stringByAppendingFormat:@",%d",firstObject]; // that isn't nil, add it to self's contents.
	va_start(argumentList, firstObject); // Start scanning for arguments after firstObject.
	while ((eachObject = va_arg(argumentList, id))!=[NSNull null]) // As many times as we can get an argument of type "id"
		stringValue = [stringValue stringByAppendingFormat:@",%d",eachObject]; // that isn't nil, add it to self's contents.
	va_end(argumentList);
	stringValue = [stringValue substringFromIndex:1];
	return [NSIndexPath indexPathWithString:stringValue];
}
@end
