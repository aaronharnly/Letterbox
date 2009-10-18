#import <Cocoa/Cocoa.h>

@interface ASExtendedTableView : NSTableView
{
    struct {
        unsigned int delegateProvidesDragImage:1;
        unsigned int delegateDoesCommandBySelector:1;
        unsigned int delegateDragWillEndOperation:1;
        unsigned int delegateDraggedImageMovedTo:1;
        unsigned int delegateProvidesBackgroundShadedRegions:1;
        unsigned int delegateProvidesHighlightStyle:1;
        unsigned int delegateRespondsToWillDrawRowsInRange:1;
        unsigned int delegateRespondsToDidDrawRowsInRange:1;
        unsigned int delegateApprovesScrolling:1;
        unsigned int delegateRespondsToGotEvent:1;
        unsigned int delegateRespondsToMouseDown:1;
        unsigned int delegateRespondsToWillMoveToWindow:1;
        unsigned int delegateRespondsToDidMoveToWindow:1;
        unsigned int delegateRespondsToWillStartLiveResize:1;
        unsigned int delegateRespondsToDidEndLiveResize:1;
    } _extendedTableViewFlags;
    BOOL _didLazyLoadMenu;
    int _mfClickedRow;
}

- (id)extendedDelegate;
- (id)menuForEvent:(id)arg1;
- (void)awakeFromNib;
- (void)finalize;
- (void)viewWillStartLiveResize;
- (void)viewDidEndLiveResize;
- (void)keyDown:(id)arg1;
- (void)setDelegate:(id)arg1;
- (id)menu;
- (void)showTableColumnsFromArray:(id)arg1 allColumns:(id)arg2;
- (void)scrollRowToVisible:(int)arg1;
- (void)setTableColumn:(id)arg1 toVisible:(BOOL)arg2 atPosition:(int)arg3;
- (void)moveColumn:(int)arg1 toColumn:(int)arg2;
- (id)dragImageForRowsWithIndexes:(id)arg1 tableColumns:(id)arg2 event:(id)arg3 offset:(struct _NSPoint *)arg4;
- (void)draggedImage:(id)arg1 endedAt:(struct _NSPoint)arg2 operation:(unsigned int)arg3;
- (void)draggedImage:(id)arg1 movedTo:(struct _NSPoint)arg2;
- (BOOL)shouldUseSecondaryHighlightColor;
- (void)_highlightRect:(struct _NSRect)arg1 withColor:(id)arg2 usingStyle:(int)arg3;
- (void)_colorizeRow:(int)arg1 inRect:(struct _NSRect)arg2 clipRect:(struct _NSRect)arg3;
- (void)drawBackgroundInClipRect:(struct _NSRect)arg1;
- (void)drawRect:(struct _NSRect)arg1;
- (void)drawRow:(int)arg1 clipRect:(struct _NSRect)arg2;
- (int)clickedRow;
- (void)setMFClickedRow:(int)arg1;
- (void)mouseDown:(id)arg1;
- (void)mouseUp:(id)arg1;
- (void)_postEventNotification:(id)arg1 fromCell:(id)arg2;
- (void)viewWillMoveToWindow:(id)arg1;
- (void)viewDidMoveToWindow;

@end
