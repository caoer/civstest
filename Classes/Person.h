//
//  Person.h
//  ReOrg
//
//  Created by zitao xiong on 9/2/11.
//  Copyright 2011 nanaimostudio.com. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Person : NSObject {
    NSString *firstName_;
    NSString *lastName_;
    BOOL selected;
}

@property (nonatomic, copy) NSString *firstName;
@property (nonatomic, copy) NSString *lastName;
@property (nonatomic, assign) BOOL selected;

@property (nonatomic, readonly) NSString *fullName;
-(void) toogle;
@end
