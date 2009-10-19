/*
 *  Created by Aaron Harnly on 1/22/07.
 *  Copyright 2007. You are welcome to use this source in your own projects,
 *  modify it as you see fit, and distribute the source and derived binaries, 
 *  so long as you retain this notice of authorship in the source code.
 */
#import <QuartzCore/CoreAnimation.h>
#import <objc/runtime.h>

#import "LetterboxPreferencesModule.h"
#import "LetterboxBundle.h"
#import "NSPreferences+Letterbox.h"
#import "NSPreferencesModule.h"
#import "AWHFuzzyDisabledView.h"

@implementation LetterboxPreferencesModule
//
// ------------------------------- init
//
+ (void)load {
	class_setSuperclass(self, NSClassFromString(@"NSPreferencesModule"));
}

- (void)awakeFromNib
{
	[self initText];
}

/*!
	@method initText
	@abstract Sets all of the localizable text in the prefpane
	@discussion
*/
- (void)initText
{
	// TODO: Get this localization working!
	// --- enable/disable ---
//	[enableCheckbox setTitle:NSLocalizedStringFromTable(@"Enable Letterbox",@"Preferences",@"Checkbox title")];
//	[willDisableInfoText setStringValue:NSLocalizedStringFromTable(@"Letterbox will be disabled the next time you launch Mail.",@"Preferences",@"Informative text")];
//	[willEnableInfoText setStringValue:NSLocalizedStringFromTable(@"Letterbox will be enabled the next time you launch Mail.",@"Preferences",@"Informative text")];
//
//	// --- Options ---
//	[optionsTabItem setLabel:NSLocalizedStringFromTable(@"Options",@"Preferences",@"Tab item label")];
//	// --- Updates ---
//	[updateTabItem setLabel:NSLocalizedStringFromTable(@"Updates",@"Preferences",@"Tab item label")];
//	[checkForUpdatesCheckbox setTitle:NSLocalizedStringFromTable(@"Check for updates when I launch Mail",@"Preferences",@"Checkbox title")];
//	[includeAnonymousProfileCheckbox setTitle:NSLocalizedStringFromTable(@"Include anonymous system profile",@"Preferences",@"Checkbox title")];
//	[showMyProfileButton setTitle:NSLocalizedStringFromTable(@"Show my profile",@"Preferences",@"Button title")];
//	[anonymousProfileInfoText setStringValue:NSLocalizedStringFromTable(@"Anonymous system profile information is used to help us plan future development work. Note that no identifying information (like I.P. address, username, etc.) is recorded. Please contact us if you have any questions about this.",@"Preferences",@"Informative text")];
//	[checkForUpdatesButton setTitle:NSLocalizedStringFromTable(@"Check for updates now",@"Preferences",@"Button title")];
//	[checkForUpdatesInfoText setStringValue:NSLocalizedStringFromTable(@"Letterbox must be enabled in order to check for updates.",@"Preferences",@"Informative text")];
//	// --- About ---
//	[aboutTabItem setLabel:NSLocalizedStringFromTable(@"About",@"Preferences",@"Tab item title")];
////	[aboutInfoText setStringValue:NSLocalizedStringFromTable(@"Letterbox description",@"Preferences",@"Informative text")];
//	[aboutInfoText setStringValue:@"foooooooooo"];
////	[visitWebsiteButton setTitle:NSLocalizedStringFromTable(@"Visit the MyCompany website",@"Preferences",@"Button title")];	
//	// --- Removal ---
//	[removeButton setTitle:NSLocalizedStringFromTable(@"Remove Letterbox",@"Preferences",@"Button title")];
//	[removeInfoText setStringValue:NSLocalizedStringFromTable(@"Letterbox will be removed, and Mail restarted. Preferences will be left in place.",@"Preferences",@"Informative text")];
}

- (void)initDefaultsConnections
{
	bundleInstance = [LetterboxBundle sharedInstance];
}

//
// ------------------------------- Custom methods for this prefpane
//

// ---------- actions ------------
- (IBAction)checkForUpdates:(id)sender
{
    [[self bundleInstance] checkForUpdates:sender];
}

- (IBAction)openPluginWebsite:(id)sender
{
    [[self bundleInstance] openPluginWebsite:sender];
}

