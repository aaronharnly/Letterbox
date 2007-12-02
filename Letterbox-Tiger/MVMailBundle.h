#import <Cocoa/Cocoa.h>
#import <Foundation/Foundation.h>

@interface MVMailBundle : NSObject
{
}

+ (id)allBundles;
+ (id)composeAccessoryViewOwners;
+ (void)registerBundle;
+ (id)sharedInstance;
+ (BOOL)hasPreferencesPanel;
+ (id)preferencesOwnerClassName;
+ (id)preferencesPanelName;
+ (BOOL)hasComposeAccessoryViewOwner;
+ (id)composeAccessoryViewOwnerClassName;
- (void)dealloc;
- (void)_registerBundleForNotifications;

@end
