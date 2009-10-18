#import <Cocoa/Cocoa.h>

@interface ExpandingSplitView : NSSplitView
{
    long long dividerToolTipTag;
    NSString *toolTipString;
    NSImage *splitterDimple;
    NSImage *splitterBackground;
    double _dividerThickness;
    int _dividerType;
}

- (void)dealloc;
- (int)dividerType;
- (void)setDividerType:(int)arg1;
- (double)getSplitPercentage;
- (BOOL)_isSubviewAtIndexVisible:(unsigned long long)arg1;
- (BOOL)isSecondViewVisible;
- (BOOL)isFirstViewVisible;
- (void)resizeSubviewsToPercentage:(double)arg1;
- (void)setDividerToolTip:(id)arg1;
- (double)dividerThickness;
- (struct CGRect)_dividerRect;
- (void)drawDividerInRect:(struct CGRect)arg1;
- (id)accessibilityAttributeValue:(id)arg1;

@end
