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
- (void)Letterbox_forceRefresh;
- (CGFloat)Letterbox_dividerThickness;
- (void)Letterbox_drawDividerInRect:(NSRect)rect;

// --- accessors ---
@property (readonly) NSScrollView *Letterbox_messageListView;
@property (readonly) NSView *Letterbox_messagePaneView;
@property (copy) NSString *Letterbox_previewPanePosition;
@property (copy) NSString *Letterbox_dividerType;
@property enum LetterboxPaneOrder Letterbox_paneOrder;
@property CGFloat Letterbox_dividerThickness;
@end

@interface ExpandingSplitView_Letterbox (ExpandingSplitView)
- (void) setSubviews:(NSArray *)subviews;
- (BOOL) isVertical;
- (void) adjustSubviews;
- (NSArray *) subviews;
- (void) setVertical: (BOOL)newVertical;
- (id) animator;
@end


