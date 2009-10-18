//
//  NSNumber+CGFloatSupport.h
//  Letterbox
//
//  Created by Aaron on 9/9/09.
//  Copyright 2009 Wireless Generation. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface NSNumber (CGFloatSupport)
+ (NSNumber *) numberWithCGFloat:(CGFloat)cgFloatValue;
- (CGFloat) cgFloatValue;
@end
