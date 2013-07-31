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

#import "NativeControls.h"
//#import "HelloPhoneGapAppDelegate.h"
#import <QuartzCore/QuartzCore.h>
//#import <Cordova/CordovaDelegate.h>

@implementation NativeControls
#ifndef __IPHONE_3_0
@synthesize webView;
#endif
@synthesize navBarController;
@synthesize leftNavBarCallbackId;
@synthesize rightNavBarCallbackId;


-(CDVPlugin*) initWithWebView:(UIWebView*)theWebView
{
    self = (NativeControls*)[super initWithWebView:theWebView];
    if (self) 
	{
        tabBarItems = [[NSMutableDictionary alloc] initWithCapacity:5];
		originalWebViewBounds = theWebView.bounds;
        tabBarHeight = 49.0f;
        navBarHeight = 44.0f;
        
    }
    return self;
}

- (void)dealloc
{	
    // [tabBar release];
    // [navBar release];
    // [navBarController release];
    // [leftNavBarCallbackId release];
    // [rightNavBarCallbackId release];
    // [super dealloc];
}

-(void)correctWebViewBounds
{
    
    //always the same...
    CGFloat originX = originalWebViewBounds.origin.x;
    CGFloat width = originalWebViewBounds.size.width;

    //changes based on controls visible
    CGFloat originY = originalWebViewBounds.origin.y;
    CGFloat height = originalWebViewBounds.size.height;
    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    switch (orientation) {
        case UIDeviceOrientationPortrait:
        case UIDeviceOrientationPortraitUpsideDown:
            width = originalWebViewBounds.size.width;
            height = originalWebViewBounds.size.height;
            break;
        case UIDeviceOrientationLandscapeLeft:
        case UIDeviceOrientationLandscapeRight:
            width = originalWebViewBounds.size.height + 20.0f;
            height = originalWebViewBounds.size.width - 20.0f;
            break;
    }
        
    if ( tabBar != nil && !tabBar.hidden && navBar != nil && !navBar.hidden)
    {
        originY = navBarHeight;
        height = height - navBarHeight - tabBarHeight;
        //DLog(@"Both");
        
    }
    else if ( (tabBar == nil || tabBar.hidden) && navBar != nil && !navBar.hidden)
    {
        originY = navBarHeight;
        height = height - navBarHeight;
        //DLog(@"Top");
        
    }
    else if ( !tabBar.hidden && (navBar == nil || navBar.hidden))
    {
        height = height - tabBarHeight;
        //DLog(@"Bottom");
        
    }
    else
    {
        //DLog(@"None");
    }
    
    CGRect webViewBounds = CGRectMake(
                                      originX,
                                      originY,
                                      width,
                                      height
                                      );
    
    [self.webView setFrame:webViewBounds];
    
}

#pragma mark -
#pragma mark TabBar

/**
 * Create a native tab bar at either the top or the bottom of the display.
 * @brief creates a tab bar
 * @param arguments unused
 * @param options unused
 */
- (void)createTabBar:(CDVInvokedUrlCommand*)command
{
    tabBar = [UITabBar new];
    [tabBar sizeToFit];
    tabBar.delegate = self;
    tabBar.multipleTouchEnabled   = NO;
    tabBar.autoresizesSubviews    = YES;
    tabBar.hidden                 = YES;
    tabBar.userInteractionEnabled = YES;
	tabBar.opaque = YES;
	
	self.webView.superview.autoresizesSubviews = YES;
	
	[ self.webView.superview addSubview:tabBar];    
}

/**
 * Show the tab bar after its been created.
 * @brief show the tab bar
 * @param arguments unused
 * @param options used to indicate options for where and how the tab bar should be placed
 * - \c height integer indicating the height of the tab bar (default: \c 49)
 * - \c position specifies whether the tab bar will be placed at the \c top or \c bottom of the screen (default: \c bottom)
 */
