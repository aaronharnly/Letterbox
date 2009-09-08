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
    float _constrainedWidth;
    id _currentModule;
    void *_reserved;
}

+ (id)sharedPreferences;
+ (void)setDefaultPreferencesClass:(Class)fp8;
+ (Class)defaultPreferencesClass;
- (id)init;
- (void)dealloc;
- (void)addPreferenceNamed:(id)fp8 owner:(id)fp12;
- (void)_setupToolbar;
- (void)_setupUI;
- (struct _NSSize)preferencesContentSize;
- (void)showPreferencesPanel;
- (void)showPreferencesPanelForOwner:(id)fp8;
- (int)showModalPreferencesPanelForOwner:(id)fp8;
- (int)showModalPreferencesPanel;
- (void)ok:(id)fp8;
- (void)cancel:(id)fp8;
- (void)apply:(id)fp8;
- (void)_selectModuleOwner:(id)fp8;
- (id)windowTitle;
- (void)confirmCloseSheetIsDone:(id)fp8 returnCode:(int)fp12 contextInfo:(void *)fp16;
- (BOOL)windowShouldClose:(id)fp8;
- (void)windowDidResize:(id)fp8;
- (struct _NSSize)windowWillResize:(id)fp8 toSize:(struct _NSSize)fp12;
- (BOOL)usesButtons;
- (id)_itemIdentifierForModule:(id)fp8;
- (void)toolbarItemClicked:(id)fp8;
- (id)toolbar:(id)fp8 itemForItemIdentifier:(id)fp12 willBeInsertedIntoToolbar:(BOOL)fp16;
- (id)toolbarDefaultItemIdentifiers:(id)fp8;
- (id)toolbarAllowedItemIdentifiers:(id)fp8;
- (id)toolbarSelectableItemIdentifiers:(id)fp8;

@end
