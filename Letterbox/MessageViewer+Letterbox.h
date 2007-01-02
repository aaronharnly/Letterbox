//
//  MessageViewer+Letterbox.h
//  Letterbox
//
//  Created by Aaron on 6/7/06.
//  Copyright 2006 Telefirma, Inc.. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MessageViewer.h"
#import "LetterboxExpandingSplitView.h"

@interface MessageViewer (MessageViewer_Letterbox)
// window status notifications
- (void)windowDidBecomeKey:(NSNotification *)aNotification;
- (void)windowDidResignKey:(NSNotification *)aNotification;
    // accessors
- (MessageContentController *) contentController; 
- (LetterboxExpandingSplitView *) splitView;

@end