- (void)showTabBar:(CDVInvokedUrlCommand*)command
{
    if (!tabBar)
        [self createTabBar:nil];
	
	// if we are calling this again when its shown, reset
	if (!tabBar.hidden) {
		return;
	}
    
    CGFloat height = 0.0f;
    BOOL atBottom = YES;
	
    //	CGRect offsetRect = [ [UIApplication sharedApplication] statusBarFrame];
    
    NSDictionary *options;
    if ([command.arguments count] > 0) {
        options = [command.arguments objectAtIndex:0];
    } else {
        // pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:echo];
        [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR] callbackId:command.callbackId];
    }

    if (options) 
	{
        height   = [[options objectForKey:@"height"] floatValue];
        atBottom = [[options objectForKey:@"position"] isEqualToString:@"bottom"];
    }
	if(height == 0)
	{
		height = 49.0f;
		atBottom = YES;
	}
    tabBar.hidden = NO;
    CGRect webViewBounds = originalWebViewBounds;
    CGRect tabBarBounds;
	
	NSNotification* notif = [NSNotification notificationWithName:@"CDVLayoutSubviewAdded" object:tabBar];
	[[NSNotificationQueue defaultQueue] enqueueNotification:notif postingStyle: NSPostASAP];
	
    if (atBottom) 
    {
        tabBarBounds = CGRectMake(
                                  webViewBounds.origin.x,
                                  webViewBounds.origin.y + webViewBounds.size.height - height,
                                  webViewBounds.size.width,
                                  height
                                  );
        webViewBounds = CGRectMake(
                                   webViewBounds.origin.x,
                                   webViewBounds.origin.y,
                                   webViewBounds.size.width,
                                   webViewBounds.size.height - height
                                   );
    } 
    else 
    {
        tabBarBounds = CGRectMake(
                                  webViewBounds.origin.x,
                                  webViewBounds.origin.y,
                                  webViewBounds.size.width,
                                  height
                                  );
        webViewBounds = CGRectMake(
                                   webViewBounds.origin.x,
                                   webViewBounds.origin.y + height,
                                   webViewBounds.size.width,
                                   webViewBounds.size.height - height
                                   );
    }
    
    
    [tabBar setFrame:tabBarBounds];
    [self.webView setFrame:webViewBounds];
}

/**
 * Resize the tab bar on Orientation Change
 * @brief resize the tab bar on rotation
 * @param arguments unused
 * @param options unused
 */
- (void)resizeTabBar:(CDVInvokedUrlCommand*)command {
    
    //DLog(@"TabBar Resizing");
    
    CGFloat height   = 49.0f;
    CGRect webViewBounds = self.webView.bounds;
    webViewBounds.size.height += height;
    CGFloat topBar = 44.0f;    
    CGRect tabBarBounds = CGRectMake(
                              webViewBounds.origin.x,
                              webViewBounds.origin.y + webViewBounds.size.height - height + topBar,
                              webViewBounds.size.width,
                              height
                              );
    webViewBounds = CGRectMake(
                               webViewBounds.origin.x,
                               webViewBounds.origin.y + topBar,
                               webViewBounds.size.width,
                               webViewBounds.size.height - height
                               );
    
    [tabBar setFrame:tabBarBounds];
    [self.webView setFrame:webViewBounds];
    
} 

/**
 * Hide the tab bar
 * @brief hide the tab bar
 * @param arguments unused
 * @param options unused
 */
- (void)hideTabBar:(CDVInvokedUrlCommand*)command
{
    if (!tabBar)
        [self createTabBar:nil];
    tabBar.hidden = YES;
	
    NSNotification* notif = [NSNotification notificationWithName:@"CDVLayoutSubviewRemoved" object:tabBar];
	[[NSNotificationQueue defaultQueue] enqueueNotification:notif postingStyle: NSPostASAP];

    CGRect webViewBounds = originalWebViewBounds;
    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    switch (orientation) {
        case UIDeviceOrientationPortrait:
        case UIDeviceOrientationPortraitUpsideDown:
            webViewBounds = CGRectMake(
                                       webViewBounds.origin.x,
                                       webViewBounds.origin.y,
                                       webViewBounds.size.width,
                                       webViewBounds.size.height
                                       );

            break;
        case UIDeviceOrientationLandscapeLeft:
        case UIDeviceOrientationLandscapeRight:
            webViewBounds = CGRectMake(
                                       webViewBounds.origin.x,
                                       webViewBounds.origin.y,
                                       webViewBounds.size.height + 20.0f,
                                       webViewBounds.size.width - 20.0f
                                       );

            break;
    }    
    
    [self.webView setFrame:webViewBounds];	
//	[self.webView setFrame:originalWebViewBounds];
}

