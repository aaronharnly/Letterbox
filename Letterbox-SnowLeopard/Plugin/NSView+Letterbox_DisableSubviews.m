/*
 *  Created by Aaron Harnly on 11/25/07.
 *  Copyright 2007. You are welcome to use this source in your own projects,
 *  modify it as you see fit, and distribute the source and derived binaries, 
 *  so long as you retain this notice of authorship in the source code.
 */

#import "NSView+Letterbox_DisableSubviews.h"


@implementation NSView (Letterbox_DisableSubviews)
- (void)Letterbox_disableSubViews
{
	[self Letterbox_setSubViewsEnabled:NO];
}
- (void)Letterbox_enableSubViews
{
	[self Letterbox_setSubViewsEnabled:YES];
}
- (void)Letterbox_setSubViewsEnabled:(BOOL)newEnabled
{
	// Disable subviews
	for (NSView *subview in [self subviews]) {
		if ([subview respondsToSelector:@selector(setEnabled:)]) {
			[(NSControl*) subview setEnabled:newEnabled];
		}

		if ([subview respondsToSelector:@selector(Letterbox_setSubViewsEnabled:)])
			[subview Letterbox_setSubViewsEnabled:newEnabled];

	}
	
	// Disable tab item views
	if ([self respondsToSelector:@selector(tabViewItems)]) {
		NSArray *tabViewItems = [(NSTabView *) self tabViewItems];
		for (NSTabViewItem *tabViewItem in tabViewItems) {
			NSView *itemView = [tabViewItem view];
			if ([itemView respondsToSelector:@selector(setEnabled:)]) {
				[(NSControl*) itemView setEnabled:newEnabled];
			}

			if ([itemView respondsToSelector:@selector(Letterbox_setSubViewsEnabled:)])
				[itemView Letterbox_setSubViewsEnabled:newEnabled];
		}
	}
}
@end
