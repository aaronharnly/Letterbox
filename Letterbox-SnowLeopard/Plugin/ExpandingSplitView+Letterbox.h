//
//  ExpandingSplitView+Letterbox.h
//  Letterbox
//
//  Created by Aaron on 12/3/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
//#import "../AppleHeaders/ExpandingSplitView.h"
#import "LetterboxConstants.h"

@interface ExpandingSplitView_Letterbox : NSObject
// --- overrides --
// --- methods ---
- (void)forceRefresh;
- (CGFloat)Letterbox_dividerThickness;
- (void)Letterbox_drawDividerInRect:(NSRect)rect;

// --- accessors ---
@property (readonly) NSScrollView *messageListView;
@property (readonly) NSView *messagePaneView;
@property (copy) NSString *previewPanePosition;
@property (copy) NSString *letterboxDividerType;
@property enum LetterboxPaneOrder paneOrder;
@property CGFloat dividerThickness;
@end

@interface ExpandingSplitView_Letterbox (ExpandingSplitView)
- (BOOL) isVertical;
- (void) adjustSubviews;
- (NSArray *) subviews;
- (void) setVertical: (BOOL)newVertical;
- (id) animator;
@end


