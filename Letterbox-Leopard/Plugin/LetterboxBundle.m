/*
 *  Created by Aaron Harnly on 6/20/07.
 *  Copyright 2007. You are welcome to use this source in your own projects,
 *  modify it as you see fit, and distribute the source and derived binaries, 
 *  so long as you retain this notice of authorship in the source code.
 */
#import <CoreFoundation/CoreFoundation.h>

#import "LetterboxBundle.h"
#import "LetterboxPreferencesModule.h"
// swizzling
#import "NSObject+LetterboxSwizzle.h"
// categories
#import "MessageContentController+Letterbox.h"
#import "MessageHeaderDisplay+Letterbox.h"
#import "MessageViewer+Letterbox.h"
#import "ExpandingSplitView+Letterbox.h"
#import "NSSplitView+Letterbox.h"
// models
#import "BundleUserDefaults.h"
#import "LetterboxConstants.h"
// views
// controllers
#import "NSPreferences.h"
#import "LetterboxPreferencesModule.h"
#import "NSPreferences+Letterbox.h"
#import "NSPreferencesModule+Letterbox.h"
#import "../SparklePlus/SUUpdater.h"
#import "../SparklePlus/SUUtilities.h"

@implementation LetterboxBundle
// ---------------------------------- MVMailBundle methods ---------------------------------- 
/*!
	@method initialize
	@abstract Initialize the plugin.
	@discussion
	This is the first step of initialization -- 
	after we call registerBundle, the singleton instance
	of the plugin class will be alloc'd and init'd.
 */
+ (void) initialize
{
    NSLog(@"Loading Letterbox plugin...");
    // Step 1: Initialize & Register
    [super initialize];

	// Sometimes +initialize seems to get called *twice* as Mail.app loads. 
	// This probably could have weird effects on swizzling and stuff, so 
	// if we already have a sharedInstance, we'll stop here.
	if ([LetterboxBundle sharedInstance] != nil) 
		return;
    [self registerBundle]; // the singleton instance is inited during this step
    
    NSLog(@"Done loading Letterbox plugin.");
}

/*!
	@method hasPreferencesPanel
	@abstract Returns true if we supply a preferences panel.
	@discussion
 */
+ (BOOL)hasPreferencesPanel
{
	return YES;
}

/*!
	@method preferencesOwnerClassName
	@abstract Returns the name of the NSPreferencesModule instance that controls the prefpane.
	@discussion I'm not actually sure what Mail does with this class name.
 */
+ (NSString *)preferencesOwnerClassName
{
	return NSStringFromClass([LetterboxPreferencesModule class]);
}

/*!
	@method preferencesPanelName
	@abstract Returns the title of the prefpane.
	@discussion This name is shown in the horizontal list of prefpanes.
 */
+ (NSString *)preferencesPanelName
{
	return @"Letterbox";
}

/*!
	@method hasPreferencesPanel
	@abstract Returns true if we supply a panel that accompanies compose windows.
	@discussion
 */
+ (BOOL)hasComposeAccessoryViewOwner
{
	return NO;
}
/*!
	@method composeAccessoryViewOwnerClassName
	@abstract Returns the name of the class that controls the compose accessory view.
	@discussion I'm not actually sure what Mail does with this class name.
 */
+ (NSString *)composeAccessoryViewOwnerClassName
{
	return nil;
}
// ----------- KVO binding stuff ---------

/*!
	@method automaticallyNotifiesObserversForKey:
	@abstract 
	@discussion Customized here because the willEnableAfterLaunch and willDisableAfterLaunch
	keys require manual notification (since they are dependent on keys in other classes).
 */
+ (BOOL)automaticallyNotifiesObserversForKey:(NSString *)theKey {
	BOOL automatic = NO;
    
	if ([theKey isEqualToString:@"willEnableAfterLaunch"]
		|| [theKey isEqualToString:@"willDisableAfterLaunch"]) {
		automatic=NO;
	} else {
		automatic=[super automaticallyNotifiesObserversForKey:theKey];
	}
	return automatic;
}


// ---------------------------------- instance methods ----------------------------------
// ------------------------- initialization methods ----------------------------------
/*!
	@method init
	@abstract We handle most of the initialization from here.
	@discussion 
	Doing so from -init instead of +initialize allows us to make use
	of instance variables and other such niceties. There's little practical difference.
 */
- (id)init
{
	if (self = [super init]) {

		// Basics & UI initialization
		// These steps should take place regardless of whether the plugin is 'enabled'
		NSLog(@"Initializing Letterbox bundle: %@", self);
		bundle = [NSBundle bundleForClass:[self class]];
		[self initializeDefaults];
		[self initializeImages];
		[self initializePreferencePane];
		[self initializeMainNib];
		[self initializeSUUpdater];
		
		NSLog(@"Done initializing Letterbox bundle");
		
		// Plugin functionality initialization
		// These steps should take place only if the user has set the plugin to be 'enabled'
		if ([self.defaults boolForKey:ENABLED_KEY]) {
			NSLog(@"Enabling Letterbox plugin.");
			enabled = YES;
			[self updateWillEnableOrDisableAfterLaunch];
			[self initializeCustomizations];
			NSLog(@"Done enabling Letterbox plugin.");
		} else {
			// If I'm NOT enabled...
			NSLog(@"Letterbox plugin is disabled.");
			enabled = NO;
			[self updateWillEnableOrDisableAfterLaunch];
		}
	}
	return self;
}

