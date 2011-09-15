//
//  AddressSelectNavigationController.m
//  ReOrg
//
//  Created by zitao xiong on 8/25/11.
//  Copyright 2011 nanaimostudio.com. All rights reserved.
//

#import "AddressSelectNavigationController.h"
#import "AddressBookSelectUI.h"
#import "NameTitleViewController.h"

@implementation AddressSelectNavigationController

+ (id)navigationController {
    //AddressBookSelectUI *viewController = [[AddressBookSelectUI alloc] init];
    AddressSelectNavigationController *navController = [[[AddressSelectNavigationController alloc] initWithNibName:@"AddressSelectNavigationController"
                                                                                                            bundle:nil] autorelease];
    
    NameTitleViewController *nameTitleController = [[[NameTitleViewController alloc] initWithNibName:@"NameTitleViewController" bundle:nil] autorelease];
    [navController pushViewController:nameTitleController animated:NO];
    [[navController navigationBar] setTintColor:globalBarTintColor()];
    
    [nameTitleController.navigationItem setLeftBarButtonItem:
     [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel 
                                                    target:navController
                                                    action:@selector(cancel:)] autorelease]];
    
    [nameTitleController.navigationItem setRightBarButtonItem:
     [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave 
                                                    target:navController
                                                    action:@selector(save:)] autorelease]];
    
    //[viewController release];
    return navController;
}

- (void)cancel:(id) sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (void)save:(id) sender {
    [self dismissModalViewControllerAnimated:YES];
}
@end
