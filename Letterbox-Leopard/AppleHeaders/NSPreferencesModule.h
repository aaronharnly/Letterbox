#import <Cocoa/Cocoa.h>
#import "NSPreferences.h"

@protocol NSPreferencesModule
- (id)viewForPreferenceNamed:(id)fp8;
- (id)imageForPreferenceNamed:(id)fp8;
- (BOOL)hasChangesPending;
- (void)saveChanges;
- (void)willBeDisplayed;
- (void)initializeFromDefaults;
- (void)didChange;
- (void)moduleWillBeRemoved;
- (void)moduleWasInstalled;
- (BOOL)moduleCanBeRemoved;
- (BOOL)preferencesWindowShouldClose;
@end

@interface NSPreferencesModule : NSObject <NSPreferencesModule>
{
    NSBox *_preferencesView;
    struct _NSSize _minSize;
    BOOL _hasChanges;
    void *_reserved;
}

+ (id)sharedInstance;
- (void)dealloc;
- (void)finalize;
- (id)init;
- (id)preferencesNibName;
- (void)setPreferencesView:(id)fp8;
- (id)viewForPreferenceNamed:(id)fp8;
- (id)imageForPreferenceNamed:(id)fp8;
- (id)titleForIdentifier:(id)fp8;
- (BOOL)hasChangesPending;
- (void)saveChanges;
- (void)willBeDisplayed;
- (void)initializeFromDefaults;
- (void)didChange;
- (struct _NSSize)minSize;
- (void)setMinSize:(struct _NSSize)fp8;
- (void)moduleWillBeRemoved;
- (void)moduleWasInstalled;
- (BOOL)moduleCanBeRemoved;
- (BOOL)preferencesWindowShouldClose;
- (BOOL)isResizable;

@end
