/*
 *  Created by Aaron Harnly on 11/6/07.
 *  Copyright 2007. You are welcome to use this source in your own projects,
 *  modify it as you see fit, and distribute the source and derived binaries, 
 *  so long as you retain this notice of authorship in the source code.
 */

#import "LetterboxBundleUpdaterDelegate.h"
#import "LetterboxBundle.h"

@implementation LetterboxBundleUpdaterDelegate
// Here you can add custom information to the anonymous system profile sent
//  with the SparklePlus update checker.
- (NSMutableArray *)updaterCustomizeProfileInfo:(NSMutableArray *)profileInfo
{
	NSArray *profileDictKeys = [NSArray arrayWithObjects:@"key", @"visibleKey", @"value", @"visibleValue", nil];

	// Get the UUID
	NSString *uuid = [[self defaults] objectForKey:@"UUID"];
	[profileInfo addObject:
		[NSDictionary dictionaryWithObjects:
			[NSArray arrayWithObjects:
				@"UUID",
				@"UUID",
				uuid,
				uuid,
				nil]
			forKeys:profileDictKeys]];
	

	// Get the Mail.app version
	NSString *mailVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
	[profileInfo addObject:
		[NSDictionary dictionaryWithObjects:
			[NSArray arrayWithObjects:
				@"mail_version",
				@"Mail.app version",
				mailVersion,
				mailVersion,
				nil]
			forKeys:profileDictKeys]];

	// Count the number of displays
	int numberOfScreens = [[NSScreen screens] count];
	[profileInfo addObject:
		[NSDictionary dictionaryWithObjects:
			[NSArray arrayWithObjects:
				@"display_count",
				@"Number of displays", 
				[NSNumber numberWithInt:numberOfScreens], 
				[NSNumber numberWithInt:numberOfScreens],
				nil] 
		forKeys:profileDictKeys]];

	// Get the size of each display
	int i;
	for(i=0; i < numberOfScreens; i++)
	{
		NSScreen *thisScreen = [[NSScreen screens] objectAtIndex:i];
		float width = [thisScreen frame].size.width;
		float height = [thisScreen frame].size.height;

		[profileInfo addObject:
			[NSDictionary dictionaryWithObjects:
				[NSArray arrayWithObjects:
					[NSString stringWithFormat:@"display_width_%d", i],
					[NSString stringWithFormat:@"Width of display %d", i],
					[NSNumber numberWithFloat:width], 
					[NSNumber numberWithFloat:width],
					nil] 
			forKeys:profileDictKeys]];
			
		[profileInfo addObject:
			[NSDictionary dictionaryWithObjects:
				[NSArray arrayWithObjects:
					[NSString stringWithFormat:@"display_height_%d", i],
					[NSString stringWithFormat:@"Height of display %d", i],
					[NSNumber numberWithFloat:height], 
					[NSNumber numberWithFloat:height],
					nil] 
			forKeys:profileDictKeys]];
			
	}
	
	return profileInfo;
}

- (NSUserDefaults *)defaults
{
	return [pluginController defaults];
}

- (NSUserDefaultsController *)defaultsController
{

	return [pluginController defaultsController];
}

- (LetterboxBundle *)pluginController
{
	return pluginController;
}

- (NSImage *)bundleIcon
{
	return [pluginController bundleIcon];
}

@end
