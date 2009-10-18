//
//  NSNumber+CGFloatSupport.m
//  Letterbox
//
//  Created by Aaron on 9/9/09.
//  Copyright 2009 Wireless Generation. All rights reserved.
//

#import "NSNumber+CGFloatSupport.h"

@implementation NSNumber (CGFloatSupport)

+ (NSNumber *) numberWithCGFloat: (CGFloat) cgFloatValue
{
	CFNumberRef cfVersion = CFNumberCreate(NULL, kCFNumberCGFloatType, &cgFloatValue);
	return [NSMakeCollectable(cfVersion) autorelease];
}

- (CGFloat) cgFloatValue
{
	CGFloat retVal = 0;
	CFNumberGetValue((CFNumberRef) self, kCFNumberCGFloatType, &retVal);
	return retVal;
}
@end