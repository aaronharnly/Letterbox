//
//  MessageViewer+Letterbox.m
//  Letterbox
//
//  Created by Aaron on 6/7/06.
//  Copyright 2006 Telefirma, Inc.. All rights reserved.
//

#import "MessageViewer+Letterbox.h"
#import "LetterboxExpandingSplitView.h"
#import "LetterboxBundle.h"

@implementation MessageViewer (MessageViewer_Letterbox)
- (MessageContentController *) contentController {
    return _contentController;
}

- (LetterboxExpandingSplitView *) splitView {
    return (LetterboxExpandingSplitView *) _splitView;
}

// When a message viewer becomes key, we want to
//  set the view menu appropriately
- (void)windowDidBecomeKey:(NSNotification *)aNotification
{
    enum LetterboxPreviewPanePosition thisViewerPosition = [[self splitView] letterboxPreviewPosition];
    // set each menu item's status
    if (thisViewerPosition == LETTERBOX_PREVIEW_BELOW) {
	[[[LetterboxBundle sharedInstance] belowMenuItem] setState:NSOnState];
	[[[LetterboxBundle sharedInstance] leftMenuItem] setState:NSOffState];
	[[[LetterboxBundle sharedInstance] rightMenuItem] setState:NSOffState];	
    } else if (thisViewerPosition == LETTERBOX_PREVIEW_LEFT) {
	[[[LetterboxBundle sharedInstance] belowMenuItem] setState:NSOffState];
	[[[LetterboxBundle sharedInstance] leftMenuItem] setState:NSOnState];
	[[[LetterboxBundle sharedInstance] rightMenuItem] setState:NSOffState];	
    } else if (thisViewerPosition == LETTERBOX_PREVIEW_RIGHT) {
	[[[LetterboxBundle sharedInstance] belowMenuItem] setState:NSOffState];
	[[[LetterboxBundle sharedInstance] leftMenuItem] setState:NSOffState];
	[[[LetterboxBundle sharedInstance] rightMenuItem] setState:NSOnState];	
    }
}

- (void)windowDidResignKey:(NSNotification *)aNotification
{
    // clear all of the menu items
    [[[LetterboxBundle sharedInstance] belowMenuItem] setState:NSOffState];
    [[[LetterboxBundle sharedInstance] leftMenuItem] setState:NSOffState];
    [[[LetterboxBundle sharedInstance] rightMenuItem] setState:NSOnState];	
}
@end