/**
 * Create a new tab bar item for use on a previously created tab bar.  Use ::showTabBarItems to show the new item on the tab bar.
 *
 * If the supplied image name is one of the labels listed below, then this method will construct a tab button
 * using the standard system buttons.  Note that if you use one of the system images, that the \c title you supply will be ignored.
 * - <b>Tab Buttons</b>
 *   - tabButton:More
 *   - tabButton:Favorites
 *   - tabButton:Featured
 *   - tabButton:TopRated
 *   - tabButton:Recents
 *   - tabButton:Contacts
 *   - tabButton:History
 *   - tabButton:Bookmarks
 *   - tabButton:Search
 *   - tabButton:Downloads
 *   - tabButton:MostRecent
 *   - tabButton:MostViewed
 * @brief create a tab bar item
 * @param arguments Parameters used to create the tab bar
 *  -# \c name internal name to refer to this tab by
 *  -# \c title title text to show on the tab, or null if no text should be shown
 *  -# \c image image filename or internal identifier to show, or null if now image should be shown
 *  -# \c tag unique number to be used as an internal reference to this button
 * @param options Options for customizing the individual tab item
 *  - \c badge value to display in the optional circular badge on the item; if nil or unspecified, the badge will be hidden
 */
- (void)createTabBarItem:(CDVInvokedUrlCommand*)command
{
    if (!tabBar)
        [self createTabBar:nil];
    
    NSDictionary *options;
    if ([command.arguments count] > 0) {
        options = [command.arguments objectAtIndex:0];
    } else {
        // pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:echo];
        [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR] callbackId:command.callbackId];
    }

    NSString  *name      = [command.arguments objectAtIndex:1];
    NSString  *title     = [command.arguments objectAtIndex:2];
    NSString  *imageName = [command.arguments objectAtIndex:3];
    int tag              = [[command.arguments objectAtIndex:4] intValue];
    
    UITabBarItem *item = nil;    
    if ([imageName length] > 0) {
        UITabBarSystemItem systemItem = -1;
        if ([imageName isEqualToString:@"tabButton:More"])       systemItem = UITabBarSystemItemMore;
        if ([imageName isEqualToString:@"tabButton:Favorites"])  systemItem = UITabBarSystemItemFavorites;
        if ([imageName isEqualToString:@"tabButton:Featured"])   systemItem = UITabBarSystemItemFeatured;
        if ([imageName isEqualToString:@"tabButton:TopRated"])   systemItem = UITabBarSystemItemTopRated;
        if ([imageName isEqualToString:@"tabButton:Recents"])    systemItem = UITabBarSystemItemRecents;
        if ([imageName isEqualToString:@"tabButton:Contacts"])   systemItem = UITabBarSystemItemContacts;
        if ([imageName isEqualToString:@"tabButton:History"])    systemItem = UITabBarSystemItemHistory;
        if ([imageName isEqualToString:@"tabButton:Bookmarks"])  systemItem = UITabBarSystemItemBookmarks;
        if ([imageName isEqualToString:@"tabButton:Search"])     systemItem = UITabBarSystemItemSearch;
        if ([imageName isEqualToString:@"tabButton:Downloads"])  systemItem = UITabBarSystemItemDownloads;
        if ([imageName isEqualToString:@"tabButton:MostRecent"]) systemItem = UITabBarSystemItemMostRecent;
        if ([imageName isEqualToString:@"tabButton:MostViewed"]) systemItem = UITabBarSystemItemMostViewed;
        if (systemItem != -1)
            item = [[UITabBarItem alloc] initWithTabBarSystemItem:systemItem tag:tag];
    }
    
    if (item == nil) {
        item = [[UITabBarItem alloc] initWithTitle:title image:[UIImage imageNamed:imageName] tag:tag];
    }
    
    if ([options objectForKey:@"badge"])
        item.badgeValue = [options objectForKey:@"badge"];
    
    [tabBarItems setObject:item forKey:name];
	// [item release];
}


/**
 * Update an existing tab bar item to change its badge value.
 * @brief update the badge value on an existing tab bar item
 * @param arguments Parameters used to identify the tab bar item to update
 *  -# \c name internal name used to represent this item when it was created
 * @param options Options for customizing the individual tab item
 *  - \c badge value to display in the optional circular badge on the item; if nil or unspecified, the badge will be hidden
 */
- (void)updateTabBarItem:(CDVInvokedUrlCommand*)command
{
    if (!tabBar)
        [self createTabBar:nil];
    
    NSDictionary *options;
    if ([command.arguments count] > 1) {
        options = [command.arguments objectAtIndex:0];
    } else {
        // pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:echo];
        [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR] callbackId:command.callbackId];
    }

    NSString  *name = [command.arguments objectAtIndex:1];
    UITabBarItem *item = [tabBarItems objectForKey:name];
    if (item)
        item.badgeValue = [options objectForKey:@"badge"];
}


