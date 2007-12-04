//
//  MessageViewer+Letterbox.m
//  Letterbox
//
//  Created by Aaron on 12/3/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "MessageViewer+Letterbox.h"
#import "LetterboxBundle.h"
#import "LetterboxConstants.h"
#import "ExpandingSplitView+Letterbox.h"

@implementation MessageViewer (Letterbox)

// -------------------------- overrides ----------------------------
- (void)initializeMenus
{
	NSMenu *mainMenu = [NSApp mainMenu];
	NSMenu *viewMenu = [[mainMenu itemAtIndex:3] submenu];
	NSMenuItem *firstItem = [viewMenu itemAtIndex:0];
	// Do we already have the menu up?
	BOOL haveMenuAdditions = NO;
	if ([firstItem hasSubmenu]) {
		NSMenuItem *firstSubitem = [[firstItem submenu] itemAtIndex:0];
		if ([firstSubitem action] == @selector(togglePreviewPane:)) {
			haveMenuAdditions = YES;
		}
	}
	if (! haveMenuAdditions) {
		NSLog(@"Inserting PreviewPane menu...");
		[viewMenu insertItem:[[LetterboxBundle sharedInstance] viewMenuAdditionPreviewPane] atIndex:0];
		[viewMenu insertItem:[NSMenuItem separatorItem] atIndex:1];
	}
}

- (void) Letterbox__setUpWindowContents
{
	[self Letterbox__setUpWindowContents];
	// initialize our position, according to the current default
	NSString *preferredPosition = [[[LetterboxBundle sharedInstance] defaults] objectForKey:LetterboxPreviewPanePositionKey];
	[self setPreviewPanePosition:preferredPosition];
	[self initializeMenus];
//	[_splitView setDividerType:0];
}

// ---------------------------- actions ----------------------------

- (IBAction) setPreviewPaneRight:(id)sender
{
	NSLog(@"Setting preview pane right");
	[_splitView setVertical:YES];
	[_splitView setPaneOrder:LetterboxPaneOrderMailboxListFirst];
}
- (IBAction) setPreviewPaneLeft:(id)sender
{
	NSLog(@"Setting preview pane left");
	[_splitView setVertical:YES];
	[_splitView setPaneOrder:LetterboxPaneOrderMailboxListLast];
	NSLog(@"Splitview is: %@", _splitView);
}
- (IBAction) setPreviewPaneBottom:(id)sender
{
	NSLog(@"Setting preview pane bottom");
	[_splitView setVertical:NO];
	[_splitView setPaneOrder:LetterboxPaneOrderMailboxListFirst];
	NSLog(@"Splitview is: %@", _splitView);
}

- (IBAction) togglePreviewPane:(id)sender
{
	[self setPreviewPaneVisible:(! [self previewPaneVisible])];
}
- (IBAction) hidePreviewPane:(id)sender
{
	[self setPreviewPaneVisible:NO]; 
}
- (IBAction) showPreviewPane:(id)sender
{
	[self setPreviewPaneVisible:YES];
}
- (void)setPreviewPanePosition:(NSString *)position 
{
	if ([position isEqualToString:LetterboxPreviewPanePositionLeft]) {
		[self setPreviewPaneLeft:self];
	} else if ([position isEqualToString:LetterboxPreviewPanePositionRight]) {
		[self setPreviewPaneRight:self];
	} else if ([position isEqualToString:LetterboxPreviewPanePositionBottom]) {
		[self setPreviewPaneBottom:self];
	}
}


// --------------------------- accessors --------------------------
- (MessageContentController *) contentController {
    return _contentController;
}

- (ExpandingSplitView *) splitView {
    return _splitView;
}

@end
