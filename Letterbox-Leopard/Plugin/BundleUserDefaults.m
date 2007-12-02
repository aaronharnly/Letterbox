//
//  BundleUserDefaults.m
//
//  Created by John Chang on 6/15/07.
//  This code is Creative Commons Public Domain.  You may use it for any purpose whatsoever.
//  http://creativecommons.org/licenses/publicdomain/
//
//  Modified by Aaron Harnly on 11/22/07 to specially handle boolean values.

#import "BundleUserDefaults.h"


@implementation BundleUserDefaults
// -------- Initializing an NSUserDefaults Object ----------

- (id) initWithPersistentDomainName:(NSString *)domainName
{
	if ((self = [super init]))
	{
		_applicationID = [domainName copy];
		_registrationDictionary = nil;
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_applicationWillTerminate:) name:NSApplicationWillTerminateNotification object:nil];
	}
	return self;
}

- (void) dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];

	[_applicationID release];
	[_registrationDictionary release];
	[super dealloc];
}


- (void) _applicationWillTerminate:(NSNotification *)notification
{
	[self synchronize];
}

// -------- getting values ----------
- (BOOL)boolForKey:(NSString *)defaultName
{
	Boolean isValid = TRUE;
	BOOL value = CFPreferencesGetAppBooleanValue((CFStringRef)defaultName, (CFStringRef)_applicationID, &isValid);
	if (! isValid) {
		BOOL superValue = [super boolForKey:defaultName];
		return superValue;
	}
	return (isValid && value);
}

- (id)objectForKey:(NSString *)defaultName
{
	id value = [(id)CFPreferencesCopyAppValue((CFStringRef)defaultName, (CFStringRef)_applicationID) autorelease];
	if (value == nil) {
		value = [_registrationDictionary objectForKey:defaultName];
	}
	return value;
}

// -------- setting defaults ----------
- (void)setObject:(id)value forKey:(NSString *)defaultName
{
	CFPreferencesSetAppValue((CFStringRef)defaultName, (CFPropertyListRef)value, (CFStringRef)_applicationID);
}

- (void)setBool:(BOOL)value forKey:(NSString *)defaultName
{
	CFBooleanRef valueRef = (value) ? kCFBooleanTrue : kCFBooleanFalse;
	CFPreferencesSetAppValue((CFStringRef) defaultName, valueRef, (CFStringRef) _applicationID);
}

// -------- removing defaults ----------
- (void)removeObjectForKey:(NSString *)defaultName
{
	CFPreferencesSetAppValue((CFStringRef)defaultName, NULL, (CFStringRef)_applicationID);
}


// -------- registering defaults ----------
- (void)registerDefaults:(NSDictionary *)registrationDictionary
{
	[_registrationDictionary release];
	_registrationDictionary = [registrationDictionary retain];
}


// -------- Maintaining Persistent Domains ----------
- (BOOL)synchronize
{
	return CFPreferencesSynchronize((CFStringRef)_applicationID, kCFPreferencesCurrentUser, kCFPreferencesAnyHost);
}

@end
