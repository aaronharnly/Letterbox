//
//  LetterboxExpandingSplitView.h
//  Letterbox
//
//  Created by Aaron on 6/7/06.
//  Copyright 2006  Aaron Harnly.. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ExpandingSplitView.h"

enum LetterboxPreviewPanePosition { LETTERBOX_PREVIEW_BELOW, LETTERBOX_PREVIEW_LEFT, LETTERBOX_PREVIEW_RIGHT };
enum LetterboxPaneOrder { LETTERBOX_LIST_FIRST, LETTERBOX_LIST_LAST };

@interface LetterboxExpandingSplitView : ExpandingSplitView 
{

}
// utilities for translating between preview pane positions and the string equivalents
+(NSString *) letterboxStringForPreviewPanePosition:(enum LetterboxPreviewPanePosition)position;
+(enum LetterboxPreviewPanePosition) letterboxPreviewPanePositionForString:(NSString *)position;

// overrides
-(void) awakeFromNib;

// custom
// methods to arrange the view
-(void) letterboxSetPaneOrder:(enum LetterboxPaneOrder)order;

-(void) letterboxSetFixedMessageList:(BOOL)isFixed;
-(void) letterboxSetPreviewPosition:(enum LetterboxPreviewPanePosition)position;
-(void) letterboxSetPreviewPositionFromString:(NSString *)position;

// getters
-(NSView *) letterboxMessagePaneView;
-(NSView *) letterboxMessageListView;
-(enum LetterboxPreviewPanePosition) letterboxPreviewPosition;
-(enum LetterboxPaneOrder) letterboxPaneOrder;

@end
