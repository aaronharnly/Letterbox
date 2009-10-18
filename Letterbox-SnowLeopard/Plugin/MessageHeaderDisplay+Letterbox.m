//
//  MessageHeaderDisplay+Letterbox.m
//  Letterbox
//
//  Created by Aaron on 12/3/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "MessageHeaderDisplay+Letterbox.h"
#import "NSObject+LetterboxSwizzle.h"
#import <objc/runtime.h>

@implementation MessageHeaderDisplay_Letterbox
+ (void) load {
	[MessageHeaderDisplay_Letterbox Letterbox_addMethod:@selector(headerView) toClassNamed:@"MessageHeaderDisplay"];
}

-(id)headerView // returns a MessageHeaderView
{
	Ivar headerViewIvar = class_getInstanceVariable(NSClassFromString(@"MessageHeaderDisplay"), "headerView");
	return object_getIvar(self, headerViewIvar);
}
@end