/*!
	@method initializeMainNib
	@abstract Loads the main nib for the plugin.
	@discussion
 */
- (void)initializeMainNib
{
	if (![NSBundle loadNibNamed:@"MainNib" owner:self]) {
		NSLog(@"Error loading Letterbox main nib!");
	} else {
		NSLog(@"Letterbox Loaded main nib.");
		; // any more nib setup stuff
	}
}

/*!
	@method initializeImages
	@abstract Loads named instances of any images we'll use in the plugin.
	@discussion
	The image names should be prepended with the project name (Letterbox)
	to prevent collision with other plugins.
 */
- (void)initializeImages
{
	[(NSImage *) [[NSImage alloc] 
		initByReferencingFile:[bundle pathForImageResource:@"Letterbox"]] 
		setName:@"Letterbox"];
		
	// Load the preferences icon image from this bundle
    [(NSImage *) [[NSImage alloc] 
		initByReferencingFile:[bundle pathForImageResource:@"Letterbox-PreferencesModule"]] 
		setName:@"PreferencesModule"];

    [(NSImage *) [[NSImage alloc] 
		initByReferencingFile:[bundle pathForImageResource:@"divot"]] 
		setName:@"divot"];

}

/*!
	@method initializeDefaultsController
	@abstract Sets up the defaults instance, and the defaults controller instance
	@discussion
*/
- (void)initializeDefaults
{
	defaults = [[BundleUserDefaults alloc] initWithPersistentDomainName:[[self bundle] bundleIdentifier]];
	
	// Generate a UUID in case we don't already have one
	CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
	NSString *uuid = (NSString *) CFUUIDCreateString(kCFAllocatorDefault, uuidRef);
	
	NSDictionary *initialDefaults = [NSDictionary dictionaryWithObjectsAndKeys:
		@"YES", ENABLED_KEY,
		uuid, @"UUID",
		LetterboxPreviewPanePositionRight,LetterboxPreviewPanePositionKey, // set your own defaults here
		@"NO", LetterboxAlternatingRowColorsKey,
		@"NO", LetterboxDividerLineKey,
		nil];
	
	// register the defaults
	[self.defaults registerDefaults:initialDefaults];
	
	// create a defaults controller		
	defaultsController = [[NSUserDefaultsController alloc] initWithDefaults:[self defaults] initialValues:initialDefaults];

	// add an observer for the enabled key
	[[self defaultsController] addObserver:self forKeyPath:[NSString stringWithFormat:@"values.%@",ENABLED_KEY] options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:nil];

}


/*!
	@method initializePreferencePane
	@abstract Sets up the preferences panel.
	@discussion
 */
- (void)initializePreferencePane
{
	// For reasons not obvious to me, calling [[NSPreferences sharedPreferences] addPreferenceNamed:]
	//   from here doesn't seem to work. Perhaps the preferences aren't initialized until later?
	// So anyway, we have to make an NSPreferences category and use that to add our preference module.
	[NSPreferences Letterbox_swizzleClassMethod:@selector(sharedPreferences_Letterbox) withClassMethod:@selector(sharedPreferences)];
	[NSPreferencesModule Letterbox_swizzleMethod:@selector(minSize) withMethod:@selector(minSize_Letterbox)];
}

/*!
	@method initializeSUUpdater
	@abstract Sets up the Sparkle framework.
	@discussion
	Because of our customizations to the Sparkle framework to support
	updating a plugin instead of an entire application, we need
	to inform the Sparkle framework of a few things, like the bundle
	class and icon.
 */
- (void)initializeSUUpdater
{
    // Tell the SUUtilities class about this bundle
	[SUUtilities setBundleToUpdate:bundle];
	[SUUtilities setBundleIcon: [NSImage imageNamed:@"Letterbox"]];
    // Tell the SUUpdater to do the application-launched check
	[self.updater applicationDidFinishLaunching:nil];
}

/*!
	@method initializeCustomizations
	@abstract This is where all the magic happens.
	@discussion 
	This is where the swizzling and setup particular to your plugin goes.
 */
