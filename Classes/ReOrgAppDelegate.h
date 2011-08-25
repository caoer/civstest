//
//  ReOrgAppDelegate.h
//  ReOrg
//
//  Created by zitao xiong on 8/23/11.
//  Copyright 2011 nanaimostudio.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"

@interface ReOrgAppDelegate : NSObject <UIApplicationDelegate> {
    
    UIWindow *window;
    MainViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet MainViewController *viewController;

@end

