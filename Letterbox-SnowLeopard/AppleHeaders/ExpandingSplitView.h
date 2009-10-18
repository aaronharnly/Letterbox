#import <Cocoa/Cocoa.h>

@interface ExpandingSplitView : NSSplitView
{
    NSString *toolTipString;
    NSImage *splitterDimple;
    NSImage *splitterBackground;
    int _dividerType;
    CGFloat _dividerThickness;
#ifdef __X86_64__
    long long dividerToolTipTag;
#else
    int dividerToolTipTag;
#endif
	
}

- (void)dealloc;
- (int)dividerType;
- (void)setDividerType:(int)arg1;
- (BOOL)isSecondViewVisible;
- (BOOL)isFirstViewVisible;
- (void)setDividerToolTip:(id)arg1;
- (id)accessibilityAttributeValue:(id)arg1;
- (void)drawDividerInRect:(NSRect)arg1;
- (NSRect)_dividerRect;
- (CGFloat)dividerThickness;
- (CGFloat)getSplitPercentage;
- (void)resizeSubviewsToPercentage:(CGFloat)arg1;
#ifdef __X86_64__
- (BOOL)_isSubviewAtIndexVisible:(unsigned long long)arg1;
#else
- (BOOL)_isSubviewAtIndexVisible:(unsigned int)arg1;
#endif
@end
