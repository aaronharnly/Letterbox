//
//  ExpandingSplitView+Letterbox.h
//  Letterbox
//
//  Created by Aaron on 12/3/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "../AppleHeaders/ExpandingSplitView.h"
#import "LetterboxConstants.h"

@interface ExpandingSplitView (Letterbox)
// --- overrides --
- (float)Letterbox_dividerThickness;
- (void)Letterbox_drawDividerInRect:(NSRect)rect;
// --- methods ---
- (void)forceRefresh;

// --- accessors ---
@property float dividerThickness;
@property (readonly) NSScrollView *messageListView;
@property (readonly) NSView *messagePaneView;
@property (copy) NSString *previewPanePosition;
@property (copy) NSString *letterboxDividerType;
@property enum LetterboxPaneOrder paneOrder;
@end
