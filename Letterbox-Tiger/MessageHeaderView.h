#import <Cocoa/Cocoa.h>

@interface MessageHeaderView : NSTextView
{
    NSMutableArray *trackingRectTags;
    BOOL isTrackingMouse;
}

- (void)awakeFromNib;
- (void)dealloc;
- (void)keyDown:(id)fp8;
- (void)mouseDown:(id)fp8;
- (void)trackHeaderAddresses:(id)fp8 replacingPreviousAddresses:(BOOL)fp12;
- (void)addressAtomsWereUpdated:(id)fp8;
- (void)addressAttachmentSizeChanged:(id)fp8;
- (void)addressAppearanceChanged:(id)fp8;
- (void)selectAll:(id)fp8;
- (void)originalSelectAll:(id)fp8;
- (void)setSelectedRange:(struct _NSRange)fp8 affinity:(int)fp16 stillSelecting:(BOOL)fp20;
- (void)setSelectedRange:(struct _NSRange)fp8;
- (struct _NSRange)selectionRangeForProposedRange:(struct _NSRange)fp8 granularity:(int)fp16;
- (id)dragImageForSelectionWithEvent:(id)fp8 origin:(struct _NSPoint *)fp12;
- (id)originalDragImageForSelectionWithEvent:(id)fp8 origin:(struct _NSPoint *)fp12;
- (struct _NSRect)_cellFrameForAttachment:(id)fp8 atCharIndex:(int)fp12;
- (void)_removeCursorRects;
- (void)resetCursorRects;
- (void)viewWillMoveToWindow:(id)fp8;
- (void)viewDidMoveToWindow;
- (void)didChangeText;
- (id)writablePasteboardTypes;
- (BOOL)writeSelectionToPasteboard:(id)fp8 type:(id)fp12;
- (id)menuForEvent:(id)fp8;
- (id)attachmentForPoint:(struct _NSPoint)fp8;
- (id)attachmentForEvent:(id)fp8;

@end