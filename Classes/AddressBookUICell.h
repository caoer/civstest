//
//  AddressBookUICell.h
//  ReOrg
//
//  Created by zitao xiong on 8/25/11.
//  Copyright 2011 nanaimostudio.com. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AddressBookUICell : UITableViewCell {
    BOOL choosed;
}

@property (nonatomic, assign) BOOL choosed;

- (void) toogle;
@end
