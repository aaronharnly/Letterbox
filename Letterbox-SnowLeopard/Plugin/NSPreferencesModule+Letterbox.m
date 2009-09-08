/*
 *  Created by Aaron Harnly on 11/24/07.
 *  Copyright 2007. You are welcome to use this source in your own projects,
 *  modify it as you see fit, and distribute the source and derived binaries, 
 *  so long as you retain this notice of authorship in the source code.
 */

#import "NSPreferencesModule+Letterbox.h"


@implementation NSPreferencesModule (Letterbox)
- (NSSize)minSize_Letterbox
{
	NSSize originalSize = [self minSize_Letterbox];
	// we might want to make this wider, so that the list of preferences modules
	// isn't cut off on the top.
//	return NSMakeSize(750.0, originalSize.height);
	return originalSize;
}

@end
