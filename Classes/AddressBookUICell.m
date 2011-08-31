//
//  AddressBookUICell.m
//  ReOrg
//
//  Created by zitao xiong on 8/25/11.
//  Copyright 2011 nanaimostudio.com. All rights reserved.
//

#import "AddressBookUICell.h"


@implementation AddressBookUICell

@synthesize choosed;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
}

- (void) toogle {
    if (!choosed) {
        choosed = YES;
    }
    else {
        choosed = NO;
    }
}
- (void)dealloc {

    [super dealloc];
}


@end
