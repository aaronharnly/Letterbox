/*!
 *	@header NSPreferencesModule+LetterboxSwizzle.h
 *	@abstract Category on NSPreferencesModule to allow us to tweak the minSize.
 *	@discussion 
 *  Created by Aaron Harnly on 11/24/07.
 *  Copyright 2007. You are welcome to use this source in your own projects,
 *  modify it as you see fit, and distribute the source and derived binaries, 
 *  so long as you retain this notice of authorship in the source code.
 */

#import <Cocoa/Cocoa.h>
#import "NSPreferencesModule.h"

@interface NSPreferencesModule (Letterbox)
- (NSSize)minSize_Letterbox;
@end
