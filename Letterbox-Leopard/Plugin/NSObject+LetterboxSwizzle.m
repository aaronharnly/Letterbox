/*
 *  Created by Aaron Harnly on 11/4/07.
 *  Copyright 2007. You are welcome to use this source in your own projects,
 *  modify it as you see fit, and distribute the source and derived binaries, 
 *  so long as you retain this notice of authorship in the source code.
 */
// This is a modification of the work by Kevin Ballard at:
// http://kevin.sb.org/articles/2006/12/30/method-swizzling-reimplemented#comments
//
// borrowed from http://www.cocoadev.com/index.pl?MethodSwizzling
// 
//  Also incorporates ideas an implementation from Marc Charbonneau's
//  nice work here:
//  http://blog.downtownsoftwarehouse.com/2006/11/10/add-instance-variables-through-a-category/
//
//  Copyright (c) 2006 Tildesoft. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a
//  copy of this software and associated documentation files (the "Software"),
//  to deal in the Software without restriction, including without limitation
//  the rights to use, copy, modify, merge, publish, distribute, sublicense,
//  and/or sell copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
//  DEALINGS IN THE SOFTWARE.
// Implementation of Method Swizzling, inspired by
// http://www.cocoadev.com/index.pl?MethodSwizzling
// solves the inherited method problem


#import "NSObject+LetterboxSwizzle.h"
#import <objc/objc-runtime.h>

static BOOL _Letterbox_PerformSwizzle(Class klass, SEL origSel, SEL altSel, BOOL forInstance);

