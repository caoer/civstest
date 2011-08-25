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
    
    [viewController.navigationItem setRightBarButtonItem:
     [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:navController action:@selector(done:)]];
    [viewController release];
    return navController;
}
- (void)done:(id) sender {
    [self dismissModalViewControllerAnimated:YES];
}
@end
