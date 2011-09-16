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
#import "TitleNavigationController.h"


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
- (void) viewDidLoad {
    ui = [[AddressBookSelectUI alloc] init];
}
- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

-(IBAction) loadAddressBook {
	UITabBarController *tablController = [[[UITabBarController alloc] init] autorelease];
	
	UIViewController *nameController = [AddressSelectNavigationController navigationController];
	UIViewController *titleConteroller = [TitleNavigationController navigationController];
	
	NSArray *viewControllers = [NSArray arrayWithObjects:nameController,titleConteroller,nil];
	
	tablController.viewControllers = viewControllers;
    [self presentModalViewController:tablController animated:YES];
	
}
    
- (void)peoplePickerNavigationControllerDidCancel:
(ABPeoplePickerNavigationController *)peoplePicker {
    [self dismissModalViewControllerAnimated:YES];
}


- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person {
    
    NSString* name = (NSString *)ABRecordCopyValue(person,
                                                   kABPersonFirstNameProperty);

    [name release];
    
    name = (NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty);

    [name release];
    
//    [self dismissModalViewControllerAnimated:YES];

    UIView *view = peoplePicker.topViewController.view;
    UITableView *tableView = nil;
    for(UIView *uv in view.subviews)
    {
        if([uv isKindOfClass:[UITableView class]])
        {
            tableView = (UITableView*)uv;
            tableView.dataSource = ui;
            tableView.delegate = ui;
            break;
        }
    }
    
    if(tableView != nil)
    {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:[tableView indexPathForSelectedRow]];
        
        cell.accessoryType = cell.accessoryType == UITableViewCellAccessoryNone ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
        
        [cell setSelected:NO animated:YES];
    }
    return NO;
}
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person
                                property:(ABPropertyID)property
                              identifier:(ABMultiValueIdentifier)identifier{
    return NO;
}

@end
