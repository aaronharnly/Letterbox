#import <Cocoa/Cocoa.h>

@interface ColorBackgroundView : NSView
{
    NSColor *_color;
    NSImage *_image;
    NSArray *_colors;
    BOOL _isFlipped;
    CGFloat _rowHeight;
    CGFloat _rowOffset;
#ifdef __X86_64__
    long long _tag;
#else
    int _tag;
#endif	
}

- (void)dealloc;
- (BOOL)isOpaque;
- (void)drawRect:(struct CGRect)arg1;
#ifdef __X86_64__
@property(retain) NSColor *backgroundColor;
@property(retain) NSArray *backgroundColors;
- (id)colorForRow:(unsigned long long)arg1;
@property(retain) NSImage *backgroundImage; // @synthesize backgroundImage=_image;
@property(setter=setFlipped:) BOOL isFlipped; // @synthesize isFlipped=_isFlipped;
@property double rowOffset; // @synthesize rowOffset=_rowOffset;
@property double rowHeight; // @synthesize rowHeight=_rowHeight;
@property long long tag; // @synthesize tag=_tag;
#else
- (id)backgroundColor;
- (id)backgroundColors;
- (void)setBackgroundColors:(id)arg1;
- (void)setBackgroundColor:(id)arg1;
- (id)colorForRow:(unsigned long)arg1;
- (id)backgroundImage;
- (void)setBackgroundImage:(id)arg1;
- (BOOL)isFlipped;
- (void)setFlipped:(BOOL)arg1;
- (float)rowOffset;
- (void)setRowOffset:(float)arg1;
- (float)rowHeight;
- (void)setRowHeight:(float)arg1;
- (long)tag;
- (void)setTag:(long)arg1;
#endif

@end
