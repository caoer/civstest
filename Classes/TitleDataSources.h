//
//  TitileDataSources.h
//  ReOrg
//
//  Created by Zitao Xiong on 9/15/11.
//  Copyright 2011 Purdue University Calumet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Title.h"

@interface TitleDataSources : NSObject {
	NSMutableArray *datasources_;
}

+(id) sharedInstance;

-(NSUInteger) count;
-(Title*) titleAtIndex:(int)index;
@end