/**
 * Show previously created items on the tab bar
 * @brief show a list of tab bar items
 * @param arguments the item names to be shown
 * @param options dictionary of options, notable options including:
 *  - \c animate indicates that the items should animate onto the tab bar
 * @see createTabBarItem
 * @see createTabBar
 */
- (void)showTabBarItems:(CDVInvokedUrlCommand*)command
{
    if (!tabBar)
        [self createTabBar:nil];
    
    NSDictionary *options;
    if ([command.arguments count] > 0) {
        options = [command.arguments objectAtIndex:0];
    } else {
        // pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:echo];
        [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR] callbackId:command.callbackId];
    }

    int i, count = [command.arguments count];
    NSMutableArray *items = [[NSMutableArray alloc] initWithCapacity:count];
    for (i = 1; i < count; i++) {
        NSString *itemName = [command.arguments objectAtIndex:i];
        UITabBarItem *item = [tabBarItems objectForKey:itemName];
        if (item)
            [items addObject:item];
    }
    
    BOOL animateItems = NO;
    if ([options objectForKey:@"animate"])
        animateItems = [(NSString*)[options objectForKey:@"animate"] boolValue];
    [tabBar setItems:items animated:animateItems];
	// [items release];
    
}

/**
 * Manually select an individual tab bar item, or nil for deselecting a currently selected tab bar item.
 * @brief manually select a tab bar item
 * @param arguments the name of the tab bar item to select
 * @see createTabBarItem
 * @see showTabBarItems
 */
- (void)selectTabBarItem:(CDVInvokedUrlCommand*)command
{
    if (!tabBar)
        [self createTabBar:nil];
    
    NSString *itemName = [command.arguments objectAtIndex:0];
    UITabBarItem *item = [tabBarItems objectForKey:itemName];
    if (item)
        tabBar.selectedItem = item;
    else
        tabBar.selectedItem = nil;
}


- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    NSString * jsCallBack = [NSString stringWithFormat:@"window.plugins.nativeControls.tabBarItemSelected(%d);", item.tag];    
    [self.webView stringByEvaluatingJavaScriptFromString:jsCallBack];
}

#pragma mark -
#pragma mark navBar




/*********************************************************************************/


-(void) createNavBar:(CDVInvokedUrlCommand*)command
{
    if (!navBar)
    {
        // UINavigationController => CDVNavigationBarController
        navBarController = [[CDVNavigationBarController alloc] init];
        navBar = [navBarController view];
        [navBarController setDelegate:self];
        
        NSLog(@"navBar width: %f",[navBar frame].size.width);
        [[navBarController view] setFrame:CGRectMake(0, 0, originalWebViewBounds.size.width , navBarHeight)];
        [[[self webView] superview] addSubview:[navBarController view]];
        [navBar setHidden:YES];
        
    }
    
}

- (void)setupLeftNavButton:(CDVInvokedUrlCommand*)command
{
    NSString * title = [command.arguments objectAtIndex:0];
    NSString * logoURL = [command.arguments objectAtIndex:1];
    [self setLeftNavBarCallbackId:[command.arguments objectAtIndex:2]];
    
    if (title && title != @"")
    {
        [[navBarController leftButton] setTitle:title];
        [[navBarController leftButton] setImage:nil];
    }
    else if (logoURL && logoURL != @"")
    {
        NSData * image = [NSData dataWithContentsOfURL:[NSURL URLWithString:logoURL]];
        if (image)
        {
            [[navBarController leftButton] setImage:[UIImage imageWithData:image]];
            [[navBarController leftButton] setTitle:nil];
            
        }
    }
    
}
- (void)setupRightNavButton:(CDVInvokedUrlCommand*)command
{
    NSString * title = [command.arguments objectAtIndex:0];
    NSString * logoURL = [command.arguments objectAtIndex:1];
    [self setRightNavBarCallbackId:[command.arguments objectAtIndex:2]];
    
    if (title && title != @"")
    {
        [[navBarController rightButton] setTitle:title];
        [[navBarController rightButton] setImage:nil];
        
    }
    else if (logoURL && logoURL != @"")
    {
        NSData * image = [NSData dataWithContentsOfURL:[NSURL URLWithString:logoURL]];
        if (image)
        {
            [[navBarController rightButton] setImage:[UIImage imageWithData:image]];
            [[navBarController rightButton] setTitle:nil];
            
        }
    }
    
}

