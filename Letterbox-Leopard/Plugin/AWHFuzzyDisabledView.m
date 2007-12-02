/*
 *  Created by Aaron Harnly on 11/25/07.
 *  Copyright 2007. You are welcome to use this source in your own projects,
 *  modify it as you see fit, and distribute the source and derived binaries, 
 *  so long as you retain this notice of authorship in the source code.
 */

#import "AWHFuzzyDisabledView.h"
#import <QuartzCore/CoreAnimation.h>
#import "NSView+Letterbox_DisableSubviews.h"

float enabledRadius = 0.0; // i.e. no fuzzification

@implementation AWHFuzzyDisabledView
-(void)setEffects
{
		if ([self layer] == nil)
			[self setWantsLayer:YES];
		myEffect = [CIFilter filterWithName:@"CIGaussianBlur"]; 
		[myEffect setDefaults];
		[myEffect setValue:[NSNumber numberWithFloat:(enabled) ? enabledRadius : disabledRadius] forKey:@"inputRadius"];
		myEffects = [NSArray arrayWithObject:myEffect];
		[[self layer] setFilters:myEffects];
}
- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
		enabled = YES;
        // Initialization code here.
		disabledRadius = 2.0; // initial value, can be changed
		[self setEffects];
    }
    return self;
}

- (void)drawRect:(NSRect)rect {
	[self setEffects];
}

- (void)awakeFromNib
{
}

@synthesize disabledRadius;
@synthesize enabled;
-(void)setEnabled:(BOOL)newEnabled {
	enabled = newEnabled;
	[self setSubViewsEnabled:newEnabled];
	[self setEffects];
	[self setNeedsDisplay: YES];
}
@end
