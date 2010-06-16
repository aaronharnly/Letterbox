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
	// Swizzles
	[MessageViewer_Letterbox Letterbox_addMethod:@selector(Letterbox__setUpWindowContents) toClassNamed:targetClass];
	[MessageViewer_Letterbox Letterbox_addMethod:@selector(Letterbox__setUpMenus) toClassNamed:targetClass];
	[MessageViewer_Letterbox Letterbox_addMethod:@selector(Letterbox_validateMenuItem:) toClassNamed:targetClass];
	// Additional methods
	[MessageViewer_Letterbox Letterbox_addMethod:@selector(Letterbox_initializeMenus) toClassNamed:targetClass];
	[MessageViewer_Letterbox Letterbox_addMethod:@selector(Letterbox_initializeBindings) toClassNamed:targetClass];
	[MessageViewer_Letterbox Letterbox_addMethod:@selector(Letterbox_selector:matchesPosition:) toClassNamed:targetClass];
	// Actions
	[MessageViewer_Letterbox Letterbox_addMethod:@selector(Letterbox_setPreviewPaneRight:) toClassNamed:targetClass];
	[MessageViewer_Letterbox Letterbox_addMethod:@selector(Letterbox_setPreviewPaneLeft:) toClassNamed:targetClass];
	[MessageViewer_Letterbox Letterbox_addMethod:@selector(Letterbox_setPreviewPaneBottom:) toClassNamed:targetClass];
	[MessageViewer_Letterbox Letterbox_addMethod:@selector(Letterbox_togglePreviewPane:) toClassNamed:targetClass];
	[MessageViewer_Letterbox Letterbox_addMethod:@selector(Letterbox_hidePreviewPane:) toClassNamed:targetClass];
	[MessageViewer_Letterbox Letterbox_addMethod:@selector(Letterbox_showPreviewPane:) toClassNamed:targetClass];
	[MessageViewer_Letterbox Letterbox_addMethod:@selector(Letterbox_setPreviewPaneRight:) toClassNamed:targetClass];
	// Accessors
	[MessageViewer_Letterbox Letterbox_addMethod:@selector(Letterbox_contentController) toClassNamed:targetClass];
	[MessageViewer_Letterbox Letterbox_addMethod:@selector(Letterbox_splitView) toClassNamed:targetClass];
	[MessageViewer_Letterbox Letterbox_addMethod:@selector(Letterbox_tableManager) toClassNamed:targetClass];
	[MessageViewer_Letterbox Letterbox_addMethod:@selector(Letterbox_messageListTableView) toClassNamed:targetClass];
	[MessageViewer_Letterbox Letterbox_addMethod:@selector(Letterbox_drawsAlternatingRowColors) toClassNamed:targetClass];
	[MessageViewer_Letterbox Letterbox_addMethod:@selector(setLetterbox_drawsAlternatingRowColors:) toClassNamed:targetClass];
	[MessageViewer_Letterbox Letterbox_addMethod:@selector(Letterbox_drawsDividerLines) toClassNamed:targetClass];
	[MessageViewer_Letterbox Letterbox_addMethod:@selector(setLetterbox_drawsDividerLines:) toClassNamed:targetClass];
	[MessageViewer_Letterbox Letterbox_addMethod:@selector(Letterbox_previewPanePosition) toClassNamed:targetClass];
	[MessageViewer_Letterbox Letterbox_addMethod:@selector(setLetterbox_previewPanePosition:) toClassNamed:targetClass];
}

