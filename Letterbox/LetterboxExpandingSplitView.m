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
    // is shifted down by three or four pixels
    // We'll fix that by finding the NSScrollView and adjusting its height to be the
    //  same as its containing view.
    NSView *contentContainerView = [[(MessageViewer *)[self delegate] contentController] contentContainerView];
    NSView *scrollView = [[contentContainerView subviews] objectAtIndex:0];
    NSRect containerFrame = [contentContainerView frame];
    NSRect scrollFrame = [scrollView frame];
//    NSLog(@"Container frame: %@",NSStringFromRect(containerFrame));
//    NSLog(@"Scroll frame: %@",NSStringFromRect(scrollFrame));
    // Bump up the scroll frame to the height of the container...
    NSRect newScrollFrame = NSMakeRect(scrollFrame.origin.x,scrollFrame.origin.y,scrollFrame.size.width,containerFrame.size.height);
    [scrollView setFrame:newScrollFrame];
    [scrollView setNeedsDisplay:YES];
}

- (float)dividerThickness
{
    return 1.0;
}
@end
