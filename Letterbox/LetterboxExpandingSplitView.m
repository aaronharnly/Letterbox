//
//  LetterboxExpandingSplitView.m
//  Letterbox
//
//  Created by Aaron on 6/7/06.
//  Copyright 2006  Aaron Harnly.. All rights reserved.
//

#import "LetterboxExpandingSplitView.h"
#import "NSObject+Swizzle.h"
// -- Apple-supplied
// models
// views
#import "MessageHeaderView.h"
// controllers
#import "MessageViewer.h"
// -- Customization
// categories
#import "MessageContentController+Letterbox.h"
#import "MessageHeaderDisplay+Letterbox.h"
// models
// views
#import "MessageViewer+Letterbox.h"
// controllers
#import "MessageContentController+Letterbox.h"
#import "LetterboxBundle.h"
@implementation LetterboxExpandingSplitView


+(NSString *) letterboxStringForPreviewPanePosition:(enum LetterboxPreviewPanePosition)position
{
    if (position == LETTERBOX_PREVIEW_BELOW) {
	return @"Below";
    } else if (position == LETTERBOX_PREVIEW_LEFT) {
	return @"Left";
    } else if (position == LETTERBOX_PREVIEW_RIGHT) {
	return @"Right";
    } else {
	return @"Unknown";
    }
}

+(enum LetterboxPreviewPanePosition) letterboxPreviewPanePositionForString:(NSString *)position
{
    if ([position isEqualToString:@"Below"]) {
	return LETTERBOX_PREVIEW_BELOW;
    } else if ([position isEqualToString:@"Left"]) {
	return LETTERBOX_PREVIEW_LEFT;
    } else {
	return LETTERBOX_PREVIEW_RIGHT;
    }
}


// -------------------------- initialization ------------------------------------------

-(void) awakeFromNib 
{
    // initialize the menu (won't do anything if the menu's already been initialized)
    [[LetterboxBundle sharedInstance] initializeMenu];

    // initialize our position, according to the user default
    NSString *preferredPosition = [[NSUserDefaults standardUserDefaults] stringForKey:@"LetterboxPreviewPanePosition"];
    [self letterboxSetPreviewPositionFromString: preferredPosition];
}

// -------------------------- custom methods ----------------------------------------

/**
 * Sets the order of the subpanes of the message viewer -- list, then message,
 *   or message, then list.
 *
 * Accepts values from the LetterboxPaneOrder enum, i.e. one of
 *  LETTERBOX_LIST_FIRST or LETTERBOX_LIST_LAST.  
 *
 * This method might cause conflicts with other Mail.app plugins if 
 *  they insert subviews other than the list panel and message pane.
 */
-(void) letterboxSetPaneOrder:(enum LetterboxPaneOrder)order
{
    NSView *listPane = [self letterboxMessageListView];
    NSView *messagePane = [self letterboxMessagePaneView];
    
    // remove the panes
    [listPane removeFromSuperviewWithoutNeedingDisplay];
    [messagePane removeFromSuperviewWithoutNeedingDisplay];
    
    // and add in appropriate order
    if (order == LETTERBOX_LIST_FIRST) {
	[self addSubview:listPane];
	[self addSubview:messagePane];	
    } else {
	[self addSubview:messagePane];	
	[self addSubview:listPane];
    }
    [self setNeedsDisplay:YES];
}

/**
 *
 * Accepts values from the LetterboxPreviewPanePosition enum, i.e. one of
 * LETTERBOX_PREVIEW_BELOW, LETTERBOX_PREVIEW_LEFT, or LETTERBOX_PREVIEW_RIGHT.
 */
-(void) letterboxSetPreviewPosition:(enum LetterboxPreviewPanePosition)position
{
    // first, decide vertical or horizontal
    if (position == LETTERBOX_PREVIEW_BELOW) {
	[self setVertical:NO];
    } else {
	[self setVertical:YES];
    }
	
    // next, decide the order
    if (position == LETTERBOX_PREVIEW_LEFT) {
	[self letterboxSetPaneOrder: LETTERBOX_LIST_LAST];
    } else {
	[self letterboxSetPaneOrder: LETTERBOX_LIST_FIRST];
    }
    [self setNeedsDisplay:YES];
}

-(void) letterboxSetPreviewPositionFromString:(NSString *)position
{
    [self letterboxSetPreviewPosition:[LetterboxExpandingSplitView letterboxPreviewPanePositionForString:position]];
}



// if YES, we adjust the Autoresizing masks of our subviews so that the
// message list stays the same size upon resizing the window; so only the message
// pane itself grows.
-(void) letterboxSetFixedMessageList:(BOOL)isFixed
{
    NSArray *subviews = [self subviews];
    NSView *messageList = [subviews objectAtIndex:0]; // false if we've swapped. need this to be smarter
    if (isFixed) {
	//	NSLog(@"Current autoresize mask: %d", [messageList autoresizingMask]);
	unsigned int newAutoresizingMask = NSViewHeightSizable;
	[messageList setAutoresizingMask:newAutoresizingMask];
	//	NSLog(@"New autoresize mask: %d", [messageList autoresizingMask]);
    }
}


// -- getters --
-(NSView *) letterboxMessageListView
{
    NSArray *subviews = [self subviews];
    NSView *subview;
    NSEnumerator *enumerator = [subviews objectEnumerator];
    
    while (subview = [enumerator nextObject]) {
	if ([subview isMemberOfClass:[NSScrollView class]]) {
	    return subview;
	}
    }
    return nil;
}

