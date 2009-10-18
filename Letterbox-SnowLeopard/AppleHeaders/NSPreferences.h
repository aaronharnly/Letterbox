#import <Cocoa/Cocoa.h>

@interface NSPreferences : NSObject
{
    NSWindow *_preferencesPanel;
    NSBox *_preferenceBox;
    NSMatrix *_moduleMatrix;
    NSButtonCell *_okButton;
    NSButtonCell *_cancelButton;
    NSButtonCell *_applyButton;
    NSMutableArray *_preferenceTitles;
    NSMutableArray *_preferenceModules;
    NSMutableDictionary *_masterPreferenceViews;
    NSMutableDictionary *_currentSessionPreferenceViews;
    NSBox *_originalContentView;
    BOOL _isModal;
    id _currentModule;
    void *_reserved;
    CGFloat _constrainedWidth;
}

+ (id)sharedPreferences;
+ (void)setDefaultPreferencesClass:(Class)arg1;
+ (Class)defaultPreferencesClass;
- (id)init;
- (void)dealloc;
- (void)addPreferenceNamed:(id)arg1 owner:(id)arg2;
- (void)_setupToolbar;
- (void)_setupUI;
- (void)showPreferencesPanel;
- (void)showPreferencesPanelForOwner:(id)arg1;
- (void)ok:(id)arg1;
- (void)cancel:(id)arg1;
- (void)apply:(id)arg1;
- (void)_selectModuleOwner:(id)arg1;
- (id)windowTitle;
- (BOOL)windowShouldClose:(id)arg1;
- (void)windowDidResize:(id)arg1;
- (BOOL)usesButtons;
- (id)_itemIdentifierForModule:(id)arg1;
- (void)toolbarItemClicked:(id)arg1;
- (id)toolbar:(id)arg1 itemForItemIdentifier:(id)arg2 willBeInsertedIntoToolbar:(BOOL)arg3;
- (id)toolbarDefaultItemIdentifiers:(id)arg1;
- (id)toolbarAllowedItemIdentifiers:(id)arg1;
- (id)toolbarSelectableItemIdentifiers:(id)arg1;
- (CGSize)preferencesContentSize;
- (CGSize)windowWillResize:(id)arg1 toSize:(CGSize)arg2;
#ifdef __x86_64__
- (long long)showModalPreferencesPanelForOwner:(id)arg1;
- (long long)showModalPreferencesPanel;
- (void)confirmCloseSheetIsDone:(id)arg1 returnCode:(long long)arg2 contextInfo:(void *)arg3;
#else
- (int)showModalPreferencesPanelForOwner:(id)arg1;
- (int)showModalPreferencesPanel;
- (void)confirmCloseSheetIsDone:(id)arg1 returnCode:(int)arg2 contextInfo:(void *)arg3;
#endif

@end
