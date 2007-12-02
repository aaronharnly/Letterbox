//
//  NSObject+Swizzle.m
//  Letterbox
//
//  Created by Aaron on 6/9/06.
//  Copyright 2006 Telefirma, Inc.. All rights reserved.
//

// borrowed from http://www.cocoadev.com/index.pl?MethodSwizzling

#import "NSObject+Swizzle.h"
#import </usr/include/objc/objc-class.h>

@implementation NSObject(Swizzle)

+ (void)swizzleMethod:(SEL)orig_sel withMethod:(SEL)alt_sel {
    NSString *originalMethodName = [NSString stringWithCString:sel_getName(orig_sel)];
    NSString *alternateMethodName = [NSString stringWithCString:sel_getName(alt_sel)];    
    NSLog(@"Attempting to swizzle in class '%@': swapping method '%@' with '%@'...",[self class], originalMethodName, alternateMethodName);
	
    // First, look for the methods
    Method orig_method = nil, alt_method = nil;
    orig_method = class_getInstanceMethod([self class], orig_sel);
    alt_method = class_getInstanceMethod([self class], alt_sel);
	
    // If both are found, swizzle them
    if ((orig_method != nil) && (alt_method != nil)) {
        char *temp1;
        IMP temp2;
		
        temp1 = orig_method->method_types;
        orig_method->method_types = alt_method->method_types;
        alt_method->method_types = temp1;
		
        temp2 = orig_method->method_imp;
        orig_method->method_imp = alt_method->method_imp;
        alt_method->method_imp = temp2;
	NSLog(@"  ...succeeded!");
    } else {
	if (orig_method == nil) {
	    NSLog(@"    ...ERROR: original method '%@' doesn't exist",originalMethodName);
	}
	if (alt_method == nil) {
	    NSLog(@"    ...ERROR: alternate method '%@' doesn't exist",alternateMethodName);
	}
    }
}

+ (void)replaceMethod:(SEL)orig_sel withMethod:(SEL)alt_sel fromClass:(Class)targetClass {
    NSString *originalMethodName = [NSString stringWithCString:sel_getName(orig_sel)];
    NSString *alternateMethodName = [NSString stringWithCString:sel_getName(alt_sel)];    	
    NSLog(@"Attempting to replace class \"%@\"'s method \"%@\" with class \"%@\"'s method \"%@\"...",[self class],originalMethodName,targetClass,alternateMethodName);

    // First, look for the methods
    Method orig_method = nil, alt_method = nil;
    orig_method = class_getInstanceMethod([self class], orig_sel);
    alt_method = class_getInstanceMethod(targetClass, alt_sel);
	
    // If both are found, replace!
    if ((orig_method != nil) && (alt_method != nil)) {	
	orig_method->method_types = alt_method->method_types;
	orig_method->method_imp = alt_method->method_imp;
	NSLog(@"   ...succeeded!");
    } else {
	if (orig_method == nil) {
	    NSLog(@"    ...ERROR: original method '%@' doesn't exist",originalMethodName);
	}
	if (alt_method == nil) {
	    NSLog(@"    ...ERROR: alternate method '%@' doesn't exist",alternateMethodName);
	}
    }
}

- (id)performSelector:(SEL)sel asClass:(Class)cls {
    Class wasa = [self class];
    id result;

    NS_DURING {
        isa = cls;
        result = [self performSelector:sel];
        isa = wasa;
    } NS_HANDLER {
        isa = wasa;
        [localException raise];
    } NS_ENDHANDLER;

    return result;
}

// ----------- poseAsClass support -----------------
static NSMutableDictionary *swizzle_instanceIDToIvars = nil;
static BOOL swizzle_needToSwizzleDealloc = YES;


- (id)swizzle_instanceID
{
    return [NSValue valueWithPointer:self];
}

- (NSMutableDictionary *)swizzle_ivars
{
    NSMutableDictionary *ivars;
    
    if (swizzle_needToSwizzleDealloc)
    {
	[[self class] swizzleMethod:@selector(dealloc) withMethod:@selector(swizzle_deallocSwizzler)]; 
    	swizzle_needToSwizzleDealloc = NO;
    }
    
    if (swizzle_instanceIDToIvars == nil)
    {
        swizzle_instanceIDToIvars = [[NSMutableDictionary alloc] init];
    }
    
    ivars = [swizzle_instanceIDToIvars objectForKey:[self swizzle_instanceID]];
    if (ivars == nil)
    {
        ivars = [NSMutableDictionary dictionary];
        [swizzle_instanceIDToIvars setObject:ivars forKey:[self swizzle_instanceID]];
    }
    
    return ivars;
}

- (void)swizzle_deallocSwizzler
{
    [swizzle_instanceIDToIvars removeObjectForKey:[self swizzle_instanceID]];
    if ([swizzle_instanceIDToIvars count] == 0)
    {
        [swizzle_instanceIDToIvars release];
        swizzle_instanceIDToIvars = nil;
    }
    
    [self swizzle_deallocSwizzler];
}
@end