- (IBAction)sendPluginFeedback:(id)sender
{
    [[self bundleInstance] sendPluginFeedback:sender];
}

- (IBAction)makePluginDonation:(id)sender
{
    [[self bundleInstance] makePluginDonation:sender];
}

- (IBAction)uninstallPlugin:(id)sender
{
    NSAlert *alert = [[[NSAlert alloc] init] autorelease];
    [alert addButtonWithTitle:NSLocalizedString(@"Uninstall",@"Alert button")];
    [alert addButtonWithTitle:NSLocalizedString(@"Cancel",@"Alert button")];
    [alert setMessageText:NSLocalizedString(@"Uninstall Letterbox?",@"Alert text")];
    [alert setInformativeText:NSLocalizedString(@"The plugin will be removed, and Mail relaunched.",@"Alert text")];
    [alert setAlertStyle:NSWarningAlertStyle];
    
    [alert beginSheetModalForWindow:[[NSPreferences sharedPreferences] Letterbox_preferencesPanel] modalDelegate:self didEndSelector:@selector(uninstallAlertDidEnd:returnCode:contextInfo:) contextInfo:nil];
}

- (void) uninstallAlertDidEnd:(NSAlert *)alert returnCode:(int)returnCode contextInfo:(void *)contextInfo
{
    if (returnCode == NSAlertFirstButtonReturn) {
		[[self bundleInstance] uninstallPlugin:self];    
    }
}

- (IBAction)showAnonymousProfileInfo:(id)sender
{
	// make sure the profileInfoWindow has been wired up to the SUUpdater view.
	NSView *updaterView = [[[self bundleInstance] updater] profileMoreInfoView]; 
	[profileInfoView setAutoresizesSubviews:YES];
	[profileInfoView addSubview:updaterView];
	[updaterView setFrame:[profileInfoView frame]];
	
	[NSApp beginSheet:profileInfoWindow modalForWindow:[[NSPreferences sharedPreferences] Letterbox_preferencesPanel] modalDelegate:self didEndSelector:@selector(showAnonymousProfileInfoDidEnd:returnCode:contextInfo:) contextInfo:nil];
}

- (IBAction)closeAnonymousProfileInfo:(id)sender
{
	[profileInfoWindow orderOut:self];
	[NSApp endSheet:profileInfoWindow];
}

- (void)showAnonymousProfileInfoDidEnd:(NSWindow *)sheet returnCode:(int)returnCode contextInfo:(void *)contextInfo
{
	
}

// --------- accessors -----------------

- (LetterboxBundle *)bundleInstance
{
	if (bundleInstance == nil)
		bundleInstance = [LetterboxBundle sharedInstance];
	
	return bundleInstance;
}
- (NSUserDefaultsController *)defaultsController
{
	if (defaultsController == nil)
		defaultsController = [self.bundleInstance defaultsController];
	return defaultsController;
}
@synthesize fuzzyView;

//
// ------------------------------- NSPreferencesModule methods
//

- (void)initializeFromDefaults
{
	// Don't need anything here, since we use bindings.
}

- (NSImage *)imageForPreferenceNamed:(NSString *)theName
{
    return [NSImage imageNamed:@"PreferencesModule"];
}
- (NSString *)titleForIdentifier:(NSString *)theName
{
    return @"Letterbox";
}
- (id)preferencesNibName
{
    return @"PreferencesModule";
}
- (void)saveChanges 
{
    
}

// Notification stuff
- (void)willBeDisplayed
{
	[fuzzyView setEnabled:[self.bundleInstance enabled]];  
}

- (void)didChange
{
    
}

- (void)moduleWillBeRemoved
{
    
}
- (void)moduleWasInstalled
{
	// Disable & fuzzify the preferences tabs if the bundle is disabled.
	// Might want to bind to defaultsController's "values.EnableAtNextLaunch" key, instead.
	[fuzzyView bind:@"enabled" toObject:bundleInstance withKeyPath:@"enabled" options:nil];
	[fuzzyView setDisabledRadius:1.5];
}

// Simple flags
- (BOOL)moduleCanBeRemoved
{
    return YES;
}

- (BOOL)preferencesWindowShouldClose
{
    return YES;
}

- (BOOL)isResizable
{
    return YES;
}

- (BOOL)hasChangesPending
{
    return NO;
}


@end
