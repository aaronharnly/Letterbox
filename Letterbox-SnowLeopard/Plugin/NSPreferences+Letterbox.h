/*!
 *	@header NSPreferences+LetterboxSwizzle.h
 *	@abstract Category on NSPreferences to handle loading our own preferences panel.
 *	@discussion 
 *  Created by Aaron Harnly on 1/23/07.
 *  Copyright 2007. You are welcome to use this source in your own projects,
 *  modify it as you see fit, and distribute the source and derived binaries, 
 *  so long as you retain this notice of authorship in the source code.
 */

#import <Cocoa/Cocoa.h>
#import "NSPreferences.h"

@interface NSPreferences (Letterbox)
+ (id)Letterbox_sharedPreferences;
- (NSWindow *)Letterbox_preferencesPanel;
- (NSArray *)Letterbox_preferenceModules;
@end
