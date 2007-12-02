/*!
 *	@header LetterboxBundleUpdaterDelegate
 *	@abstract Customizes the Sparkle updating procedure.
 *	@discussion 
 *  Created by Aaron Harnly on 11/6/07.
 *  Copyright 2007. You are welcome to use this source in your own projects,
 *  modify it as you see fit, and distribute the source and derived binaries, 
 *  so long as you retain this notice of authorship in the source code.
 */

#import <Cocoa/Cocoa.h>
@class LetterboxBundle;

/*!
	@class LetterboxBundleUpdaterDelegate
	@abstract Delegate to the SUUpdater instance, to optionally customize the Sparkle updating procedure.
	@discussion
	
	See the SparklePlus documentation for more information on the customizations 
	available to the SUUpdater delegate.
*/
@interface LetterboxBundleUpdaterDelegate : NSObject {
	IBOutlet LetterboxBundle *pluginController;
}
/*!
	@method updaterCustomizeProfileInfo:
	@abstract Adds more information to the anonymous system profile optionally included with SparklePlus queries.
	@discussion
*/
- (NSMutableArray *)updaterCustomizeProfileInfo:(NSMutableArray *)profileInfo;
- (NSUserDefaults *)defaults;
- (NSUserDefaultsController *)defaultsController;
- (LetterboxBundle *)pluginController;
- (NSImage *)bundleIcon;
@end
