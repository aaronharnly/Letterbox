/*!
 *	@header LetterboxPreferencesModule
 *	@abstract Generic preferences module, with support for internationalization, SparklePlus, etc.
 *	@discussion 
 *  Created by Aaron Harnly on 1/22/07.
 *  Copyright 2007. You are welcome to use this source in your own projects,
 *  modify it as you see fit, and distribute the source and derived binaries, 
 *  so long as you retain this notice of authorship in the source code.
 */

#import <Cocoa/Cocoa.h>
#import "NSPreferencesModule.h"
@class LetterboxBundle;
@class AWHFuzzyDisabledView;

@interface LetterboxPreferencesModule : NSPreferencesModule {
	LetterboxBundle *bundleInstance;
	NSUserDefaultsController *defaultsController;

    IBOutlet NSWindow *profileInfoWindow;
    IBOutlet NSView *profileInfoView;
	IBOutlet NSTabView *tabView;
	IBOutlet AWHFuzzyDisabledView *fuzzyView;

	// --- enable/disable ---
	IBOutlet NSButton *enableCheckbox;
	IBOutlet NSTextField *willEnableInfoText;
	IBOutlet NSTextField *willDisableInfoText;

	// --- Options ---
	IBOutlet NSTabViewItem *optionsTabItem;
	// --- Updates ---
	IBOutlet NSTabViewItem *updateTabItem;
	IBOutlet NSButton *checkForUpdatesCheckbox;
	IBOutlet NSButton *includeAnonymousProfileCheckbox;
	IBOutlet NSButton *showMyProfileButton;
	IBOutlet NSTextField *anonymousProfileInfoText;
	IBOutlet NSButton *checkForUpdatesButton;
	IBOutlet NSTextField *checkForUpdatesInfoText;
	// --- About ---
	IBOutlet NSTabViewItem *aboutTabItem;
	IBOutlet NSTextField *aboutInfoText;
	IBOutlet NSButton *visitWebsiteButton;
	// --- Removal ---
	IBOutlet NSButton *removeButton;
	IBOutlet NSTextField *removeInfoText;
	
}
// ---- init
- (void)initText;

// ---- actions
- (IBAction)checkForUpdates:(id)sender;
- (IBAction)openPluginWebsite:(id)sender;
- (IBAction)showAnonymousProfileInfo:(id)sender;
- (IBAction)closeAnonymousProfileInfo:(id)sender;
- (IBAction)uninstallPlugin:(id)sender;

- (void)uninstallAlertDidEnd:(NSAlert *)alert returnCode:(int)returnCode contextInfo:(void *)contextInfo;
- (void)showAnonymousProfileInfoDidEnd:(NSWindow *)sheet returnCode:(int)returnCode contextInfo:(void *)contextInfo;
// ---- accessors
@property (readonly) LetterboxBundle *bundleInstance;
@property (readonly) NSUserDefaultsController *defaultsController;
@property (readonly) AWHFuzzyDisabledView *fuzzyView;
@end
