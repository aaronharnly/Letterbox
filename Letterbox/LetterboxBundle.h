//
//  LetterboxBundle.h
//  Letterbox
//
//  Created by Aaron on 6/7/06.
//  Copyright 2006 Aaron Harnly.. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Foundation/Foundation.h>
#import "MVMailBundle.h"
#import "LetterboxExpandingSplitView.h"

@interface LetterboxBundle : MVMailBundle {
    NSMenu *previewPaneMenu;
    NSMenuItem *previewPaneItem;
    NSMenuItem *belowItem;
    NSMenuItem *rightItem;
    NSMenuItem *leftItem;
}
+ (void) initializePreferences;
+ (void) setPreferredPreviewPanePosition:(enum LetterboxPreviewPanePosition) position;

// -- menu stuff --
-(void) initializeMenu;
-(BOOL) validateMenuItem:(id <NSMenuItem>)menuItem;
// -- immediate changes to frontmost window --
-(void) setFrontmostPreviewPosition:(enum LetterboxPreviewPanePosition)position;
-(IBAction) setFrontmostPreviewPositionBelow:(id) sender;
-(IBAction) setFrontmostPreviewPositionRight:(id) sender;
-(IBAction) setFrontmostPreviewPositionLeft:(id) sender;

// accessors
-(NSMenuItem *)belowMenuItem;
-(NSMenuItem *)leftMenuItem;
-(NSMenuItem *)rightMenuItem;
-(NSMenuItem *)previewPaneMenuItem;
@end
