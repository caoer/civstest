//
//  CustomABPeoplePickerController.m
//  ReOrg
//
//  Created by zitao xiong on 8/28/11.
//  Copyright 2011 nanaimostudio.com. All rights reserved.
//

#import "CustomABPeoplePickerController.h"


@implementation CustomABPeoplePickerController

-(void) viewWillAppear:(BOOL)animated {
    UIView *view = self.topViewController.view;
    UITableView *tableView = nil;
    for(UIView *uv in view.subviews)
    {
        NSLog(@"not found");
        if([uv isKindOfClass:[UITableView class]])
        {
            NSLog(@"found");
            tableView = (UITableView*)uv;
            originalDataSource_ = tableView.dataSource;
            originalDataDelegate_ = tableView.delegate;
            tableView.dataSource = self;
            tableView.delegate = self;
            break;
        }
    }
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [originalDataDelegate_ tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath];
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [originalDataDelegate_ tableView:tableView numberOfRowsInSection:section];
}
@end
