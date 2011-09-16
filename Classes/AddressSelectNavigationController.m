//
//  AddressSelectNavigationController.m
//  ReOrg
//
//  Created by zitao xiong on 8/25/11.
//  Copyright 2011 nanaimostudio.com. All rights reserved.
//

#import "AddressSelectNavigationController.h"
#import "AddressBookSelectUI.h"

@implementation AddressSelectNavigationController

+ (id)navigationController {
    AddressBookSelectUI *viewController = [[AddressBookSelectUI alloc] init];
	AddressSelectNavigationController *navController = [[[AddressSelectNavigationController alloc] initWithRootViewController:viewController] autorelease];
    
    [[navController navigationBar] setTintColor:globalBarTintColor()];
    
    [viewController.navigationItem setLeftBarButtonItem:
     [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel 
                                                    target:navController
                                                    action:@selector(cancel:)] autorelease]];
    
    [viewController.navigationItem setRightBarButtonItem:
     [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave 
                                                    target:navController
                                                    action:@selector(save:)] autorelease]];
	viewController.title = @"NAMES";
    
    [viewController release];
    return navController;
}

- (void)cancel:(id) sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (void)save:(id) sender {
    [self dismissModalViewControllerAnimated:YES];
}
@end