- (void)hideLeftNavButton:(CDVInvokedUrlCommand*)command
{
    
    [[navBarController navItem] setLeftBarButtonItem:nil];
    
}
- (void)showLeftNavButton:(CDVInvokedUrlCommand*)command
{
    
    [[navBarController navItem] setLeftBarButtonItem:[navBarController leftButton]];
    
}
- (void)hideRightNavButton:(CDVInvokedUrlCommand*)command
{
    
    [[navBarController navItem] setRightBarButtonItem:nil];
    
}
- (void)showRightNavButton:(CDVInvokedUrlCommand*)command
{
    
    [[navBarController navItem] setRightBarButtonItem:[navBarController rightButton]];
    
}

-(void) leftNavButtonTapped
{
    NSString * jsCallBack = [NSString stringWithFormat:@"%@();", leftNavBarCallbackId];    
    [self.webView stringByEvaluatingJavaScriptFromString:jsCallBack];
	
}

-(void) rightNavButtonTapped
{
    NSString * jsCallBack = [NSString stringWithFormat:@"%@();", rightNavBarCallbackId];    
    [self.webView stringByEvaluatingJavaScriptFromString:jsCallBack];
    
}

-(void) showNavBar:(CDVInvokedUrlCommand*)command
{
    if (!navBar)
        [self createNavBar:nil];
    
    if ([navBar isHidden])
    {
        [navBar setHidden:NO];
        [self correctWebViewBounds];
        
    }
    
}


-(void) hideNavBar:(CDVInvokedUrlCommand*)command
{
    if (navBar && ![navBar isHidden])
    {
        [navBar setHidden:YES];
        [self correctWebViewBounds];
    }
    
}

-(void) setNavBarTitle:(CDVInvokedUrlCommand*)command
{
    if (navBar)
    {
        NSString  *name = [command.arguments objectAtIndex:0];
        [navBarController navItem].title = name;
        
        // Reset otherwise overriding logo reference
        [navBarController navItem].titleView = NULL;
    }
}

-(void) setNavBarLogo:(CDVInvokedUrlCommand*)command
{
    
    NSString * logoURL = [command.arguments objectAtIndex:0];
    UIImage * image = nil;
    
    if (logoURL && logoURL != @"")
    {
    
        
        if ([logoURL hasPrefix:@"http://"] || [logoURL hasPrefix:@"https://"])
        {
            NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:logoURL]];
            image = [UIImage imageWithData:data];
        }
        else
        {
     
 /*           NSString * path = [HelloPhoneGapAppDelegate pathForResource:logoURL];
            if (!path)
            {
                NSMutableArray *dirs = [NSMutableArray arrayWithArray:[logoURL componentsSeparatedByString:@"/"]];
                NSString *filename = [dirs lastObject];
                NSArray *nameParts = [filename componentsSeparatedByString:@"."];
                path = [[NSBundle mainBundle] pathForResource:[nameParts objectAtIndex:0] ofType:[nameParts lastObject]];

            }
            if (path)
            {
                image = [UIImage imageWithContentsOfFile:path];
            } */
        }
        
    
        if (image)
        {
            UIImageView * view = [[UIImageView alloc] initWithImage:image];
            [view setContentMode:UIViewContentModeScaleAspectFit];
            [view setBounds: CGRectMake(0, 0, 100, 30)];
            [[navBarController navItem] setTitleView:view];
        }
    }

}

#pragma mark -
#pragma mark ToolBar


