//
//  LetterboxExpandingSplitView.m
//  Letterbox
//
//  Created by Aaron on 6/7/06.
//  Copyright 2006  Aaron Harnly.. All rights reserved.
//

#import "LetterboxExpandingSplitView.h"


@implementation LetterboxExpandingSplitView
-(void) awakeFromNib 
{
    NSLog(@"Bwahaha! I am a LetterboxExpandingSplitView, and I shall always be vertical!");
    [self setVertical:YES];
}

- (void)drawRect:(NSRect) theRect
{
    ; // overriding this to do nothing works. don't ask me why.
}

- (float)dividerThickness
{
    return 3.0;
}
@end
