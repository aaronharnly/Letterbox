//
//  AWHDynamicCategory.m
//
//  Created by Aaron Harnly on 10/24/09.
//  Copyright 2009 Aaron Harnly. You are welcome to use this code in your own projects. 
//  An email or blog post shoutout would be appreciated.
//

#import "AWHDynamicCategory.h"
#import "NSObject+LetterboxSwizzle.h"
#import <objc/runtime.h>

@implementation AWHDynamicCategory
/**
 * Must be implemented in subclasses. Return the name of the class you want to add methods to.
 */
+ (NSString *)targetClassName {
	[NSException raise:@"Abstract Class Exception" format:@"Subclasses must declare their target class name."];
	return NULL;
}

/**
 * Returns the dynamically resolved target class.
 */
+ (Class) targetClass {
	static Class target = NULL;
	if (target == NULL) {
		target = NSClassFromString([self targetClassName]);
	}
	return target;
}

/**
 * Returns the metaclass of the target class, for manipulating class methods.
 */
+ (Class) targetMetaClass {
	return object_getClass([self targetClass]);
}

+ (Ivar) targetIvarNamed:(NSString *)ivarName {
	return class_getInstanceVariable([self targetClass], [ivarName UTF8String]);
}

/**
 * Adds a method to a class or metaclass. Returns YES on success.
 */
+ (BOOL)_addMethod:(Method)sourceMethod toClass:(Class)targetClass {
	SEL selector = method_getName(sourceMethod);
	const char *signature = method_getTypeEncoding(sourceMethod);
	return class_addMethod(
		targetClass, 
		selector, 
		method_getImplementation(sourceMethod), 
		signature);
}

/**
 * Add the given instance method from this class to the target class.
 */
+ (void)_addInstanceMethod:(SEL)sel {
	Method sourceMethod = class_getInstanceMethod(self, sel);
	if (sourceMethod) {
		if ([self _addMethod:sourceMethod toClass:[self targetClass]]) {
			NSLog(@"Dynamic category %@: Added instance method '%@' to target class %@", self, NSStringFromSelector(sel), [self targetClassName]);
		} else
			NSLog(@"Dynamic category %@: FAILED to add instance method '%@' to target class %@", self, NSStringFromSelector(sel), [self targetClassName]);
	}
}

/**
 * Add the given class method from this class to the target class.
 */
+ (void)_addClassMethod:(SEL)sel {
	Method sourceMethod = class_getClassMethod(self, sel);
	if (sourceMethod) {
		if ([self _addMethod:sourceMethod toClass:[self targetMetaClass]]) {
//			NSLog(@"Dynamic category %@: Added class method '%@' to target class %@", self, NSStringFromSelector(sel), [self targetClassName]);
		} else
			NSLog(@"Dynamic category %@: FAILED to add class method '%@' to target class %@", self, NSStringFromSelector(sel), [self targetClassName]);
	}
}

/**
 * Swaps the implementations of the two given instance methods. 
 * Use this to substitute your own behavior for the standard behavior of a method on the target class.
 */
+ (void)swizzleTargetInstanceMethod:(SEL)selector1 withMethod:(SEL)selector2
{
	NSLog(@"Dynamic category %@: Swizzling instance method %@ with %@ in target class %@", self, NSStringFromSelector(selector1), NSStringFromSelector(selector2), [self targetClassName]);
	[[self targetClass] Letterbox_swizzleMethod:selector1 withMethod:selector2];
//    Method method1 = class_getInstanceMethod([self targetClass], selector1);
//	if (method1 == NULL) {
//		NSLog(@"FAILED because I couldn't find the method %@", NSStringFromSelector(selector1));
//		return;
//	}
//    Method method2 = class_getInstanceMethod([self targetClass], selector2);
//	if (method2 == NULL) {
//		NSLog(@"FAILED because I couldn't find the method %@", NSStringFromSelector(selector2));
//		return;
//	}
//    if(class_addMethod([self targetClass], selector1, method_getImplementation(method2), method_getTypeEncoding(method2))) {
//        class_replaceMethod([self targetClass], selector2, method_getImplementation(method1), method_getTypeEncoding(method1));
//	}
//    else {
//		method_exchangeImplementations(method1, method2);
//	}
}

/**
 * Swaps the implementations of the two given class methods. 
 * Use this to substitute your own behavior for the standard behavior of a method on the target class.
 */
+ (void)swizzleTargetClassMethod:(SEL)selector1 withMethod:(SEL)selector2
{
	NSLog(@"Dynamic category %@: Swizzling class method %@ with %@ in target class %@", self, NSStringFromSelector(selector1), NSStringFromSelector(selector2), [self targetClassName]);
    Method method1 = class_getClassMethod([self targetClass], selector1);
	if (method1 == NULL) {
		NSLog(@"FAILED because I couldn't find the method %@", NSStringFromSelector(selector1));
		return;
	}
    Method method2 = class_getClassMethod([self targetClass], selector2);
	if (method2 == NULL) {
		NSLog(@"FAILED because I couldn't find the method %@", NSStringFromSelector(selector2));
		return;
	}
    if(class_addMethod([self targetMetaClass], selector1, method_getImplementation(method2), method_getTypeEncoding(method2))) {
        class_replaceMethod([self targetMetaClass], selector2, method_getImplementation(method1), method_getTypeEncoding(method1));
	}
    else {
		method_exchangeImplementations(method1, method2);
	}
}

/**
 * Adds every instance method defined on this "dynamic category" to the target class.
 */
+ (void)addInstanceMethodsToTarget {
	unsigned int instanceMethodCount = 0;
	Method *instanceMethods = class_copyMethodList(self, &instanceMethodCount);
	NSLog(@"Dynamic category %@: Adding instance methods to target class %@", self, [self targetClassName]);
	if (instanceMethods != NULL) {
		int i;
		for (i = 0; i < instanceMethodCount; i++) {
			[self _addInstanceMethod:method_getName(instanceMethods[i])];
		}
	}
}

/**
 * Adds every class method (except +load and +targetClassName) defined on this "dynamic category" to the target class.
 */
+ (void)addClassMethodsToTarget {
	unsigned int classMethodCount = 0;
	Method *classMethods = class_copyMethodList(object_getClass(self), &classMethodCount);
	NSLog(@"Dynamic category %@: Adding class methods to target class %@", self, [self targetClassName]);
	if (classMethods != NULL) {
		int i;
		for (i = 0; i < classMethodCount; i++) {
			Method method = classMethods[i];
			SEL selector = method_getName(method);
			if (selector != @selector(load) && selector != @selector(targetClassName)) {
				[self _addClassMethod:selector];
			}
		}
	}
}

/**
 * Adds the instance and class methods defined on this "dynamic category" to the target class.
 */
+ (void)addMethodsToTarget {
	[self addInstanceMethodsToTarget];
	[self addClassMethodsToTarget];
}

@end
