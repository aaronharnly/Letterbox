#import <Cocoa/Cocoa.h>
#import "NSPreferences.h"

@protocol NSPreferencesModule
- (id)viewForPreferenceNamed:(id)arg1;
- (id)imageForPreferenceNamed:(id)arg1;
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
    BOOL _hasChanges;
    void *_reserved;
    CGSize _minSize;
}

+ (id)sharedInstance;
- (void)dealloc;
- (void)finalize;
- (id)init;
- (id)preferencesNibName;
- (void)setPreferencesView:(id)arg1;
- (id)viewForPreferenceNamed:(id)arg1;
- (id)imageForPreferenceNamed:(id)arg1;
- (id)titleForIdentifier:(id)arg1;
- (BOOL)hasChangesPending;
- (void)saveChanges;
- (void)willBeDisplayed;
- (void)initializeFromDefaults;
- (void)didChange;
- (void)moduleWillBeRemoved;
- (void)moduleWasInstalled;
- (BOOL)moduleCanBeRemoved;
- (BOOL)preferencesWindowShouldClose;
- (BOOL)isResizable;
- (CGSize)minSize;
- (void)setMinSize:(CGSize)arg1;

@end
