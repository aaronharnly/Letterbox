/*!
 *	@header NSView+LetterboxSwizzle_DisableSubviews.h
 *	@abstract Category on NSView to handle automatic disabling of subviews.
 *	@discussion 
 *  Created by Aaron Harnly on 11/25/07.
 *  Copyright 2007. You are welcome to use this source in your own projects,
 *  modify it as you see fit, and distribute the source and derived binaries, 
 *  so long as you retain this notice of authorship in the source code.
 */

#import <Cocoa/Cocoa.h>


@interface NSView (Letterbox_DisableSubviews)
- (void)disableSubViews;
- (void)enableSubViews;
- (void)setSubViewsEnabled:(BOOL)newEnabled;

@end
