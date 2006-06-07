//
//  LetterboxBundle.m
//  Letterbox
//
//  Created by Aaron on 6/7/06.
//  Copyright 2006 Aaron Harnly.. All rights reserved.
//

#import "LetterboxBundle.h"
#import "LetterboxExpandingSplitView.h"

@implementation LetterboxBundle
+ (void) initialize
{
    NSBundle *myBundle;
    [super initialize];
    myBundle = [NSBundle bundleForClass:self];
    [self registerBundle];
    NSLog(@"Loaded Letterbox bundle");

    // take over the ExpandingSplitView
    NSLog(@"Posing...");
    [LetterboxExpandingSplitView poseAsClass:[ExpandingSplitView class]];
    
}
@end
