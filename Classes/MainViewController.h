//
//  MainViewController.h
//  ReOrg
//
//  Created by zitao xiong on 8/23/11.
//  Copyright 2011 nanaimostudio.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

#import "AddressBookSelectUI.h"

@interface MainViewController : UIViewController <ABPeoplePickerNavigationControllerDelegate> {
    AddressBookSelectUI *ui;
}

-(IBAction) loadAddressBook;
@end
