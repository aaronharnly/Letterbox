//
//  SUUtilities.h
//  Sparkle
//
//  Created by Andy Matuschak on 3/12/06.
//  Copyright 2006 Andy Matuschak. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface SUUtilities : NSObject
+(NSString *)localizedStringForKey:(NSString *)key withComment:(NSString *)comment;

+(NSBundle *)bundleToUpdate;
+(void)setBundleToUpdate:(NSBundle *)aBundle;

+(NSImage *)bundleIcon;
+(void)setBundleIcon:(NSImage *)anImage;
@end

id SUInfoValueForKey(NSString *key);
id SUUnlocalizedInfoValueForKey(NSString *key);
NSString *SUHostAppName();
NSString *SUHostBundleExtension();
NSString *SUHostAppDisplayName();
NSString *SUHostAppVersion();
NSString *SUHostAppVersionString();

NSComparisonResult SUStandardVersionComparison(NSString * versionA, NSString * versionB);

// If running make localizable-strings for genstrings, ignore the error on this line.
NSString *SULocalizedString(NSString *key, NSString *comment);
