//
//  LetterboxBundle.m
//  Letterbox
//
//  Created by Aaron on 6/7/06.
//  Copyright 2006 Aaron Harnly.. All rights reserved.
//

#import "LetterboxBundle.h"
// swizzling
#import "NSObject+Swizzle.h"

// models
// views
#import "MessageViewer.h"
#import "LetterboxExpandingSplitView.h"
#import "MessageViewer+Letterbox.h"
#import "MessageContentController+Letterbox.h"
// controllers

#define LETTERBOX_ARRANGE_MENU_TAG 1532

@implementation LetterboxBundle
+ (void) initialize
{
    NSBundle *myBundle;
    [super initialize];
    myBundle = [NSBundle bundleForClass:self];
    [self registerBundle];
    NSLog(@"Loaded Letterbox bundle");
    
    // Step 0: Initialize preferences
    [self initializePreferences];
    
    // Step 1: Pose
    [LetterboxExpandingSplitView poseAsClass:[ExpandingSplitView class]];
//    [LetterboxMessageViewer poseAsClass:[MessageViewer class]];

    // Step 2: Swizzle
    
    // Step 3: Replace
//    [LetterboxExpandingSplitView replaceMethod:@selector(adjustSubviews) withMethod:@selector(adjustSubviews) fromClass:[NSSplitView class]];
//    [ExpandingSplitView replaceMethod:@selector(awakeFromNib) withMethod:@selector(awakeFromNib) fromClass:[LetterboxExpandingSplitView class]];

}

+(void) initializePreferences
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *positionString = [LetterboxExpandingSplitView letterboxStringForPreviewPanePosition:LETTERBOX_PREVIEW_RIGHT];
    NSDictionary *appDefaults = [NSDictionary dictionaryWithObject:positionString forKey:@"LetterboxPreviewPanePosition"];
    [defaults registerDefaults:appDefaults];    
}

// ------- persistent changes to preferences --------
+(void) setPreferredPreviewPanePosition:(enum LetterboxPreviewPanePosition) position
{
    NSString *positionString = [LetterboxExpandingSplitView letterboxStringForPreviewPanePosition:position];
    [[NSUserDefaults standardUserDefaults] setObject:positionString forKey:@"LetterboxPreviewPanePosition"];
}

// ====================== Instance methods ======================

// ------ immediate changes to frontmost window ------------
-(MessageViewer *) frontmostMessageViewer
{
    NSWindow *frontmostWindow = [NSApp keyWindow];
    if ([[frontmostWindow delegate] isMemberOfClass:[MessageViewer class]]) {
	return (MessageViewer *) [frontmostWindow delegate];
    } else {
	return nil;
    }
}

-(void) setFrontmostPreviewPosition:(enum LetterboxPreviewPanePosition)position
{
    MessageViewer *frontmostViewer = [self frontmostMessageViewer];
    if (frontmostViewer != nil) {
	[[frontmostViewer splitView] letterboxSetPreviewPosition: position];
	[LetterboxBundle setPreferredPreviewPanePosition: position];
    }
}

-(IBAction) setFrontmostPreviewPositionBelow:(id) sender
{
    [self setFrontmostPreviewPosition: LETTERBOX_PREVIEW_BELOW];
}
-(IBAction) setFrontmostPreviewPositionRight:(id) sender
{
    [self setFrontmostPreviewPosition: LETTERBOX_PREVIEW_RIGHT];
}
-(IBAction) setFrontmostPreviewPositionLeft:(id) sender
{
    [self setFrontmostPreviewPosition: LETTERBOX_PREVIEW_LEFT];
}


// ------ initialize menus --------

-(void) initializeMenu
{
    // check whether we have our menu items installed
    NSMenu *viewMenu = [[[NSApp mainMenu] itemAtIndex:3] submenu];
    NSMenuItem *existingPreviewPane = [viewMenu itemWithTag:LETTERBOX_ARRANGE_MENU_TAG];
    
    // install the menu items if necessary
    if (existingPreviewPane == nil) {
	
	previewPaneItem = [[NSMenuItem alloc] initWithTitle:NSLocalizedStringFromTableInBundle(@"Arrange Menu Title",@"Localizable",[NSBundle bundleForClass: [LetterboxBundle class]], nil) action:NULL keyEquivalent:@""];
	[previewPaneItem setTag:LETTERBOX_ARRANGE_MENU_TAG];
	previewPaneMenu = [[NSMenu alloc] initWithTitle:@"Arrange Message Preview Pane SUB"];
	belowItem = [[NSMenuItem alloc] initWithTitle:NSLocalizedStringFromTableInBundle(@"Below Message List", @"Localizable",[NSBundle bundleForClass: [LetterboxBundle class]], nil) action:@selector(setFrontmostPreviewPositionBelow:) keyEquivalent:@""];
	rightItem = [[NSMenuItem alloc] initWithTitle:NSLocalizedStringFromTableInBundle(@"Right of Message List",@"Localizable",[NSBundle bundleForClass: [LetterboxBundle class]], nil) action:@selector(setFrontmostPreviewPositionRight:) keyEquivalent:@""];
	leftItem = [[NSMenuItem alloc] initWithTitle:NSLocalizedStringFromTableInBundle(@"Left of Message List",@"Localizable",[NSBundle bundleForClass: [LetterboxBundle class]], nil) action:@selector(setFrontmostPreviewPositionLeft:) keyEquivalent:@""];
	
	[belowItem setTarget:self];
	[rightItem setTarget:self];
	[leftItem setTarget:self];
	
	[previewPaneMenu addItem:belowItem];
	[previewPaneMenu addItem:rightItem];
	[previewPaneMenu addItem:leftItem];
		
	// add to view menu
	[viewMenu insertItem:previewPaneItem atIndex:0];
	[viewMenu setSubmenu:previewPaneMenu forItem:previewPaneItem];
    }
}

- (BOOL)validateMenuItem:(id <NSMenuItem>)menuItem
{
    // check if it's one of ours
    if (menuItem == [self belowMenuItem]
	|| menuItem == [self rightMenuItem]
	|| menuItem == [self leftMenuItem]
	|| menuItem == [self previewPaneMenuItem]
	) 
    {
	// return YES if and only if the frontmost window is a message viewer
	if ([self frontmostMessageViewer] != nil)
	    return YES;
	else
	    return NO;
    }
    return NO;	
}

// ----------------- accessors ---------------------

-(NSMenuItem *)belowMenuItem {
    return belowItem;
}
-(NSMenuItem *)leftMenuItem {
    return leftItem;
}
-(NSMenuItem *)rightMenuItem {
    return rightItem;
}
-(NSMenuItem *)previewPaneMenuItem {
    return previewPaneItem;
}

@end
