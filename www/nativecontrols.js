/*
//  This code is adapted from the work of:
//  Created by Michael Nachbaur on 13/04/09.
//  Copyright 2009 Decaf Ninja Software. All rights reserved.
//  MIT licensed
*/

/**
 * This class exposes mobile phone interface controls to JavaScript, such as
 * native tab and nav bars, etc.
 * @constructor
 */
function NativeControls() {
    this.tabBarTag = 0;
    this.tabBarCallbacks = {};
    this.selectedTabBarItem = null;
    this.toolBarCallbacks = {};
    this.toolBarIndexes = 0;
}

NativeControls.prototype.resizeTabBar = function() {
    cordova.exec(null, null, "NativeControls", "resizeTabBar", []);
};

/**
 * Create a native tab bar that can have tab buttons added to it which can respond to events.
 */
NativeControls.prototype.createTabBar = function() {
    cordova.exec(null, null, "NativeControls", "createTabBar", []);
};

/**
 * Show a tab bar.  The tab bar has to be created first.
 * @param {Object} [options] Options indicating how the tab bar should be shown:
 * - \c height integer indicating the height of the tab bar (default: \c 49)
 * - \c position specifies whether the tab bar will be placed at the \c top or \c bottom of the screen (default: \c bottom)
 */
NativeControls.prototype.showTabBar = function(options) {
    if (!options) options = {'position' : 'bottom'};
    cordova.exec(null, null, "NativeControls", "showTabBar", [options]);
};

/**
 * Hide a tab bar.  The tab bar has to be created first.
 */
NativeControls.prototype.hideTabBar = function(animate) {
    if (animate == undefined || animate == null)
        animate = true;
    cordova.exec(null, null, "NativeControls", "hideTabBar", [{ animate: animate }]);
};


/**
 * Create a new tab bar item for use on a previously created tab bar.  Use ::showTabBarItems to show the new item on the tab bar.
 *
 * If the supplied image name is one of the labels listed below, then this method will construct a tab button
 * using the standard system buttons.  Note that if you use one of the system images, that the \c title you supply will be ignored.
 *
 * <b>Tab Buttons</b>
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
 * @param {String} name internal name to refer to this tab by
 * @param {String} [title] title text to show on the tab, or null if no text should be shown
 * @param {String} [image] image filename or internal identifier to show, or null if now image should be shown
 * @param {Object} [options] Options for customizing the individual tab item
 *  - \c badge value to display in the optional circular badge on the item; if null or unspecified, the badge will be hidden
 */
NativeControls.prototype.createTabBarItem = function(name, label, image, options) {
    
	var tag = this.tabBarTag++;
    if (options && 'onSelect' in options && typeof(options['onSelect']) == 'function') {
        this.tabBarCallbacks[tag] = {'onSelect':options.onSelect,'name':name};
        //delete options.onSelect;
    }
	
    cordova.exec(null, null, "NativeControls", "createTabBarItem", [name, label, image, tag, options]);
};

/**
 * Update an existing tab bar item to change its badge value.
 * @param {String} name internal name used to represent this item when it was created
 * @param {Object} options Options for customizing the individual tab item
 *  - \c badge value to display in the optional circular badge on the item; if null or unspecified, the badge will be hidden
 */
NativeControls.prototype.updateTabBarItem = function(name, options) {
    if (!options) options = {};
    cordova.exec(null, null, "NativeControls", "updateTabBarItem", [name, options]);
};

/**
 * Show previously created items on the tab bar
 * @param {String} arguments... the item names to be shown
 * @param {Object} [options] dictionary of options, notable options including:
 *  - \c animate indicates that the items should animate onto the tab bar
 * @see createTabBarItem
 * @see createTabBar
 */
NativeControls.prototype.showTabBarItems = function() {
    var parameters = [null, null, "NativeControls", "showTabBarItems", []];
    for (var i = 0; i < arguments.length; i++) {
        parameters[4].push(arguments[i]);
    }
    сordova.exec.apply(this, parameters);
};


/**
 * Function to detect currently selected tab bar item
 * @see createTabBarItem
 * @see showTabBarItems
 */
NativeControls.prototype.getSelectedTabBarItem = function() {
    return this.selectedTabBarItem;
};


/**
 * Manually select an individual tab bar item, or nil for deselecting a currently selected tab bar item.
 * @param {String} tabName the name of the tab to select, or null if all tabs should be deselected
 * @see createTabBarItem
 * @see showTabBarItems
 */
NativeControls.prototype.selectTabBarItem = function(tab) {
    cordova.exec(null, null, "NativeControls", "selectTabBarItem", [tab]);
};

/**
 * Function called when a tab bar item has been selected.
 * @param {Number} tag the tag number for the item that has been selected
 */
NativeControls.prototype.tabBarItemSelected = function(tag) 
{
	this.selectedTabBarItem = tag;
    if (typeof(this.tabBarCallbacks[tag].onSelect) == 'function')
        this.tabBarCallbacks[tag].onSelect(this.tabBarCallbacks[tag].name);
};

/**
 * Create a NavBar.
 */
NativeControls.prototype.createNavBar = function() 
{
    cordova.exec(null, null, "NativeControls", "createNavBar", []);
};

/**
 * Create a NavBar.
 */
NativeControls.prototype.setupLeftNavButton = function(title, imageURL, onselect) 
{
    cordova.exec(null, null, "NativeControls", "setupLeftNavButton", [title, imageURL, onselect]);
};

NativeControls.prototype.hideLeftNavButton = function() 
{
    cordova.exec(null, null, "NativeControls", "hideLeftNavButton", []);
};

