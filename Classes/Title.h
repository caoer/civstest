//
//  Title.h
//  ReOrg
//
//  Created by Zitao Xiong on 9/15/11.
//  Copyright 2011 Purdue University Calumet. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
Rank	
Title	
Abbreviations	
Multiple Titles?	
Use Abbreviation as Default
**/
@interface Title : NSObject {
	NSString *name_;
	NSString *abbreviation_;
	NSIndexPath *rank_;
	BOOL isMultipleTitle;
	BOOL isAbbr;
	
	BOOL isSelected;
}

@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *abbreviation;
@property (nonatomic, retain) NSIndexPath *rank;
@property (nonatomic, assign) BOOL isMultipleTitle;
@property (nonatomic, assign) BOOL isAbbr;
@property (nonatomic, readonly) NSString *title;

+(id) titleWithDesignedArray:(NSArray *)array;

-(void) toogleSelect;
@end
