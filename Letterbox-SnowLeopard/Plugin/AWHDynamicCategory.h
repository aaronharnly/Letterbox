//
//  AWHSelfLoadingCategory.h
//
//  Created by Aaron Harnly on 10/24/09.
//  Copyright 2009 Aaron Harnly. You are welcome to use this code in your own projects. 
//  An email or blog post shoutout would be appreciated.
//

#import <Cocoa/Cocoa.h>
#import <objc/runtime.h>


@interface AWHDynamicCategory : NSObject {
}
// To be implemented by subclasses
+ (NSString *) targetClassName;

// Supplied
+ (Class) targetClass;
+ (Class) targetMetaClass;
+ ( Ivar ) targetIvarNamed:(NSString *)ivarName;
+ (void) addMethodsToTarget;
+ (void) swizzleTargetInstanceMethod:(SEL)selector1 withMethod:(SEL)selector2;
+ (void) swizzleTargetClassMethod:(SEL)selector1 withMethod:(SEL)selector2;
@end