NativeControls.prototype.showLeftNavButton = function() 
{
    cordova.exec(null, null, "NativeControls", "showLeftNavButton", []);
};

/**
 * Create a NavBar.
 */
NativeControls.prototype.setupRightNavButton = function(title, imageURL, onselect) 
{
    cordova.exec(null, null, "NativeControls", "setupRightNavButton", [title, imageURL, onselect]);
};


NativeControls.prototype.hideRightNavButton = function() 
{
    cordova.exec(null, null, "NativeControls", "hideRightNavButton", []);
};

NativeControls.prototype.showRightNavButton = function() 
{
    cordova.exec(null, null, "NativeControls", "showRightNavButton", []);
};

/**
 * Function called to set the title of the navBar
 * @param {String} title the title to set within the NavBar
 */
NativeControls.prototype.setNavBarTitle = function(title) 
{
    cordova.exec(null, null, "NativeControls", "setNavBarTitle", [title]);
};

/**
 * Function called to set the title of the navBar
 * @param {String} imageURL full URL to the image 
 */
NativeControls.prototype.setNavBarLogo = function(imageURL) 
{
    cordova.exec(null, null, "NativeControls", "setNavBarLogo", [imageURL]);
};

/**
 * Show a nav bar.  The nav bar has to be created first.
 * @param none 
 */
NativeControls.prototype.showNavBar = function() {
    cordova.exec(null, null, "NativeControls", "showNavBar", []);
};

/**
 * Hide a nav bar.  The nav bar has to be created first.
 */
NativeControls.prototype.hideNavBar = function() {
   
    cordova.exec(null, null, "NativeControls", "hideNavBar", []);
};

/**
 * Create a toolbar.
 */
NativeControls.prototype.createToolBar = function()
{
    cordova.exec(null, null, "NativeControls", "createToolBar", []);
};
/**
 * Function called when a tab bar item has been selected.
 * @param {String} title the title to set within the toolbar
 */
NativeControls.prototype.setToolBarTitle = function(title)
{
    cordova.exec(null, null, "NativeControls", "setToolBarTitle", [title]);
};
/*
 * Added by Emile khattar: emile818@gmail.com emile@sign.al
 * @ 2011-07-08 ,  5.00 AM
 */
/**
 * Set toolBarItems = nil;
 */
NativeControls.prototype.resetToolBar = function() {
    cordova.exec(null, null, "NativeControls", "resetToolBar", []);
};
/**
 * Hide the tool bar
 * @brief hide the tool bar
 */
NativeControls.prototype.hideToolBar = function() {
    cordova.exec(null, null, "NativeControls", "hideToolBar", []);
};
 
/**
 * Show the tool bar ( re-render elements )
 * @brief Show the tool bar
 */
NativeControls.prototype.showToolBar = function() {
    cordova.exec(null, null, "NativeControls", "showToolBar", []);
};

 
 
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
NativeControls.prototype.createToolBarItem = function(name , title , image , options) {
        var toolBarIndex = this.toolBarIndexes++;
        if (!options) options = {};
        if (options && 'onTap' in options && typeof(options['onTap']) == 'function') {
        this.toolBarCallbacks[toolBarIndex] = {'onTap':options.onTap,'name':name};
        //delete options.onSelect;
    }
        //modify the NativeControls.m to change the options quickly
        // the instance name on the plugin can be passed with option for now it is hardcode in objc // Emile
    cordova.exec(null, null, "NativeControls", "createToolBarItem" , [toolBarIndex, title || '', image || '', options.style || '']);
};
 
/**
 * Function called when a tool bar item has been tapped.
 * @param {Number} tag the tag number for the item that has been selected
 */
NativeControls.prototype.toolBarButtonTapped = function(tag)
{
        this.tappedToolBarItem = tag;
    if (typeof(this.toolBarCallbacks[tag].onTap) == 'function')
        this.toolBarCallbacks[tag].onTap(this.toolBarCallbacks[tag].name);
};
 


NativeControls.prototype.createActionSheet = function(buttons,actionSheetTitle,cancelButtonIndex,destructiveButtonIndex)
{
	var options = {};
	
	if(actionSheetTitle != null)
	{
		options.title = actionSheetTitle;
	}
	if(cancelButtonIndex != null)
	{
		options.cancelButtonIndex = cancelButtonIndex;
	}
	if(destructiveButtonIndex != null)
	{
		options.destructiveButtonIndex = destructiveButtonIndex;
	}

    this.actionSheetDelegate = {};
	var params = [null, null, "NativeControls", "createActionSheet", [options]];
    for (var i = 0; i < buttons.length; i++) 
	{
        params[4].push(buttons[i].title);
        if (buttons[i].cb && typeof buttons[i].cb == 'function')
            this.actionSheetDelegate[i] = {onActionSheetDismissed: buttons[i].cb}
    }

    cordova.exec.apply(this, params);
	
	// return this.actionSheetDelegate;
}

NativeControls.prototype._onActionSheetDismissed = function(index)
{
	this.actionSheetDelegate[index].onActionSheetDismissed();
}

cordova.addConstructor(function()
{
	if(!window.plugins)
	{
		window.plugins = {};
	}
    window.plugins.nativeControls = new NativeControls();
                
});

/* function StatusBar()
{
	
}

StatusBar.prototype.setHidden = function(bHide)
{
	cordova.exec(null, null, "StatusBar.setHidden",bHide);
}

Cordova.addConstructor(
						
						function() 
						{
						if (typeof window.plugins == "undefined") 
						window.plugins = {};
						
						if (typeof window.plugins.statusBar == "undefined")
						window.plugins.statusBar = new StatusBar();
						
						}
						);
*/