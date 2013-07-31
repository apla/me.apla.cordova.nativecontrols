//
//  NativeControls.h
//
//
//  Created by Jesse MacFadyen on 10-02-03.
//  MIT Licensed

//  Originally this code was developed my Michael Nachbaur
//  Formerly -> PhoneGap :: UIControls.h
//  Created by Michael Nachbaur on 13/04/09.
//  Copyright 2009 Decaf Ninja Software. All rights reserved.

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <UIKit/UITabBar.h>
#import <UIKit/UINavigationBar.h>
#import "CDVNavigationBarController.h"

#import <Cordova/CDV.h>

@interface NativeControls : CDVPlugin <UITabBarDelegate, UIActionSheetDelegate, CDVNavigationBarDelegate> {
	UITabBar* tabBar;
    UIView * navBar;
    
	NSMutableDictionary* tabBarItems;
    
	CGRect	originalWebViewBounds;
    CGFloat navBarHeight;
    CGFloat tabBarHeight;
    NSString * rightNavBarCallbackId; 
    NSString * leftNavBarCallbackId; 
    
    CDVNavigationBarController * navBarController;
    
    UIToolbar* toolBar;
	UIBarButtonItem* toolBarTitle;
	NSMutableArray* toolBarItems;
}

@property (nonatomic, retain) NSString * rightNavBarCallbackId;
@property (nonatomic, retain) NSString * leftNavBarCallbackId;
@property (nonatomic, retain) CDVNavigationBarController * navBarController;

/* Tab Bar methods
 */
- (void)createTabBar:(CDVInvokedUrlCommand*)command;
- (void)showTabBar:(CDVInvokedUrlCommand*)command;
- (void)resizeTabBar:(CDVInvokedUrlCommand*)command;
- (void)hideTabBar:(CDVInvokedUrlCommand*)command;
- (void)showTabBarItems:(CDVInvokedUrlCommand*)command;
- (void)createTabBarItem:(CDVInvokedUrlCommand*)command;
- (void)updateTabBarItem:(CDVInvokedUrlCommand*)command;
- (void)selectTabBarItem:(CDVInvokedUrlCommand*)command;

/* Nav Bar methods
 */
- (void)createNavBar:(CDVInvokedUrlCommand*)command;
- (void)setNavBarTitle:(CDVInvokedUrlCommand*)command;
- (void)setNavBarLogo:(CDVInvokedUrlCommand*)command;
- (void)showNavBar:(CDVInvokedUrlCommand*)command;
- (void)hideNavBar:(CDVInvokedUrlCommand*)command;
- (void)setupLeftNavButton:(CDVInvokedUrlCommand*)command;
- (void)setupRightNavButton:(CDVInvokedUrlCommand*)command;
- (void)leftNavButtonTapped;
- (void)rightNavButtonTapped;

- (void)hideLeftNavButton:(CDVInvokedUrlCommand*)command;
- (void)showRightNavButton:(CDVInvokedUrlCommand*)command;
- (void)hideLeftNavButton:(CDVInvokedUrlCommand*)command;
- (void)showRightNavButton:(CDVInvokedUrlCommand*)command;

/* Tool Bar methods
 */
- (void)createToolBar:(CDVInvokedUrlCommand*)command;
- (void)resetToolBar:(CDVInvokedUrlCommand*)command;
- (void)setToolBarTitle:(CDVInvokedUrlCommand*)command;
- (void)createToolBarItem:(CDVInvokedUrlCommand*)command;
- (void)showToolBar:(CDVInvokedUrlCommand*)command;
- (void)hideToolBar:(CDVInvokedUrlCommand*)command;

/* ActionSheet
 */
- (void)createActionSheet:(CDVInvokedUrlCommand*)command;


@end