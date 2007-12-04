//
//  ExpandingSplitView+Letterbox.m
//  Letterbox
//
//  Created by Aaron on 12/3/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "ExpandingSplitView+Letterbox.h"
#import "LetterboxConstants.h"
#import "LetterboxBundle.h"
#import "MessageViewer+Letterbox.h"
#import "MessageContentController+Letterbox.h"
#import "../AppleHeaders/ColorBackgroundView.h"

@implementation ExpandingSplitView (Letterbox)
// ---------------------------- overrides ------------------------------

- (float) Letterbox_dividerThickness
{
	return ([self Letterbox_dividerThickness]);
}
- (void)Letterbox_drawDividerInRect:(NSRect)rect
{
	if ([self isVertical]) {
		NSGradient *gradient = [[NSGradient alloc] 
			initWithStartingColor:[NSColor colorWithCalibratedWhite:0.8745 alpha:1.0]
			endingColor:[NSColor colorWithCalibratedWhite:0.98 alpha:1.0]];
		[gradient drawInRect:NSMakeRect(rect.origin.x + 1, rect.origin.y, rect.size.width - 2.0, rect.size.height) angle:0.0];
		// Now make the darker lines
		[[NSColor colorWithCalibratedWhite:0.647 alpha:1.0] set];
		NSRectFill(NSMakeRect(rect.origin.x, rect.origin.y, 1.0, rect.size.height));
		NSRectFill(NSMakeRect(rect.origin.x + rect.size.width - 1.0, rect.origin.y, 1.0, rect.size.height));
		// And now the divot
		float halfWidth = rect.size.width / 2.0;
		float halfHeight = rect.size.height / 2.0;
		NSPoint centerPoint = NSMakePoint(rect.origin.x + halfWidth, rect.origin.y + halfHeight);
		NSImage *divot = [NSImage imageNamed:@"divot"];
		float halfDivotWidth = [divot size].width / 2.0;
		float halfDivotHeight = [divot size].height / 2.0;
		NSPoint divotPoint = NSMakePoint(centerPoint.x - halfDivotWidth, centerPoint.y - halfDivotHeight);
		
		[[NSImage imageNamed:@"divot"] compositeToPoint:divotPoint operation:NSCompositeSourceOver];
	} else {
		[self Letterbox_drawDividerInRect:rect];
	}
}

// ---------------------------- methods -----------------------------------
- (void)forceRefresh
{
	[self adjustSubviews];
}

// ---------------------------- accessors -----------------------------------

- (NSView *)messageListView
{
	NSView *messageListView = nil;
	for(NSView *view in [self subviews]) {
		if ([view isMemberOfClass:[NSScrollView class]])
			messageListView = view;
	}
	return messageListView;
}
- (NSView *)messagePaneView
{
	NSView *messagePaneView = nil;
	for (NSView *view in [self subviews]) {
		if ([view isMemberOfClass:[ColorBackgroundView class]])
			messagePaneView = view;
	}
	return messagePaneView;
}

- (enum LetterboxPaneOrder)paneOrder;
{
	if ([[self subviews] count] == 0) {
		NSLog(@"No subviews yet.");
		return -1;
	}
	NSView *firstView = [[self subviews] objectAtIndex:0];
	return (firstView == [self messageListView]) ?
		LetterboxPaneOrderMailboxListFirst
		: LetterboxPaneOrderMailboxListLast;

}

- (void)setPaneOrder:(enum LetterboxPaneOrder)newOrder
{
    NSView *listPane = [self messageListView];
    NSView *messagePane = [self messagePaneView];
    
    // remove the panes
    [listPane removeFromSuperviewWithoutNeedingDisplay];
    [messagePane removeFromSuperviewWithoutNeedingDisplay];
    
    // and add in appropriate order
    if (newOrder == LetterboxPaneOrderMailboxListFirst) {
		[self addSubview:listPane];
		[self addSubview:messagePane];	
    } else {
		[self addSubview:messagePane];	
		[self addSubview:listPane];
    }
	[self forceRefresh];
    [self setNeedsDisplay:YES];
}

@end