// -------------------------- overrides ----------------------------
- (void) Letterbox_initializeMenus
{
	NSMenu *mainMenu = [NSApp mainMenu];
	NSMenu *viewMenu = [[mainMenu itemAtIndex:3] submenu];
	NSMenuItem *firstItem = [viewMenu itemAtIndex:0];
	// Do we already have the menu up?
	BOOL haveMenuAdditions = NO;
	if ([firstItem hasSubmenu]) {
		NSMenuItem *firstSubitem = [[firstItem submenu] itemAtIndex:0];
		if ([firstSubitem action] == @selector(Letterbox_togglePreviewPane:)) {
			haveMenuAdditions = YES;
		}
	}
	if (! haveMenuAdditions) {
		[viewMenu insertItem:[[LetterboxBundle sharedInstance] viewMenuAdditionPreviewPane] atIndex:0];
		[viewMenu insertItem:[NSMenuItem separatorItem] atIndex:1];
	}
}

- (void) Letterbox__setUpMenus
{
	// invoke the default method
	[self Letterbox__setUpMenus];
	
	// initialize our menu items
	[self Letterbox_initializeMenus];
}

- (void) Letterbox_initializeBindings
{
	NSLog(@"Initializing the Letterbox bindings");
	// bind the list view settings
	[self bind:@"Letterbox_drawsAlternatingRowColors" toObject:[[LetterboxBundle sharedInstance] defaultsController] withKeyPath:
	 [NSString stringWithFormat:@"values.%@", LetterboxAlternatingRowColorsKey]
	   options:nil];
	
	[self bind:@"Letterbox_drawsDividerLines" toObject:[[LetterboxBundle sharedInstance] defaultsController] withKeyPath:
	 [NSString stringWithFormat:@"values.%@", LetterboxDividerLineKey]
	   options:nil];
	
	// bind the divider settings
	[[self Letterbox_splitView] bind:@"Letterbox_dividerType" toObject:[[LetterboxBundle sharedInstance] defaultsController] withKeyPath:
	 [NSString stringWithFormat:@"values.%@", LetterboxDividerTypeKey]
							 options:nil];
	
	// bind the preview pane position
	[self bind:@"Letterbox_previewPanePosition" toObject:[[LetterboxBundle sharedInstance] defaultsController] withKeyPath:
	 [NSString stringWithFormat:@"values.%@", LetterboxPreviewPanePositionKey] options:nil];
}

- (void) Letterbox__setUpWindowContents
{
	// invoke the default method
	[self Letterbox__setUpWindowContents];
	
	// initialize bindings if necessary
	[self Letterbox_initializeBindings];
}

- (BOOL) Letterbox_selector:(SEL)selector matchesPosition:(NSString *)position
{
	return (
		( (selector == @selector(Letterbox_setPreviewPaneRight:)) && ([position isEqualToString:LetterboxPreviewPanePositionRight]))
		|| ( (selector == @selector(Letterbox_setPreviewPaneLeft:)) && ([position isEqualToString:LetterboxPreviewPanePositionLeft]))
		|| ( (selector == @selector(Letterbox_setPreviewPaneBottom:)) && ([position isEqualToString:LetterboxPreviewPanePositionBottom]))
	);
}

