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
#import "NSObject+LetterboxSwizzle.h"
#import <objc/runtime.h>

//#import "../AppleHeaders/SingleMessageViewer.h"
//#import "../AppleHeaders/ASExtendedTableView.h"

@implementation MessageViewer_Letterbox
+ (void) load {
	NSString *targetClass = @"MessageViewer";
	// Overrides
	[MessageViewer_Letterbox Letterbox_addMethod:@selector(initializeMenus) toClassNamed:targetClass];
	[MessageViewer_Letterbox Letterbox_addMethod:@selector(Letterbox__setUpWindowContents) toClassNamed:targetClass];
	[MessageViewer_Letterbox Letterbox_addMethod:@selector(selector:matchesPosition:) toClassNamed:targetClass];
	[MessageViewer_Letterbox Letterbox_addMethod:@selector(Letterbox_validateMenuItem:) toClassNamed:targetClass];
	// Actions
	[MessageViewer_Letterbox Letterbox_addMethod:@selector(setPreviewPaneRight:) toClassNamed:targetClass];
	[MessageViewer_Letterbox Letterbox_addMethod:@selector(setPreviewPaneLeft:) toClassNamed:targetClass];
	[MessageViewer_Letterbox Letterbox_addMethod:@selector(setPreviewPaneBottom:) toClassNamed:targetClass];
	[MessageViewer_Letterbox Letterbox_addMethod:@selector(togglePreviewPane:) toClassNamed:targetClass];
	[MessageViewer_Letterbox Letterbox_addMethod:@selector(hidePreviewPane:) toClassNamed:targetClass];
	[MessageViewer_Letterbox Letterbox_addMethod:@selector(showPreviewPane:) toClassNamed:targetClass];
	[MessageViewer_Letterbox Letterbox_addMethod:@selector(setPreviewPaneRight:) toClassNamed:targetClass];
	// Accessors
	[MessageViewer_Letterbox Letterbox_addMethod:@selector(contentController) toClassNamed:targetClass];
	[MessageViewer_Letterbox Letterbox_addMethod:@selector(splitView) toClassNamed:targetClass];
	[MessageViewer_Letterbox Letterbox_addMethod:@selector(tableManager) toClassNamed:targetClass];
	[MessageViewer_Letterbox Letterbox_addMethod:@selector(messageListTableView) toClassNamed:targetClass];
	[MessageViewer_Letterbox Letterbox_addMethod:@selector(drawsAlternatingRowColors) toClassNamed:targetClass];
	[MessageViewer_Letterbox Letterbox_addMethod:@selector(setDrawsAlternatingRowColors:) toClassNamed:targetClass];
	[MessageViewer_Letterbox Letterbox_addMethod:@selector(drawsDividerLines) toClassNamed:targetClass];
	[MessageViewer_Letterbox Letterbox_addMethod:@selector(setDrawsDividerLines:) toClassNamed:targetClass];
	[MessageViewer_Letterbox Letterbox_addMethod:@selector(previewPanePosition) toClassNamed:targetClass];
	[MessageViewer_Letterbox Letterbox_addMethod:@selector(setPreviewPanePosition:) toClassNamed:targetClass];
}

// -------------------------- overrides ----------------------------
- (void) initializeMenus
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
	// bind the preview pane position
	[self bind:@"previewPanePosition" toObject:[[LetterboxBundle sharedInstance] defaultsController] withKeyPath:
	 [NSString stringWithFormat:@"values.%@", LetterboxPreviewPanePositionKey] options:nil];
	// initialize our position, according to the current default
	NSString *preferredPosition = [[[LetterboxBundle sharedInstance] defaults] objectForKey:LetterboxPreviewPanePositionKey];
	[self setPreviewPanePosition:preferredPosition];

	// initialize the menu items
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
	
//	NSLog(@"Stuff: %@", [[self splitView] ]);
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
		BOOL shouldValidate = ! ([self isKindOfClass:NSClassFromString(@"SingleMessageViewer")]);
		// Let's also take care of setting the state
		if (shouldValidate) {
			NSString *previewPanePosition = [[self splitView] previewPanePosition];
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

// --------------------------- accessors --------------------------
- (id) contentController {
	Ivar contentControllerIvar = class_getInstanceVariable(NSClassFromString(@"MessageViewer"), "_contentController");
	return object_getIvar(self, contentControllerIvar);
}

- (id) splitView {
	Ivar splitViewIvar = class_getInstanceVariable(NSClassFromString(@"MessageViewer"), "_splitView");
	return object_getIvar(self, splitViewIvar);
}

- (id) tableManager {
	Ivar tableManagerIvar = class_getInstanceVariable(NSClassFromString(@"MessageViewer"), "_tableManager");
	return object_getIvar(self, tableManagerIvar);
}

- (id) messageListTableView
{
	return [[[self splitView] messageListView] documentView];
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

- (NSString *)previewPanePosition
{
	return [[self splitView] previewPanePosition];
}
- (void)setPreviewPanePosition:(NSString *)position 
{
	// When we change this window, we'll also change the default. 
	// Dunno for sure whether that's the right thing to do.
	[[[LetterboxBundle sharedInstance] defaults] setObject:position forKey:LetterboxPreviewPanePositionKey];
	[[self splitView] setPreviewPanePosition:position];
}
@end
