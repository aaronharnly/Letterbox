#import <Cocoa/Cocoa.h>

@interface ColorBackgroundView : NSView
{
    long long _tag;
    NSColor *_color;
    NSImage *_image;
    NSArray *_colors;
    BOOL _isFlipped;
    double _rowHeight;
    double _rowOffset;
}

- (void)dealloc;
- (BOOL)isOpaque;
@property(retain) NSColor *backgroundColor;
@property(retain) NSArray *backgroundColors;
- (void)drawRect:(struct CGRect)arg1;
- (id)colorForRow:(unsigned long long)arg1;
@property(retain) NSImage *backgroundImage; // @synthesize backgroundImage=_image;
@property(setter=setFlipped:) BOOL isFlipped; // @synthesize isFlipped=_isFlipped;
@property double rowOffset; // @synthesize rowOffset=_rowOffset;
@property double rowHeight; // @synthesize rowHeight=_rowHeight;
@property long long tag; // @synthesize tag=_tag;

@end
