//
//  LetterboxExpandingSplitView.m
//  Letterbox
//
//  Created by Aaron on 6/7/06.
//  Copyright 2006  Aaron Harnly.. All rights reserved.
//

#import "LetterboxExpandingSplitView.h"
// -- Apple-supplied
// models
// views
#import "MessageHeaderView.h"
// controllers
#import "MessageViewer.h"
// -- Customization
// categories
#import "MessageViewer+Letterbox.h"
#import "MessageContentController+Letterbox.h"
#import "MessageHeaderDisplay+Letterbox.h"

@implementation LetterboxExpandingSplitView
-(void) awakeFromNib 
{
    NSLog(@"Bwahaha! I am a LetterboxExpandingSplitView, and I shall always be vertical!");
    [self setVertical:YES];
}

- (void)drawRect:(NSRect) theRect
{
//    NSLog(@"Requested to draw rect: %@", NSStringFromRect(theRect));	
    // We'll fill our rect with a solid color
    [[NSColor grayColor] set];
    [NSBezierPath fillRect:theRect];
    
    // We have a funny little visual bug wherein the NSScrollView in the message pane
    // is shifted down 5 pixels.
    
    // Our fix: find the *highest* (with the highest top) subview of the container view,
    //  and tell that subview to adjust its height to reach the height of the container.

    // step 1: get the message pane content view
    NSView *contentContainerView = [[(MessageViewer *)[self delegate] contentController] contentContainerView];
    NSRect containerFrame = [contentContainerView frame];
    NSLog(@"Container frame: %@",NSStringFromRect(containerFrame));
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
	NSLog(@"View: %@", thisView);
	NSLog(@"   frame: %@", NSStringFromRect(thisViewFrame));
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
    }    
    
}

- (float)dividerThickness
{
    return 1.0;
}
@end
