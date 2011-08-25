//
//  MainViewController.m
//  ReOrg
//
//  Created by zitao xiong on 8/23/11.
//  Copyright 2011 nanaimostudio.com. All rights reserved.
//

#import "MainViewController.h"
#import "AddressBookDataSource.h"
#import "AddressBookSelectUI.h"
#import "AddressSelectNavigationController.h"

@implementation MainViewController

#pragma mark Memory Management
- (void)cleanUp {
    
}
- (void)dealloc {
    [self cleanUp];
    [super dealloc];
}

- (void)viewDidUnload {
    [self cleanUp];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

-(IBAction) loadAddressBook {
    AddressSelectNavigationController *addressUI = [AddressSelectNavigationController navigationController];
    [self presentModalViewController:addressUI animated:YES];
}
    
- (void)peoplePickerNavigationControllerDidCancel:
(ABPeoplePickerNavigationController *)peoplePicker {
    [self dismissModalViewControllerAnimated:YES];
}


- (BOOL)peoplePickerNavigationController:
(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person {
    
    NSString* name = (NSString *)ABRecordCopyValue(person,
                                                   kABPersonFirstNameProperty);

    [name release];
    
    name = (NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty);

    [name release];
    
//    [self dismissModalViewControllerAnimated:YES];
    
    return YES;
}
- (BOOL)peoplePickerNavigationController:
(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person
                                property:(ABPropertyID)property
                              identifier:(ABMultiValueIdentifier)identifier{
    return YES;
}

@end