/*********************************************************************************/
- (void)createToolBar:(CDVInvokedUrlCommand*)command
{
    
    //NSString* callbackId = command.callbackId;
    NSDictionary* toolBarSettings;
    if ([command.arguments count] > 0)
        toolBarSettings = [command.arguments objectAtIndex:0];

    CGFloat height   = 45.0f;
    BOOL atTop       = YES;
    UIBarStyle style = UIBarStyleBlack;
    //UIBarStyle style = UIBarStyleDefault;

    // NSDictionary* toolBarSettings = options;//[settings objectForKey:@"ToolBarSettings"];
    if (toolBarSettings) 
    {
        if ([toolBarSettings objectForKey:@"height"])
            height = [[toolBarSettings objectForKey:@"height"] floatValue];

        if ([toolBarSettings objectForKey:@"position"])
            atTop  = [[toolBarSettings objectForKey:@"position"] isEqualToString:@"top"];
        
#pragma unused(atTop)

        NSString *styleStr = [toolBarSettings objectForKey:@"style"];
        if ([styleStr isEqualToString:@"Default"])
            style = UIBarStyleDefault;
        else if ([styleStr isEqualToString:@"BlackOpaque"])
            style = UIBarStyleBlackOpaque;//deprecated
        else if ([styleStr isEqualToString:@"BlackTranslucent"])
            style = UIBarStyleBlackTranslucent;//deprecated
    }
    
    CGRect webViewBounds = self.webView.bounds;
    CGRect toolBarBounds = CGRectMake(
                                      webViewBounds.origin.x,
                                      webViewBounds.origin.y - 1.0f,
                                      webViewBounds.size.width,
                                      height
                                      );
    webViewBounds = CGRectMake(
                               webViewBounds.origin.x,
                               webViewBounds.origin.y + height,
                               webViewBounds.size.width,
                               webViewBounds.size.height - height
                               );
    toolBar = [[UIToolbar alloc] initWithFrame:toolBarBounds];
    
    [toolBar sizeToFit];
    toolBar.autoresizingMask =  UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    toolBar.hidden                 = NO;
    toolBar.multipleTouchEnabled   = NO;
    toolBar.autoresizesSubviews    = YES;
    toolBar.userInteractionEnabled = YES;
    toolBar.barStyle               = style; //set in line: 324 above    UIBarStyle style = UIBarStyleBlack;

    /* Styling hints REF UIInterface.h
     
     toolBar.alpha = 0.5;
     toolBar.tintColor = [UIColor colorWithRed:1.000 green:0.000 blue:0.000 alpha:1.000];

     */

    
    [toolBar setFrame:toolBarBounds];
    [self.webView setFrame:webViewBounds];
    
    [self.webView.superview addSubview:toolBar];
}

- (void)resetToolBar:(CDVInvokedUrlCommand*)command
{
    NSLog(@"about to reset toolBarItems");
    toolBarItems = nil;
    /*
     if (toolBarItems)
     {
     [toolBarItems release];
     }
     */
}

/**
 * Hide the tool bar
 * @brief hide the tool bar
 * @param arguments unused
 * @param options unused
 */
- (void)hideToolBar:(CDVInvokedUrlCommand*)command
{
    if (!toolBar)
        [self createToolBar:nil];
    toolBar.hidden = YES;

    NSNotification* notif = [NSNotification notificationWithName:@"CDVLayoutSubviewRemoved" object:toolBar];
    [[NSNotificationQueue defaultQueue] enqueueNotification:notif postingStyle: NSPostASAP];


    [self.webView setFrame:originalWebViewBounds];
}


- (void)setToolBarTitle:(CDVInvokedUrlCommand*)command
{
    if (!toolBar)
        [self createToolBar:nil];
    
    NSString *title;
    if ([command.arguments count] > 0) {
        title = [command.arguments objectAtIndex:0];
    } else {
        // pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:echo];
        [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR] callbackId:command.callbackId];
    }

       
    if (!toolBarTitle) {
         NSLog(@"not : %@", title);
        toolBarTitle = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:self action:@selector(toolBarButtonTapped:)];
    } else {
         NSLog(@"is: %@", title);
        toolBarTitle.title = title;
	}
	if (!toolBarItems) {
        toolBarItems = [[NSMutableArray alloc] initWithCapacity:1];
    }
   
    [toolBarItems insertObject:toolBarTitle atIndex:[toolBarItems count]];
}

/**
 * Create a new tool bar button item for use on a previously created tool bar.  Use ::showToolBar to show the new item on the tool bar.
 *
 * If the supplied image name is one of the labels listed below, then this method will construct a button
 * using the standard system buttons.  Note that if you use one of the system images, that the title you supply will be ignored.
 *
 * <b>Tool Bar Buttons</b>
 * UIBarButtonSystemItemDone
 * UIBarButtonSystemItemCancel
 * UIBarButtonSystemItemEdit
 * UIBarButtonSystemItemSave
 * UIBarButtonSystemItemAdd
 * UIBarButtonSystemItemFlexibleSpace
 * UIBarButtonSystemItemFixedSpace
 * UIBarButtonSystemItemCompose
 * UIBarButtonSystemItemReply
 * UIBarButtonSystemItemAction
 * UIBarButtonSystemItemOrganize
 * UIBarButtonSystemItemBookmarks
 * UIBarButtonSystemItemSearch
 * UIBarButtonSystemItemRefresh
 * UIBarButtonSystemItemStop
 * UIBarButtonSystemItemCamera
 * UIBarButtonSystemItemTrash
 * UIBarButtonSystemItemPlay
 * UIBarButtonSystemItemPause
 * UIBarButtonSystemItemRewind
 * UIBarButtonSystemItemFastForward
 * UIBarButtonSystemItemUndo,        // iOS 3.0 and later
 * UIBarButtonSystemItemRedo,        // iOS 3.0 and later
 * UIBarButtonSystemItemPageCurl,    // iOS 4.0 and later 
 * @param {String} name internal name to refer to this tab by
 * @param {String} [title] title text to show on the button, or null if no text should be shown
 * @param {String} [image] image filename or internal identifier to show, or null if now image should be shown
 * @param {Object} [options] Options for customizing the individual tab item [no option available at this time - this is for future proofing]
 *  
 */
