//
//  CustomABPeoplePickerController.h
//  ReOrg
//
//  Created by zitao xiong on 8/28/11.
//  Copyright 2011 nanaimostudio.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBookUI/AddressBookUI.h>
@interface CustomABPeoplePickerController : ABPeoplePickerNavigationController<UITableViewDataSource,UITableViewDelegate,ABPeoplePickerNavigationControllerDelegate> {
    id originalDataDelegate_;
    id originalDataSource_;
    UITableView *personTableView_;
    NSMutableArray *selectedIndexPathes_;
}

@property (nonatomic, retain) NSMutableArray *selectedIndexPathes;
@end


