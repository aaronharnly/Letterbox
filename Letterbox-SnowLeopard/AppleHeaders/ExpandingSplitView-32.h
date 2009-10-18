#import <Cocoa/Cocoa.h>

@interface ExpandingSplitView : NSSplitView
{
    int dividerToolTipTag;
    NSString *toolTipString;
    NSImage *splitterDimple;
    NSImage *splitterBackground;
    float _dividerThickness;
    int _dividerType;
}

- (void)dealloc;
- (int)dividerType;
- (void)setDividerType:(int)arg1;
- (float)getSplitPercentage;
- (BOOL)_isSubviewAtIndexVisible:(unsigned int)arg1;
- (BOOL)isSecondViewVisible;
- (BOOL)isFirstViewVisible;
- (void)resizeSubviewsToPercentage:(float)arg1;
- (void)setDividerToolTip:(id)arg1;
- (float)dividerThickness;
- (struct _NSRect)_dividerRect;
- (void)drawDividerInRect:(struct _NSRect)arg1;
- (id)accessibilityAttributeValue:(id)arg1;

@end
