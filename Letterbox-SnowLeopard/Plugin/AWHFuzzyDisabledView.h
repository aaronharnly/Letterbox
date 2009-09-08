/*!
 *	@header AWHFuzzyDisabledView
 *	@abstract Custom container view that, when disabled, disables its subviews and "fuzzes out".
 *	@discussion 
 *  Created by Aaron Harnly on 11/4/07.
 *  Copyright 2007. You are welcome to use this source in your own projects,
 *  modify it as you see fit, and distribute the source and derived binaries, 
 *  so long as you retain this notice of authorship in the source code.
 */

#import <Cocoa/Cocoa.h>


@interface AWHFuzzyDisabledView : NSView {
	BOOL enabled;
	CIFilter *myEffect;
	NSArray *myEffects;
	float disabledRadius;
}
@property BOOL enabled;
@property float disabledRadius;
@end
