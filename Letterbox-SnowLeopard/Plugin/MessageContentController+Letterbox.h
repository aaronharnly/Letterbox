//
//  MessageContentController+Letterbox.h
//  Letterbox
//
//  Created by Aaron on 12/3/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "../AppleHeaders/MessageContentController.h"
@class MessageHeaderDisplay;
@interface MessageContentController (Letterbox)
- (MessageHeaderDisplay *) headerDisplay;
- (NSView *) contentContainerView;
@end