- (void)createToolBarItem:(CDVInvokedUrlCommand*)command
{
    if (!toolBar)
    {
        [self createToolBar:nil];
    }

    if (!toolBarItems)
    {
        toolBarItems = [[NSMutableArray alloc] initWithCapacity:1];
    }

    NSString  *tagId;
    NSString  *title;
    NSString  *imageName = nil;

    if ([command.arguments count] > 0) {
        tagId = [command.arguments objectAtIndex:0];
        title = [command.arguments objectAtIndex:1];
    } else {
        // pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:echo];
        [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR] callbackId:command.callbackId];
    }

    if ([command.arguments count] > 2)
    {
        imageName = [command.arguments objectAtIndex:2];
    }

    NSString  *style;

    if ([command.arguments count] >= 4)
    {
        style    = [command.arguments objectAtIndex:3];
    }
    
    if (!style)
        style = @"UIBarButtonItemStylePlain";

    UIBarButtonItemStyle useStyle;

    if ([style isEqualToString:@"UIBarButtonItemStyleBordered"])
    {
        useStyle = UIBarButtonItemStyleBordered;
    }
    else if ([style isEqualToString:@"UIBarButtonItemStyleDone"])
    {
        useStyle = UIBarButtonItemStyleDone;
    }
    else 
    {
        useStyle = UIBarButtonItemStylePlain;
    }
    
    UIBarButtonItem *item = nil;    
    if (imageName && [imageName length] > 0) 
    {
        UIBarButtonSystemItem systemItem = -1;
        if ([imageName isEqualToString:@"UIBarButtonSystemItemDone"])
        {
            systemItem = UIBarButtonSystemItemDone;
        }
        else if ([imageName isEqualToString:@"UIBarButtonSystemItemCancel"])
        {
            systemItem = UIBarButtonSystemItemCancel;
        }
        else if ([imageName isEqualToString:@"UIBarButtonSystemItemEdit"])
        {
            systemItem = UIBarButtonSystemItemEdit;
        }
        else if ([imageName isEqualToString:@"UIBarButtonSystemItemSave"])
        {
            systemItem = UIBarButtonSystemItemSave;
        }
        else if ([imageName isEqualToString:@"UIBarButtonSystemItemAdd"])
        {
            systemItem = UIBarButtonSystemItemAdd;
        }
        else if ([imageName isEqualToString:@"UIBarButtonSystemItemFlexibleSpace"])
        {
            systemItem = UIBarButtonSystemItemFlexibleSpace;
        }
        else if ([imageName isEqualToString:@"UIBarButtonSystemItemFixedSpace"])
        {
            systemItem = UIBarButtonSystemItemFixedSpace;
        }
        else if ([imageName isEqualToString:@"UIBarButtonSystemItemCompose"])
        {
            systemItem = UIBarButtonSystemItemCompose;
        }
        else if ([imageName isEqualToString:@"UIBarButtonSystemItemReply"])
        {
            systemItem = UIBarButtonSystemItemReply;
        }
        else if ([imageName isEqualToString:@"UIBarButtonSystemItemAction"])
        {
            systemItem = UIBarButtonSystemItemAction;
        }
        else if ([imageName isEqualToString:@"UIBarButtonSystemItemOrganize"])
        {
            systemItem = UIBarButtonSystemItemOrganize;
        }
        else if ([imageName isEqualToString:@"UIBarButtonSystemItemBookmarks"])
        {
            systemItem = UIBarButtonSystemItemBookmarks;
        }
        else if ([imageName isEqualToString:@"UIBarButtonSystemItemSearch"])
        {
            systemItem = UIBarButtonSystemItemSearch;
        }
        else if ([imageName isEqualToString:@"UIBarButtonSystemItemRefresh"])
        {
            systemItem = UIBarButtonSystemItemRefresh;
        }
        else if ([imageName isEqualToString:@"UIBarButtonSystemItemStop"])
        {
            systemItem = UIBarButtonSystemItemStop;
        }
        else if ([imageName isEqualToString:@"UIBarButtonSystemItemCamera"])
        {
            systemItem = UIBarButtonSystemItemCamera;
        }
        else if ([imageName isEqualToString:@"UIBarButtonSystemItemTrash"])
        {
            systemItem = UIBarButtonSystemItemTrash;
        }
        else if ([imageName isEqualToString:@"UIBarButtonSystemItemPlay"])
        {
            systemItem = UIBarButtonSystemItemPlay;
        }
        else if ([imageName isEqualToString:@"UIBarButtonSystemItemPause"])
        {
            systemItem = UIBarButtonSystemItemPause;
        }
        else if ([imageName isEqualToString:@"UIBarButtonSystemItemRewind"])
        {
            systemItem = UIBarButtonSystemItemRewind;
        }
        else if ([imageName isEqualToString:@"UIBarButtonSystemItemFastForward"])
        {
            systemItem = UIBarButtonSystemItemFastForward;
        }
        else if ([imageName isEqualToString:@"UIBarButtonSystemItemUndo"])
        {
            systemItem = UIBarButtonSystemItemUndo;
        }
        else if ([imageName isEqualToString:@"UIBarButtonSystemItemRedo"])
        {
            systemItem = UIBarButtonSystemItemRedo;
        }
        else if ([imageName isEqualToString:@"UIBarButtonSystemItemPageCurl"])
        {
            systemItem = UIBarButtonSystemItemPageCurl;
        }
        
        if (systemItem)
        {
            item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:systemItem target:self action:@selector(toolBarButtonTapped:)];
            if ([imageName isEqualToString:@"UIBarButtonSystemItemFixedSpace"])
            {
                item.width = 14;
            }
        }
        else
        {
            item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:imageName] style:useStyle target:self action:@selector(toolBarButtonTapped:)];
        }
    }
    else 
    {
        item = [[UIBarButtonItem alloc] initWithTitle:title style:useStyle target:self action:@selector(toolBarButtonTapped:)];
    }
    

    [toolBarItems insertObject:item atIndex:[tagId intValue]];
    // [item release];
}

