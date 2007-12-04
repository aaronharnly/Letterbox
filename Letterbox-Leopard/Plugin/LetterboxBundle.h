/*!
 *	@header LetterboxBundle
 *	@abstract The main class of the plugin. This is loaded by Mail.app.
 *	@discussion 
 *  Created by Aaron Harnly on 6/20/07.
 *  Copyright 2007. You are welcome to use this source in your own projects,
 *  modify it as you see fit, and distribute the source and derived binaries, 
 *  so long as you retain this notice of authorship in the source code.
 */

#import <Cocoa/Cocoa.h>
#import <Foundation/Foundation.h>
#import "MVMailBundle.h"
#import "../SparklePlus/SUUpdater.h"

#define ENABLED_KEY @"EnableAtNextLaunch"

@interface LetterboxBundle : MVMailBundle {
    IBOutlet SUUpdater *updater;
	NSUserDefaultsController *defaultsController;
	NSUserDefaults *defaults;
	NSBundle *bundle;
	BOOL enabled;
	BOOL willDisableAfterLaunch;
	BOOL willEnableAfterLaunch;
	
    IBOutlet NSMenuItem *viewMenuAdditionPreviewPane;
}
// ---- MVMailBundle methods ----
+ (void)initialize;
+ (BOOL)hasPreferencesPanel;
+ (NSString *)preferencesOwnerClassName;
+ (NSString *)preferencesPanelName;
+ (BOOL)hasComposeAccessoryViewOwner;
+ (NSString *)composeAccessoryViewOwnerClassName;

// ---- initialization methods ----
- (void)initializeImages;
- (void)initializeDefaults;
- (void)initializePreferencePane;
- (void)initializeMainNib;
- (void)initializeSUUpdater;
- (void)initializeCustomizations;

// ---- actions ----
- (IBAction)checkForUpdates:(id)sender;
- (IBAction)openPluginWebsite:(id)sender;
- (IBAction)uninstallPlugin:(id)sender;

// --- other methods ---
-(void)updateWillEnableOrDisableAfterLaunch;

// ---- accessors ----
@property (readonly) NSUserDefaultsController *defaultsController;
@property (readonly) SUUpdater *updater;
@property (readonly) NSUserDefaults *defaults;
@property (readonly) NSBundle *bundle;
@property (readonly) BOOL enabled;
@property (readonly) BOOL willDisableAfterLaunch;
@property (readonly) BOOL willEnableAfterLaunch;
@property (readonly) NSString *version;
@property (readonly) NSImage *bundleIcon;
@property (readonly) NSMenuItem *viewMenuAdditionPreviewPane;
@end
