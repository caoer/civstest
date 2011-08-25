//
//  NSIndexPath+UtilityExtensions.h
//  Word Tracer
//
//  Created by Zitao Xiong on 7/10/11.
//  Copyright 2011 Purdue University Calumet. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSIndexPath(UtilityExtensions)

@property (readonly, getter = stringByJoinComma) NSString* stringValue;
+(NSIndexPath*) indexPathWithString:(NSString*) stringValue;
+(NSIndexPath*) indexPathWithInt:(int) count, ...;
@end
