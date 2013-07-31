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
- (void)createTabBar:(NSArray*)arguments withDict:(NSDictionary*)options;
- (void)showTabBar:(NSArray*)arguments withDict:(NSDictionary*)options;
- (void)resizeTabBar:(NSArray*)arguments withDict:(NSDictionary*)options;
- (void)hideTabBar:(NSArray*)arguments withDict:(NSDictionary*)options;
- (void)showTabBarItems:(NSArray*)arguments withDict:(NSDictionary*)options;
- (void)createTabBarItem:(NSArray*)arguments withDict:(NSDictionary*)options;
- (void)updateTabBarItem:(NSArray*)arguments withDict:(NSDictionary*)options;
- (void)selectTabBarItem:(NSArray*)arguments withDict:(NSDictionary*)options;

/* Nav Bar methods
 */
- (void)createNavBar:(NSArray*)arguments withDict:(NSDictionary*)options;
- (void)setNavBarTitle:(NSMutableArray *)arguments withDict:(NSMutableDictionary *)options;
- (void)setNavBarLogo:(NSMutableArray *)arguments withDict:(NSMutableDictionary *)options;
- (void)showNavBar:(NSArray*)arguments withDict:(NSDictionary*)options;
- (void)hideNavBar:(NSArray*)arguments withDict:(NSDictionary*)options;
- (void)setupLeftNavButton:(NSArray*)arguments withDict:(NSDictionary*)options;
- (void)setupRightNavButton:(NSArray*)arguments withDict:(NSDictionary*)options;
- (void)leftNavButtonTapped;
- (void)rightNavButtonTapped;

- (void)hideLeftNavButton:(NSArray*)arguments withDict:(NSDictionary*)options;
- (void)showRightNavButton:(NSArray*)arguments withDict:(NSDictionary*)options;
- (void)hideLeftNavButton:(NSArray*)arguments withDict:(NSDictionary*)options;
- (void)showRightNavButton:(NSArray*)arguments withDict:(NSDictionary*)options;

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
- (void)createActionSheet:(NSArray*)arguments withDict:(NSDictionary*)options;


@end