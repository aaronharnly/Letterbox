/*
 *  Created by Aaron Harnly on 1/23/07.
 *  Copyright 2007. You are welcome to use this source in your own projects,
 *  modify it as you see fit, and distribute the source and derived binaries, 
 *  so long as you retain this notice of authorship in the source code.
 */

#import "NSPreferences+Letterbox.h"
#import "LetterboxPreferencesModule.h"
#import "LetterboxBundle.h"


@implementation NSPreferences (Letterbox)
/**
 * We tweak the sharedPreferences method to insert our preferences module
 *  when first accessed.
 */
+ (id) Letterbox_sharedPreferences
{
    static BOOL haveAdded = NO;
	// we want the value that would be returned by the normal implementation;
	// so we'll send the message for *this method*, which will have been swizzled
	// with the original method.
    id preferences = [NSPreferences Letterbox_sharedPreferences]; 
    
    if (preferences != nil && !haveAdded) {
		haveAdded = YES;
		[preferences addPreferenceNamed:[LetterboxBundle preferencesPanelName] owner:[LetterboxPreferencesModule sharedInstance]];
    }
    return (NSPreferences*) preferences;
}

/*!
	@method preferencesPanel
	@abstract Gives us access to the preferences window.
	@discussion
 */
- (NSWindow *)Letterbox_preferencesPanel
{
	return _preferencesPanel;
}

/*!
	@method preferenceModules
	@abstract Gives us access to the preferences modules
	@discussion
 */
- (NSArray *)Letterbox_preferenceModules
{
	return [NSArray arrayWithArray:_preferenceModules];
}
@end