- (BOOL) Letterbox_validateMenuItem:(NSMenuItem *)item
{
	SEL itemSelector = [item action];
	if (itemSelector == @selector(Letterbox_setPreviewPaneRight:)
		|| itemSelector == @selector(Letterbox_setPreviewPaneLeft:)
		|| itemSelector == @selector(Letterbox_setPreviewPaneBottom:)
		|| itemSelector == @selector(Letterbox_togglePreviewPane:)
		|| itemSelector == @selector(Letterbox_hidePreviewPane:)
		|| itemSelector == @selector(Letterbox_showPreviewPane:)
	) {
		// validate if we're not a single message viewer
		BOOL shouldValidate = ! ([self isKindOfClass:NSClassFromString(@"SingleMessageViewer")]);
		// Let's also take care of setting the state
		if (shouldValidate) {
			NSString *previewPanePosition = [[self Letterbox_splitView] Letterbox_previewPanePosition];
			if (itemSelector == @selector(Letterbox_setPreviewPaneRight:)
				|| itemSelector == @selector(Letterbox_setPreviewPaneLeft:)
				|| itemSelector == @selector(Letterbox_setPreviewPaneBottom:)) {
					[item setState:([self Letterbox_selector:itemSelector matchesPosition:previewPanePosition]) ?
						NSOnState : NSOffState];
			} else if (itemSelector == @selector(Letterbox_togglePreviewPane:)) {
				[item setTitle: ([self Letterbox_previewPaneVisible]) ?
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

- (IBAction) Letterbox_setPreviewPaneRight:(id)sender
{
	[self setLetterbox_previewPanePosition:LetterboxPreviewPanePositionRight];
}
- (IBAction) Letterbox_setPreviewPaneLeft:(id)sender
{
	[self setLetterbox_previewPanePosition:LetterboxPreviewPanePositionLeft];
}
- (IBAction) Letterbox_setPreviewPaneBottom:(id)sender
{
	[self setLetterbox_previewPanePosition:LetterboxPreviewPanePositionBottom];
}

- (IBAction) Letterbox_togglePreviewPane:(id)sender
{
	[self setLetterbox_previewPaneVisible:(! [self Letterbox_previewPaneVisible])];
}
- (IBAction) Letterbox_hidePreviewPane:(id)sender
{
	[self setLetterbox_previewPaneVisible:NO]; 
}
- (IBAction) Letterbox_showPreviewPane:(id)sender
{
	[self setLetterbox_previewPaneVisible:YES];
}
// --------------------------- accessors --------------------------
- (id) Letterbox_contentController {
	Ivar contentControllerIvar = class_getInstanceVariable(NSClassFromString(@"MessageViewer"), "_contentController");
	return object_getIvar(self, contentControllerIvar);
}

- (id) Letterbox_splitView {
	Ivar splitViewIvar = class_getInstanceVariable(NSClassFromString(@"MessageViewer"), "_splitView");
	return object_getIvar(self, splitViewIvar);
}

- (id) Letterbox_tableManager {
	Ivar tableManagerIvar = class_getInstanceVariable(NSClassFromString(@"MessageViewer"), "_tableManager");
	return object_getIvar(self, tableManagerIvar);
}

- (id) Letterbox_messageListTableView
{
	return [[[self Letterbox_splitView] Letterbox_messageListView] documentView];
}

- (BOOL) Letterbox_drawsAlternatingRowColors
{
	return [[self Letterbox_messageListTableView] usesAlternatingRowBackgroundColors];
}

- (void) setLetterbox_drawsAlternatingRowColors:(BOOL)drawAlternating
{
	[[self Letterbox_messageListTableView] setUsesAlternatingRowBackgroundColors:drawAlternating];
}

- (BOOL) Letterbox_drawsDividerLines
{
	return ([[self Letterbox_messageListTableView] gridStyleMask] == NSTableViewSolidHorizontalGridLineMask);
}

-(void) setLetterbox_drawsDividerLines:(BOOL)drawDividers
{
	[[self Letterbox_messageListTableView] setGridStyleMask:(drawDividers) ?
		NSTableViewSolidHorizontalGridLineMask
		: NSTableViewGridNone];	
}

- (NSString *)Letterbox_previewPanePosition
{
	return [[self Letterbox_splitView] Letterbox_previewPanePosition];
}
- (void)setLetterbox_previewPanePosition:(NSString *)position 
{
	// When we change this window, we'll also change the default. 
	// Dunno for sure whether that's the right thing to do.
	[[[LetterboxBundle sharedInstance] defaults] setObject:position forKey:LetterboxPreviewPanePositionKey];
	[[self Letterbox_splitView] setLetterbox_previewPanePosition:position];
}
- (BOOL) Letterbox_previewPaneVisible {
	return [[self Letterbox_splitView] Letterbox_previewPaneVisible];
}
- (void)setLetterbox_previewPaneVisible:(BOOL)visible {
	[[self Letterbox_splitView] setLetterbox_previewPaneVisible:visible];
}

@end
