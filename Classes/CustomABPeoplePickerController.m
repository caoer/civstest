//
//  CustomABPeoplePickerController.m
//  ReOrg
//
//  Created by zitao xiong on 8/28/11.
//  Copyright 2011 nanaimostudio.com. All rights reserved.
//

#import "CustomABPeoplePickerController.h"
#import <AddressBook/AddressBook.h>
#import "NSObject+UtilityExtensions.h"

@implementation CustomABPeoplePickerController

@synthesize selectedIndexPathes = selectedIndexPathes_;

- (void)dealloc
{
	[selectedIndexPathes_ release];
	selectedIndexPathes_ = nil;

	[super dealloc];
}

-(void) viewWillAppear:(BOOL)animated {
    UIView *view = self.topViewController.view;
    UITableView *tableView = nil;
    for(UIView *uv in view.subviews)
    {
        DLOG(@"not found");
        if([uv isKindOfClass:[UITableView class]])
        {
            DLOG(@"found");
            tableView = (UITableView*)uv;
            personTableView_ = tableView;
            originalDataSource_ = personTableView_.dataSource;
            originalDataDelegate_ = personTableView_.delegate;
            personTableView_.dataSource = self;
            personTableView_.delegate = self;
            selectedIndexPathes_ = [[NSMutableArray array] retain];
            break;
        }
        DLOG(@"%@",[view class]);
    }
    for (UIView *uv in personTableView_.subviews) {
        if ([uv isKindOfClass:[UISearchDisplayController class]]) {
            DLOG(@"search bar");
        }
    }
    [self.topViewController.navigationItem setHidesBackButton:YES animated:YES];
}
#pragma mark -
#pragma mark Data Source
-(NSInteger) tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    NSLog(@"%@",title);
    return [originalDataSource_ tableView:tableView sectionForSectionIndexTitle:title atIndex:index];
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger count = [originalDataSource_ numberOfSectionsInTableView:tableView];
    return count;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [originalDataSource_ tableView:tableView cellForRowAtIndexPath:indexPath];
    if ([selectedIndexPathes_ containsObject:indexPath]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }

    //DLOG(@"%@,%@",[cell class] ,[cell description]);
    return cell;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [originalDataSource_ tableView:tableView numberOfRowsInSection:section];
}

-(NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [originalDataSource_ tableView:tableView titleForHeaderInSection:section];
}

-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    DLOG(@"%@,%@",[cell class] ,[cell description]);
    return [originalDataSource_ tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
}

-(NSArray *) sectionIndexTitlesForTableView:(UITableView *)tableView {
    return [originalDataSource_ sectionIndexTitlesForTableView:tableView];
}

#pragma mark -
#pragma mark Delegate

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [originalDataDelegate_ tableView:tableView didSelectRowAtIndexPath:indexPath];
}
#pragma mark -
#pragma mark Picker
- (void)peoplePickerNavigationControllerDidCancel:
(ABPeoplePickerNavigationController *)peoplePicker {
    [self dismissModalViewControllerAnimated:YES];
}

- (NSIndexPath*) indexPathForPerson:(ABRecordRef) person {
    int section = [self numberOfSectionsInTableView:personTableView_];
    for (int i = 0 ; i < section; i ++) {
        int row = [self tableView:personTableView_ numberOfRowsInSection:i];
        for (int j = 0; j < row; j ++) {
            NSIndexPath *index = [NSIndexPath indexPathForRow:j inSection:i];
            UITableViewCell *cell = [self tableView:personTableView_ cellForRowAtIndexPath:index];
            ABRecordRef record = [cell member]; //ignore this warning
            if (ABRecordGetRecordID(record) == ABRecordGetRecordID(person)) {
                return index;
            }
        }
    }
    DLOG(@"Index not found");
    return nil;
}

- (void) reloadCellAtIndexPath:(NSIndexPath*) indexPath{
    [personTableView_ reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];

}
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person {
    
    NSIndexPath *indexPath = [personTableView_ indexPathForSelectedRow];
    if (indexPath == nil) {
        indexPath = [self indexPathForPerson:person];
    }
    if (![selectedIndexPathes_ containsObject:indexPath]) {
        [selectedIndexPathes_ addObject:indexPath];
    }
    else {
        [selectedIndexPathes_ removeObject:indexPath];
    }

    //UITableViewCell *cell = [personTableView_ cellForRowAtIndexPath:indexPath];

    //cell.accessoryType = cell.accessoryType == UITableViewCellAccessoryNone ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    [self performSelector:@selector(reloadCellAtIndexPath:) withObject:indexPath afterDelay:0.1f];
    //[cell setSelected:NO animated:YES];

    return NO;
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person
                                property:(ABPropertyID)property
                              identifier:(ABMultiValueIdentifier)identifier{
    return NO;
}

@end

