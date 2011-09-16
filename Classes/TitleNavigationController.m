//
//  TitleNavigationController.m
//  ReOrg
//
//  Created by Zitao Xiong on 9/15/11.
//  Copyright 2011 Purdue University Calumet. All rights reserved.
//

#import "TitleNavigationController.h"
#import "TitleTableViewController.h"

@implementation TitleNavigationController

+ (id) navigationController {
	TitleTableViewController *viewController = [[TitleTableViewController alloc] initWithStyle:UITableViewStylePlain];
	
	viewController.title = @"TITLES";
	
	TitleNavigationController *navgationController = [[[TitleNavigationController alloc] initWithRootViewController:viewController] autorelease];
	
	[viewController.navigationItem setLeftBarButtonItem:
     [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel 
                                                    target:navgationController
                                                    action:@selector(cancel:)] autorelease]];
    
    [viewController.navigationItem setRightBarButtonItem:
     [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave 
                                                    target:navgationController
                                                    action:@selector(save:)] autorelease]];
	[viewController release];
	
	return navgationController;
	
}

- (void)cancel:(id) sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (void)save:(id) sender {
    [self dismissModalViewControllerAnimated:YES];
}

@end
