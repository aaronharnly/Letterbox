//
//  MessageContentController+Letterbox.h
//  Letterbox
//
//  Created by Aaron on 6/7/06.
//  Copyright 2006 Telefirma, Inc.. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MessageContentController.h"

@interface MessageContentController (MessageContentController_Letterbox)
- (MessageHeaderDisplay *) headerDisplay;
- (NSView *) contentContainerView;
@end
