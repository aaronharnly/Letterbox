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
#import "../AppleHeaders/SingleMessageViewer.h"
#import "../AppleHeaders/ASExtendedTableView.h"

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

	// bind the list view settings
	[self bind:@"drawsAlternatingRowColors" toObject:[[LetterboxBundle sharedInstance] defaultsController] withKeyPath:
		[NSString stringWithFormat:@"values.%@", LetterboxAlternatingRowColorsKey]
		options:nil];

	[self bind:@"drawsDividerLines" toObject:[[LetterboxBundle sharedInstance] defaultsController] withKeyPath:
		[NSString stringWithFormat:@"values.%@", LetterboxDividerLineKey]
		options:nil];

	// bind the divider settings
	[[self splitView] bind:@"letterboxDividerType" toObject:[[LetterboxBundle sharedInstance] defaultsController] withKeyPath:
		[NSString stringWithFormat:@"values.%@", LetterboxDividerTypeKey]
		options:nil];
}

- (BOOL) selector:(SEL)selector matchesPosition:(NSString *)position
{
	return (
		( (selector == @selector(setPreviewPaneRight:)) && ([position isEqualToString:LetterboxPreviewPanePositionRight]))
		|| ( (selector == @selector(setPreviewPaneLeft:)) && ([position isEqualToString:LetterboxPreviewPanePositionLeft]))
		|| ( (selector == @selector(setPreviewPaneBottom:)) && ([position isEqualToString:LetterboxPreviewPanePositionBottom]))
	);
}

- (BOOL) Letterbox_validateMenuItem:(NSMenuItem *)item
{
	SEL itemSelector = [item action];
	if (itemSelector == @selector(setPreviewPaneRight:)
		|| itemSelector == @selector(setPreviewPaneLeft:)
		|| itemSelector == @selector(setPreviewPaneBottom:)
		|| itemSelector == @selector(togglePreviewPane:)
		|| itemSelector == @selector(hidePreviewPane:)
		|| itemSelector == @selector(showPreviewPane:)
	) {
		// validate if we're not a single message viewer
		BOOL shouldValidate = ! ([self isKindOfClass:[SingleMessageViewer class]]);
		// Let's also take care of setting the state
		if (shouldValidate) {
			NSString *previewPanePosition = [_splitView previewPanePosition];
			if (itemSelector == @selector(setPreviewPaneRight:)
				|| itemSelector == @selector(setPreviewPaneLeft:)
				|| itemSelector == @selector(setPreviewPaneBottom:)) {
					[item setState:([self selector:itemSelector matchesPosition:previewPanePosition]) ?
						NSOnState : NSOffState];
			} else if (itemSelector == @selector(togglePreviewPane:)) {
				[item setTitle: ([self previewPaneVisible]) ?
					NSLocalizedStringFromTable(@"Hide", @"Letterbox", @"Menu item")
					: NSLocalizedStringFromTable(@"Show", @"Letterbox", @"Menu item")];
			}
		}
		return shouldValidate;
	} else {
		// kick it back to the default implementation
		return [self Letterbox_validateMenuItem:item];
	}
}
// ---------------------------- actions ----------------------------

- (IBAction) setPreviewPaneRight:(id)sender
{
	[self setPreviewPanePosition:LetterboxPreviewPanePositionRight];
}
- (IBAction) setPreviewPaneLeft:(id)sender
{
	[self setPreviewPanePosition:LetterboxPreviewPanePositionLeft];
}
- (IBAction) setPreviewPaneBottom:(id)sender
{
	[self setPreviewPanePosition:LetterboxPreviewPanePositionBottom];
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
	// When we change this window, we'll also change the default. 
	// Dunno for sure whether that's the right thing to do.
	[[[LetterboxBundle sharedInstance] defaults] setObject:position forKey:LetterboxPreviewPanePositionKey];
	[_splitView setPreviewPanePosition:position];
}


// --------------------------- accessors --------------------------
- (MessageContentController *) contentController {
    return _contentController;
}

- (ExpandingSplitView *) splitView {
    return _splitView;
}

- (ASExtendedTableView *) messageListTableView
{
	return (ASExtendedTableView *)[[[self splitView] messageListView] documentView];
}

- (BOOL) drawsAlternatingRowColors
{
	return [[self messageListTableView] usesAlternatingRowBackgroundColors];
}

- (void) setDrawsAlternatingRowColors:(BOOL)drawAlternating
{
	[[self messageListTableView] setUsesAlternatingRowBackgroundColors:drawAlternating];
}

- (BOOL) drawsDividerLines
{
	return ([[self messageListTableView] gridStyleMask] == NSTableViewSolidHorizontalGridLineMask);
}

-(void) setDrawsDividerLines:(BOOL)drawDividers
{
	[[self messageListTableView] setGridStyleMask:(drawDividers) ?
		NSTableViewSolidHorizontalGridLineMask
		: NSTableViewGridNone];	
}

@end
