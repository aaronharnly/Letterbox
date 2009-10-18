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
//#import "NSPreferencesModule.h"
@class LetterboxBundle;
@class AWHFuzzyDisabledView;

@interface LetterboxPreferencesModule : NSObject {
	// NSPreferences items
    IBOutlet NSBox *_preferencesView;
    struct CGSize _minSize;
    BOOL _hasChanges;
    void *_reserved;

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
	IBOutlet NSButton *sendFeedbackButton;
	IBOutlet NSButton *donateButton;
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
- (IBAction)sendPluginFeedback:(id)sender;
- (IBAction)makePluginDonation:(id)sender;

- (void)uninstallAlertDidEnd:(NSAlert *)alert returnCode:(int)returnCode contextInfo:(void *)contextInfo;
- (void)showAnonymousProfileInfoDidEnd:(NSWindow *)sheet returnCode:(int)returnCode contextInfo:(void *)contextInfo;
// ---- accessors
@property (readonly) LetterboxBundle *bundleInstance;
@property (readonly) NSUserDefaultsController *defaultsController;
@property (readonly) AWHFuzzyDisabledView *fuzzyView;
@end

@interface LetterboxPreferencesModule (NSPreferencesModule)
// from @protocol NSPreferencesModule
- (id)viewForPreferenceNamed:(id)arg1;
- (id)imageForPreferenceNamed:(id)arg1;
- (BOOL)hasChangesPending;
- (void)saveChanges;
- (void)willBeDisplayed;
- (void)initializeFromDefaults;
- (void)didChange;
- (void)moduleWillBeRemoved;
- (void)moduleWasInstalled;
- (BOOL)moduleCanBeRemoved;
- (BOOL)preferencesWindowShouldClose;

// from @interface NSPreferencesModule : NSObject <NSPreferencesModule>
+ (id)sharedInstance;
- (void)dealloc;
- (void)finalize;
- (id)init;
- (id)preferencesNibName;
- (void)setPreferencesView:(id)arg1;
- (id)viewForPreferenceNamed:(id)arg1;
- (id)imageForPreferenceNamed:(id)arg1;
- (id)titleForIdentifier:(id)arg1;
- (BOOL)hasChangesPending;
- (void)saveChanges;
- (void)willBeDisplayed;
- (void)initializeFromDefaults;
- (void)didChange;
- (void)moduleWillBeRemoved;
- (void)moduleWasInstalled;
- (BOOL)moduleCanBeRemoved;
- (BOOL)preferencesWindowShouldClose;
- (BOOL)isResizable;
- (CGSize)minSize;
- (void)setMinSize:(CGSize)arg1;
@end
