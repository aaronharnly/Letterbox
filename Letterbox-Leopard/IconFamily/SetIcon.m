//
//  SetIcon.m
//  MyPluginTemplate
//
//  Created by Aaron on 12/2/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IconFamily.h"

void showUsage()
{
	NSLog(@"Usage: SetIcon <icon-file> <destination>\n");
	exit(127);
}

void loadIconFromPathIntoPath(NSString *iconPath, NSString *destinationPath) {
	NSFileManager *manager = [NSFileManager defaultManager];

	// Error-check the icon path
	BOOL iconPathIsDirectory = NO;
	if (! [manager fileExistsAtPath:iconPath isDirectory:&iconPathIsDirectory]) {
		NSLog(@"No icon file was found at '%@'", iconPath);
		showUsage();
	}
	if (iconPathIsDirectory) {
		NSLog(@"A directory, not a file, was found at '%@'", iconPath);
		showUsage();
	}

	// Check the destination path
	BOOL destinationPathIsDirectory = NO;
	if (! [manager fileExistsAtPath:destinationPath isDirectory:&destinationPathIsDirectory]) {
		NSLog(@"No destination file or directory was found at '%@'", destinationPath);
		showUsage();
	}
	
	// Load the icon
	IconFamily *icon = [[IconFamily alloc] initWithContentsOfFile:iconPath];
	if (icon == nil) {
		NSLog(@"Couldn't laod an icon from the file: '%@'", iconPath);
		showUsage();
	}
	
	// And set!
	BOOL success = (destinationPathIsDirectory) ?
		[icon setAsCustomIconForDirectory:destinationPath withCompatibility:YES]
		: [icon setAsCustomIconForFile:destinationPath withCompatibility:YES];
	if (success) {
		NSLog(
			@"Set the icon for %@: '%@'", 
			(destinationPathIsDirectory) ? @"directory" : @"file",
			destinationPath
		);
	} else {
		NSLog(@"Failed to set the icon for: '%@'", destinationPath);		
		exit(1);
	}
}

int main (int argc, const char * argv[]) {
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];

	// Usage: SetIcon <icon-file.icns> <destination>
	if (argc != 3) {
		showUsage();
	}
	NSString *iconPath = [NSString stringWithCString:argv[1] encoding:NSUTF8StringEncoding];
	NSString *destinationPath = [NSString stringWithCString:argv[2] encoding:NSUTF8StringEncoding];
	
	loadIconFromPathIntoPath(iconPath, destinationPath);
	
    [pool drain];
    return 0;
}
