//
//  MessageContentController+Letterbox.h
//  Letterbox
//
//  Created by Aaron on 12/3/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
//#import "../AppleHeaders/MessageContentController.h"
@interface MessageContentController_Letterbox : NSObject
@property (readonly) id Letterbox_headerDisplay; // returns a MessageHeaderDisplay
@property (readonly) NSView *Letterbox_contentContainerView;
@end