-(NSView *) letterboxMessagePaneView
{
    NSArray *subviews = [self subviews];
    NSView *subview;
    NSEnumerator *enumerator = [subviews objectEnumerator];
    
    while (subview = [enumerator nextObject]) {
	if ([subview isMemberOfClass:[ColorBackgroundView class]]) {
	    return subview;
	}
    }
    return nil;
}

-(enum LetterboxPreviewPanePosition) letterboxPreviewPosition
{
    if ([self isVertical]) {
	if ([self letterboxPaneOrder] == LETTERBOX_LIST_FIRST) {
	    return LETTERBOX_PREVIEW_RIGHT;
	} else {
	    return LETTERBOX_PREVIEW_LEFT;
	}
    } else {
	return LETTERBOX_PREVIEW_BELOW;	
    }
}

-(enum LetterboxPaneOrder) letterboxPaneOrder
{
    NSArray *subviews = [self subviews];
    NSView *firstSubview = [subviews objectAtIndex:0];
    if (firstSubview == [self letterboxMessageListView]) {
	return LETTERBOX_LIST_FIRST;
    } else {
	return LETTERBOX_LIST_LAST;
    }
}


// -------------------------- overrides ----------------------------------------
- (void)drawRect:(NSRect) theRect
{
//    NSLog(@"Requested to draw rect: %@", NSStringFromRect(theRect));	
    // if we're vertical, do our custom drawing; otherwise, just follow super
    if ([self isVertical]) {
    
	// We'll fill our rect with a solid color
	[[NSColor lightGrayColor] set];
	[NSBezierPath fillRect:theRect];
	
	// We have a funny little visual bug wherein the NSScrollView in the message pane
	// is shifted down 5 pixels.
	
	// Our fix: find the *highest* (with the highest top) subview of the container view,
	//  and tell that subview to adjust its height to reach the height of the container.

	// step 1: get the message pane content view
	NSView *contentContainerView = [[[self delegate] contentController] contentContainerView];
	NSRect containerFrame = [contentContainerView frame];
    //    NSLog(@"Container frame: %@",NSStringFromRect(containerFrame));
	float containerHeight = containerFrame.size.height;

	// step 2: get the subviews of the content view
	NSArray *theSubviews = [contentContainerView subviews];

	// step 3: find the highest subview
	NSEnumerator *theEnumerator = [theSubviews objectEnumerator];
	NSView *thisView;
	NSView *highestView;
	float highestTopHeight = 0;    
	
	while (thisView = [theEnumerator nextObject]) {
	    // step a: figure out how high the top of this view goes
	    NSRect thisViewFrame = [thisView frame];
    //	NSLog(@"View: %@", thisView);
    //	NSLog(@"   frame: %@", NSStringFromRect(thisViewFrame));
	    float topOfThisView = (thisViewFrame.origin.y + thisViewFrame.size.height);

	    // step b: if this is the highest subview, make a note of it
	    if (topOfThisView > highestTopHeight) {
		highestTopHeight = topOfThisView;
		highestView = thisView;
	    }	
	}
	
	// step 4: adjust the height of the highest view to reach up to cover the container
	if (highestView != nil) {
	    NSRect highestFrame = [highestView frame];
	    float heightToSet = (containerHeight - highestFrame.origin.y);
	    NSRect newHighestFrame = NSMakeRect(highestFrame.origin.x,highestFrame.origin.y,highestFrame.size.width,heightToSet);
	    [highestView setFrame:newHighestFrame];
	    
	    // tell everyone they need to draw
	    [contentContainerView setNeedsDisplay:YES];
	    //    [self setFixedMessageList: YES];
	}    
    } else {
		[super drawRect: theRect];
    }    
}

- (float)dividerThickness
{
    return 1.0;
}

/*
- (void)adjustSubviews
{
//    [super adjustSubviews];
//    return;
    NSLog(@"LetterboxExpandingSplitView is gonna do some HARDCORE adjusting!");
    NSArray *subviews = [self subviews];
    NSLog(@"I have %d subviews",[subviews count]);
    NSView *messageList = [subviews objectAtIndex:0]; // will be false one day, when we swap message & list
    NSView *messagePane = [subviews objectAtIndex:1];
    
    NSRect newFrame = [self frame];
    
    // start from the old frames, and make some adjustments
    NSRect messageListOldFrame = [messageList frame];
    NSRect messagePaneOldFrame = [messagePane frame];

    NSRect messageListNewFrame = [messageList frame];
    NSRect messagePaneNewFrame = [messagePane frame];
    messageListNewFrame.size.height = newFrame.size.height;
    messagePaneNewFrame.size.width = newFrame.size.width - messageListNewFrame.size.width - [self dividerThickness];
    NSLog(@"Total width: %f   List width: %f    Message width: %f",newFrame.size.width,messageListNewFrame.size.width,messagePaneNewFrame.size.width);
    messagePaneNewFrame.size.height = newFrame.size.height;
    messagePaneNewFrame.origin.x = messageListNewFrame.size.width + [self dividerThickness];
    messagePaneNewFrame.origin.y = 0;

    [messageList setFrame:messageListNewFrame];
    [messageList resizeSubviewsWithOldSize:messageListOldFrame.size];
    [messagePane setFrame:messagePaneNewFrame];
    [messagePane resizeSubviewsWithOldSize:messagePaneOldFrame.size];
    
    [messageList setNeedsDisplay:YES];
    [messagePane setNeedsDisplay:YES];
    
}
*/

// -------------------------- 

@end
