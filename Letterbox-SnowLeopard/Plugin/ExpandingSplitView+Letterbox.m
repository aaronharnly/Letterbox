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
#import "NSObject+LetterboxSwizzle.h"
#import "NSNumber+CGFloatSupport.h"
#import <objc/runtime.h>
//#import "../AppleHeaders/ColorBackgroundView.h"

@implementation ExpandingSplitView_Letterbox
+ (void) load {
	NSString *targetClass = @"ExpandingSplitView";
	// Overrides
	[ExpandingSplitView_Letterbox Letterbox_addMethod:@selector(Letterbox_dividerThickness) toClassNamed:targetClass];
	[ExpandingSplitView_Letterbox Letterbox_addMethod:@selector(Letterbox_drawDividerInRect:) toClassNamed:targetClass];
	// Methods
	[ExpandingSplitView_Letterbox Letterbox_addMethod:@selector(forceRefresh) toClassNamed:targetClass];
	// Accessors
	[ExpandingSplitView_Letterbox Letterbox_addMethod:@selector(messageListView) toClassNamed:targetClass];
	[ExpandingSplitView_Letterbox Letterbox_addMethod:@selector(messagePaneView) toClassNamed:targetClass];
	[ExpandingSplitView_Letterbox Letterbox_addMethod:@selector(paneOrder) toClassNamed:targetClass];
	[ExpandingSplitView_Letterbox Letterbox_addMethod:@selector(setPaneOrder:) toClassNamed:targetClass];
	[ExpandingSplitView_Letterbox Letterbox_addMethod:@selector(setPreviewPanePosition:) toClassNamed:targetClass];
	[ExpandingSplitView_Letterbox Letterbox_addMethod:@selector(previewPanePosition) toClassNamed:targetClass];
	[ExpandingSplitView_Letterbox Letterbox_addMethod:@selector(dividerThickness) toClassNamed:targetClass];
	[ExpandingSplitView_Letterbox Letterbox_addMethod:@selector(setDividerThickness:) toClassNamed:targetClass];
	[ExpandingSplitView_Letterbox Letterbox_addMethod:@selector(letterboxDividerType) toClassNamed:targetClass];
	[ExpandingSplitView_Letterbox Letterbox_addMethod:@selector(setLetterboxDividerType:) toClassNamed:targetClass];


}

// ---------------------------- overrides ------------------------------
- (CGFloat) Letterbox_dividerThickness
{
	CGFloat valueToReturn = [self Letterbox_dividerThickness]; // default
	id storedValue = [[self Letterbox_ivars] objectForKey:@"DividerThickness"];
#ifdef __X86_64__
	if ((storedValue != nil) && ([storedValue respondsToSelector:@selector(doubleValue)]))
		valueToReturn = [storedValue doubleValue];
#else
	if ((storedValue != nil) && ([storedValue respondsToSelector:@selector(floatValue)]))
		valueToReturn = [storedValue floatValue];
#endif
	return valueToReturn;
}

- (void)Letterbox_drawDividerInRect:(NSRect)rect
{
	if ([[self letterboxDividerType] isEqualToString:LetterboxDividerTypeHairline]) {
		[[NSColor darkGrayColor] set];
		NSRectFill(rect);
	} else {
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
			CGFloat halfWidth = rect.size.width / 2.0;
			CGFloat halfHeight = rect.size.height / 2.0;
			NSPoint centerPoint = NSMakePoint(rect.origin.x + halfWidth, rect.origin.y + halfHeight);
			NSImage *divot = [NSImage imageNamed:@"divot"];
			CGFloat halfDivotWidth = [divot size].width / 2.0;
			CGFloat halfDivotHeight = [divot size].height / 2.0;
			NSPoint divotPoint = NSMakePoint(centerPoint.x - halfDivotWidth, centerPoint.y - halfDivotHeight);
			
			[[NSImage imageNamed:@"divot"] compositeToPoint:divotPoint operation:NSCompositeSourceOver];
		} else {
			[self Letterbox_drawDividerInRect:rect];
		}	
	}
}

// ---------------------------- methods -----------------------------------
- (void)forceRefresh
{	
	[self adjustSubviews];
}

// ---------------------------- accessors -----------------------------------

- (NSScrollView *)messageListView
{
	NSView *messageListView = nil;
	for(NSView *view in [self subviews]) {
		if ([view isMemberOfClass:[NSScrollView class]])
			messageListView = view;
	}
	return (NSScrollView *) messageListView;
}
- (NSView *)messagePaneView
{
	NSView *messagePaneView = nil;
	for (NSView *view in [self subviews]) {
		if ([view isMemberOfClass:NSClassFromString(@"ColorBackgroundView")])
			messagePaneView = view;
	}
	return messagePaneView;
}

- (enum LetterboxPaneOrder)paneOrder;
{
	id paneOrderObj = [[self Letterbox_ivars] objectForKey:@"PaneOrder"];
	if (paneOrderObj == nil)
		return LetterboxPaneOrderMailboxListFirst;
	
	return ([paneOrderObj intValue]);
}

- (void)setPaneOrder:(enum LetterboxPaneOrder)newOrder
{
	[[self Letterbox_ivars] setObject:[NSNumber numberWithInt:newOrder] forKey:@"PaneOrder"];
}

- (void)setPreviewPanePosition:(NSString *)newPosition
{
	if ([newPosition isEqualToString:LetterboxPreviewPanePositionRight]) {
		[self setVertical:YES];
		[self setPaneOrder:LetterboxPaneOrderMailboxListFirst];
	} else if ([newPosition isEqualToString:LetterboxPreviewPanePositionLeft]) {
		[self setVertical:YES];
		[self setPaneOrder:LetterboxPaneOrderMailboxListLast];
	} else if ([newPosition isEqualToString:LetterboxPreviewPanePositionBottom]) {
		[self setVertical:NO];
		[self setPaneOrder:LetterboxPaneOrderMailboxListFirst];
	}
	[self forceRefresh];
}

- (NSString *)previewPanePosition
{
	if ([self isVertical]) {
		if ([self paneOrder] == LetterboxPaneOrderMailboxListFirst)
			return LetterboxPreviewPanePositionRight;
		else
			return LetterboxPreviewPanePositionLeft;
	} else {
		return LetterboxPreviewPanePositionBottom;
	}
}

- (void) setDividerThickness:(CGFloat)newThickness
{
	[[self Letterbox_ivars] setObject:[NSNumber numberWithCGFloat:newThickness] forKey:@"DividerThickness"];
}

- (NSString *) letterboxDividerType
{
	return [[self Letterbox_ivars] objectForKey:LetterboxDividerTypeKey];
}

- (void) setLetterboxDividerType:(NSString *)newDividerType
{
	[[self Letterbox_ivars] setObject:newDividerType forKey:LetterboxDividerTypeKey];
	if ([newDividerType isEqualToString:LetterboxDividerTypeHairline]) {
		[[self animator] setDividerThickness:1.0];
	} else {
		[[self animator] setDividerThickness:[self Letterbox_dividerThickness]];
	}
	[self forceRefresh];
}

@dynamic dividerThickness;

@end