- (void)initializeCustomizations
{
	// poseAsClass is deprecated in OS X 10.5, so rather than replacing classes entirely,
	// we'll have to use categories and swizzling.
		
	// Step 1: Swizzle
	// We can swizzle individual instance or class methods if we've added categories to a class.
	//    [FooClass Letterbox_swizzleClassMethod:@selector(bar) withClassMethod:@selector(bar)];
	//
	//    [FooClass Letterbox_swizzleMethod:@selector(bar) withMethod:@selector(bar)];
	//
	// Step 2: Replace
	// Or, if we want to eliminate the custom behavior of a subclass, we can replace a
	//  method with the same method from a superclass 
	//    [LetterboxExpandingSplitView replaceMethod:@selector(adjustSubviews) withMethod:@selector(adjustSubviews) fromClass:[NSSplitView class]];

	// MessageViewer
	[MessageViewer Letterbox_swizzleMethod:@selector(_setUpWindowContents) withMethod:@selector(Letterbox__setUpWindowContents)];
	
	// ExpandingSplitView
	[ExpandingSplitView Letterbox_swizzleMethod:@selector(dividerThickness) withMethod:@selector(Letterbox_dividerThickness)];
	[ExpandingSplitView Letterbox_swizzleMethod:@selector(drawDividerInRect:) withMethod:@selector(Letterbox_drawDividerInRect:)];
}


/*!
	@method observeValueForKeyPath:ofObject:change:
	@abstract Fires when an observed value changes.
	@discussion We monitor the EnableAfterNextLaunch defaults key, so that we can update
	our willEnableAfterLaunch and willDisableAfterLaunch properties.
 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqual:[NSString stringWithFormat:@"values.%@",ENABLED_KEY]]) {
		[self updateWillEnableOrDisableAfterLaunch];
	}
}


// --------------------------------- actions --------------------------------- 

/*!
	@method checkForUpdates
	@abstract Asks the Sparkle framework to check for updates.
	@discussion
 */
- (IBAction)checkForUpdates:(id)sender
{
	[[self updater] checkForUpdates:sender];
}

/*!
	@method openPluginWebsite
	@abstract Opens the plugin website, as set in the Info.plist.
	@discussion
 */
- (IBAction)openPluginWebsite:(id)sender
{
	[[NSWorkspace sharedWorkspace] openURL:
		[NSURL URLWithString:[bundle objectForInfoDictionaryKey:@"BundleWebsiteURL"]]];
}

/*!
	@method uninstallPlugin
	@abstract Performs the uninstall & restarts Mail.
	@discussion
	This method removes the mailbundle and restarts Mail. It does not, however,
	remove the preferences plist for the mailbundle, so a reinstallation will
	
 */
- (IBAction)uninstallPlugin:(id)sender
{
    // Remove the plugin bundle
	NSString *bundlePath = [bundle bundlePath];
	[[NSFileManager defaultManager] removeFileAtPath:bundlePath handler:nil];
    
    // Set Mail to open in a few seconds
    // This code is cribbed from the wonderful Sparkle framework
    // Thanks to Allan Odgaard for this restart code, which is much more clever than mine was.
	setenv("LAUNCH_PATH", [[[NSBundle mainBundle] bundlePath] UTF8String], 1);
	system("/bin/bash -c '{ for (( i = 0; i < 3000 && $(echo $(/bin/ps -xp $PPID|/usr/bin/wc -l))-1; i++ )); do\n"
		"    /bin/sleep .2;\n"
		"  done\n"
		"  if [[ $(/bin/ps -xp $PPID|/usr/bin/wc -l) -ne 2 ]]; then\n"
		"    /usr/bin/open \"${LAUNCH_PATH}\"\n"
		"  fi\n"
		"} &>/dev/null &'");
    
    // Quit Mail
	[NSApp terminate:self];
}
// --------------------------------- other methods --------------------------------- 
/*!
	@method updateWillEnableOrDisableAfterLaunch
	@abstract Synchronizes the willEnableAfterLaunch and willDisableAfterLaunch properties
	 to changes in the EnableAfterNextLaunch preference.
	@discussion 
	We also do manual KVO notification here.
 */
-(void)updateWillEnableOrDisableAfterLaunch
{
	[self willChangeValueForKey:@"willEnableAfterLaunch"];
	willEnableAfterLaunch = (! enabled) && ([[self defaults] boolForKey:ENABLED_KEY]);
	[self didChangeValueForKey:@"willEnableAfterLaunch"];

	[self willChangeValueForKey:@"willDisableAfterLaunch"];
	willDisableAfterLaunch = (enabled) && (! [[self defaults] boolForKey:ENABLED_KEY]);
	[self didChangeValueForKey:@"willDisableAfterLaunch"];
}


// --------------------------------- accessors --------------------------------- 
@synthesize updater;
@synthesize defaultsController;
@synthesize bundle;
@synthesize enabled;
@synthesize defaults;
@synthesize willEnableAfterLaunch;
@synthesize willDisableAfterLaunch;
@synthesize viewMenuAdditionPreviewPane;

/*!
	@method version
	@abstract Convenience method that returns the current bundle version.
	@discussion 
	We bind to this property from the preference pane.
 */
- (NSString *)version
{
	return [bundle objectForInfoDictionaryKey:@"CFBundleVersion"];
}

- (NSImage *)bundleIcon
{
	return [NSImage imageNamed:@"Letterbox"];
}


@end
