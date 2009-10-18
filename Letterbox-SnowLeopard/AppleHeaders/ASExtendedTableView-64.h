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
    long long _mfClickedRow;
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
- (void)scrollRowToVisible:(long long)arg1;
- (void)setTableColumn:(id)arg1 toVisible:(BOOL)arg2 atPosition:(long long)arg3;
- (void)moveColumn:(long long)arg1 toColumn:(long long)arg2;
- (id)dragImageForRowsWithIndexes:(id)arg1 tableColumns:(id)arg2 event:(id)arg3 offset:(struct CGPoint *)arg4;
- (void)draggedImage:(id)arg1 endedAt:(struct CGPoint)arg2 operation:(unsigned long long)arg3;
- (void)draggedImage:(id)arg1 movedTo:(struct CGPoint)arg2;
- (BOOL)shouldUseSecondaryHighlightColor;
- (void)_highlightRect:(struct CGRect)arg1 withColor:(id)arg2 usingStyle:(int)arg3;
- (void)_colorizeRow:(long long)arg1 inRect:(struct CGRect)arg2 clipRect:(struct CGRect)arg3;
- (void)drawBackgroundInClipRect:(struct CGRect)arg1;
- (void)drawRect:(struct CGRect)arg1;
- (void)drawRow:(long long)arg1 clipRect:(struct CGRect)arg2;
- (long long)clickedRow;
- (void)setMFClickedRow:(long long)arg1;
- (void)mouseDown:(id)arg1;
- (void)mouseUp:(id)arg1;
- (void)_postEventNotification:(id)arg1 fromCell:(id)arg2;
- (void)viewWillMoveToWindow:(id)arg1;
- (void)viewDidMoveToWindow;

@end
