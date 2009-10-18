//
//  MessageContentController+Letterbox.m
//  Letterbox
//
//  Created by Aaron on 12/3/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "MessageContentController+Letterbox.h"
#import "NSObject+LetterboxSwizzle.h"
#import <objc/runtime.h>

@implementation MessageContentController_Letterbox
+ (void) load {
	[MessageContentController_Letterbox Letterbox_addMethod:@selector(headerDisplay) toClassNamed:@"MessageContentController"];
	[MessageContentController_Letterbox Letterbox_addMethod:@selector(contentContainerView) toClassNamed:@"MessageContentController"];
}

- (id) headerDisplay // returns MessageHeaderDisplay
{
	Ivar headerDisplayIvar = class_getInstanceVariable(NSClassFromString(@"MessageContentController"), "headerDisplay");
	return object_getIvar(self, headerDisplayIvar);
}
- (NSView *) contentContainerView
{
	Ivar contentContainerViewIvar = class_getInstanceVariable(NSClassFromString(@"MessageContentController"), "contentContainer");
	return object_getIvar(self, contentContainerViewIvar);
}

@end