- (void)showToolBar:(CDVInvokedUrlCommand*)command
{
    if (!toolBar)
    {
        [self createToolBar:nil];
    }   

    [toolBar setItems:toolBarItems animated:NO];
}

- (void) toolBarButtonTapped:(UIBarButtonItem *)button
{
    int count = 0;
    
    for (UIBarButtonItem* currentButton in toolBarItems) {
        if (currentButton == button) {
            // TODO: use callback
            NSString * jsCallBack = [NSString stringWithFormat:@"window.plugins.nativeControls.toolBarButtonTapped(%d);", count];    
            [self.webView stringByEvaluatingJavaScriptFromString:jsCallBack];
            return;
        }

        count++;
    }
}


#pragma mark -
#pragma mark ActionSheet

- (void)createActionSheet:(CDVInvokedUrlCommand*)command
{
    NSDictionary *options;
    if ([command.arguments count] > 1) {
        options = [command.arguments objectAtIndex:0];
    } else {
        // pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:echo];
        [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR] callbackId:command.callbackId];
    }

	NSString* title = [options objectForKey:@"title"];
	
	UIActionSheet* actionSheet = [ [UIActionSheet alloc ] 
                                  initWithTitle:title 
                                  delegate:self 
                                  cancelButtonTitle:nil 
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:nil
                                  ];
	
	int count = [command.arguments count];
	for(int n = 1; n < count; n++)
	{
		[ actionSheet addButtonWithTitle:[command.arguments objectAtIndex:n]];
	}
	
	if([options objectForKey:@"cancelButtonIndex"])
	{
		actionSheet.cancelButtonIndex = [[options objectForKey:@"cancelButtonIndex"] intValue];
	}
	if([options objectForKey:@"destructiveButtonIndex"])
	{
		actionSheet.destructiveButtonIndex = [[options objectForKey:@"destructiveButtonIndex"] intValue];
	}
	
	actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;//UIActionSheetStyleBlackOpaque;
    // [self.commandDelegate runInBackground:^{
        [actionSheet showInView:self.webView.superview];
        // CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        // The sendPluginResult method is thread-safe.
        // [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    // }];
    // [actionSheet release];
	
}



- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	NSString * jsCallBack = [NSString stringWithFormat:@"window.plugins.nativeControls._onActionSheetDismissed(%d);", buttonIndex];    
    [self.webView stringByEvaluatingJavaScriptFromString:jsCallBack];
}


@end