// if the origSel isn't present in the class, pull it up from where it exists
// then do the swizzle
BOOL _Letterbox_PerformSwizzle(Class klass, SEL origSel, SEL altSel, BOOL forInstance) {
	NSString *origSelName = NSStringFromSelector(origSel);
	NSString *altSelName = NSStringFromSelector(altSel);

    // First, make sure the class isn't nil
	if (klass == nil) {
		NSLog(@"...failed, because the target class is nil");
		return NO;
	}
	Method origMethod = NULL, altMethod = NULL;
	
	// Next, look for the methods
	Class iterKlass = (forInstance ? klass : klass->isa);
	unsigned int methodCount = 0;
	Method *mlist = class_copyMethodList(iterKlass, &methodCount);
	if (mlist != NULL) {
		int i;
		for (i = 0; i < methodCount; ++i) {
			
			if (method_getName(mlist[i]) == origSel) {
				origMethod = mlist[i];
				break;
			}
			if (method_getName(mlist[i]) == altSel) {
				altMethod = mlist[i];
				break;
			}
		}
	}
	
	if (origMethod == NULL || altMethod == NULL) {
		// one or both methods are not in the immediate class
		// try searching the entire hierarchy
		// remember, iterKlass is the class we care about - klass || klass->isa
		// class_getInstanceMethod on a metaclass is the same as class_getClassMethod on the real class
		BOOL pullOrig = NO, pullAlt = NO;
		if (origMethod == NULL) {
			origMethod = class_getInstanceMethod(iterKlass, origSel);
			pullOrig = YES;
		}
		if (altMethod == NULL) {
			altMethod = class_getInstanceMethod(iterKlass, altSel);
			pullAlt = YES;
		}
		
		// die now if one of the methods doesn't exist anywhere in the hierarchy
		// this way we won't make any changes to the class if we can't finish
		if (origMethod == NULL) {
			NSLog(@"...failed, because the method %@ couldn't be found.", origSelName);
			return NO;
		}
		if (altMethod == NULL) {
			NSLog(@"...failed, because the method %@ couldn't be found.", altSelName);
			return NO;
		}
		
		// we can safely assume one of the two methods, at least, will be pulled
		// pull them up
		size_t listSize = sizeof(Method);
		if (pullOrig && pullAlt) listSize += sizeof(Method); // need 2 methods
		if (pullOrig) {
			class_addMethod(iterKlass, method_getName(origMethod), method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
		}
		if (pullAlt) {
			class_addMethod(iterKlass, method_getName(altMethod), method_getImplementation(altMethod), method_getTypeEncoding(altMethod));
		}
	}
	
	// now swizzle
	method_exchangeImplementations(origMethod, altMethod);
	NSLog(@"...succeeded!");
	return YES;
}


@implementation NSObject(LetterboxSwizzle)

+ (void)Letterbox_swizzleMethod:(SEL)orig_sel withMethod:(SEL)alt_sel {
    NSString *originalMethodName = [NSString stringWithCString:sel_getName(orig_sel)];
    NSString *alternateMethodName = [NSString stringWithCString:sel_getName(alt_sel)];    
    NSLog(@"Attempting to swizzle in class '%@': swapping method '%@' with '%@'...",[self class], originalMethodName, alternateMethodName);
	
	_Letterbox_PerformSwizzle([self class], orig_sel, alt_sel, YES);
}

+ (void)Letterbox_swizzleClassMethod:(SEL)orig_sel withClassMethod:(SEL)alt_sel {
    NSString *originalMethodName = [NSString stringWithCString:sel_getName(orig_sel)];
    NSString *alternateMethodName = [NSString stringWithCString:sel_getName(alt_sel)];    
    NSLog(@"Attempting to swizzle in class '%@': swapping class method '%@' with '%@'...",[self class], originalMethodName, alternateMethodName);
	_Letterbox_PerformSwizzle([self class], orig_sel, alt_sel, NO);
}


+ (void)Letterbox_replaceMethod:(SEL)orig_sel withMethod:(SEL)alt_sel fromClass:(Class)targetClass {
    NSString *originalMethodName = [NSString stringWithCString:sel_getName(orig_sel)];
    NSString *alternateMethodName = [NSString stringWithCString:sel_getName(alt_sel)];    	
    NSLog(@"Attempting to replace class \"%@\"'s method \"%@\" with class \"%@\"'s method \"%@\"...",[self class],originalMethodName,targetClass,alternateMethodName);

    // First, look for the methods
    Method orig_method = nil, alt_method = nil;
    orig_method = class_getInstanceMethod([self class], orig_sel);
    alt_method = class_getInstanceMethod(targetClass, alt_sel);
	
    // If both are found, replace!
    if ((orig_method != nil) && (alt_method != nil)) {
		method_setImplementation(orig_method, method_getImplementation(alt_method));
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

- (id)Letterbox_performSelector:(SEL)sel asClass:(Class)cls {
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

// ----------- jerry-rigged ivars support -----------------
static NSMutableDictionary *Letterbox_instanceIDToIvars = nil;
static BOOL Letterbox_needToSwizzleDealloc = YES;


- (id)Letterbox_instanceID
{
    return [NSValue valueWithPointer:self];
}

- (NSMutableDictionary *)Letterbox_ivars
{
    NSMutableDictionary *ivars;
    
    if (Letterbox_needToSwizzleDealloc)
    {
	[[self class] Letterbox_swizzleMethod:@selector(dealloc) withMethod:@selector(deallocSwizzler)]; 
    	Letterbox_needToSwizzleDealloc = NO;
    }
    
    if (Letterbox_instanceIDToIvars == nil)
    {
        Letterbox_instanceIDToIvars = [[NSMutableDictionary alloc] init];
    }
    
    ivars = [Letterbox_instanceIDToIvars objectForKey:[self Letterbox_instanceID]];
    if (ivars == nil)
    {
        ivars = [NSMutableDictionary dictionary];
        [Letterbox_instanceIDToIvars setObject:ivars forKey:[self Letterbox_instanceID]];
    }
    
    return ivars;
}

- (void)Letterbox_deallocSwizzler
{
    [Letterbox_instanceIDToIvars removeObjectForKey:[self Letterbox_instanceID]];
    if ([Letterbox_instanceIDToIvars count] == 0)
    {
        [Letterbox_instanceIDToIvars release];
        Letterbox_instanceIDToIvars = nil;
    }
    
	// call the original dealloc method
    [self Letterbox_deallocSwizzler];
}
@end

