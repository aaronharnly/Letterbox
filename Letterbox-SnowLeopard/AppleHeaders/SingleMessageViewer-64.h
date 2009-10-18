#import <Cocoa/Cocoa.h>
#import "MessageViewer.h"
#import "MVSelectionOwner.h"

@class SpotlightBar;

@interface SingleMessageViewer : MessageViewer <MVSelectionOwner, NSToolbarDelegate>
{
    NSView *_messageContentView;
    SpotlightBar *_spotlightBar;
    NSOperation *_proxyIconOperation;
    BOOL nibLoaded;
}

+ (id)existingSingleMessageViewerForMessage:(id)arg1;
+ (id)viewerForMessage:(id)arg1 showAllHeaders:(BOOL)arg2 viewingState:(id)arg3;
+ (void)_createWithMessage:(id)arg1 andDefaults:(id)arg2;
+ (void)createWithSavedDefaults:(id)arg1;
+ (BOOL)restoreAllViewersFromDefaults;
+ (void)saveDefaultsForAllSingleViewersWithDelay;
+ (void)saveDefaultsOmittingViewer:(id)arg1;
- (BOOL)windowShouldClose:(id)arg1;
- (void)_updateWindowProxy:(id)arg1;
- (void)_updateWindowTitle;
- (id)filenameToDrag:(id)arg1;
- (BOOL)window:(id)arg1 shouldDragDocumentWithEvent:(id)arg2 from:(struct CGPoint)arg3 withPasteboard:(id)arg4;
- (unsigned long long)draggingSourceOperationMaskForLocal:(BOOL)arg1;
- (BOOL)window:(id)arg1 shouldPopUpDocumentPathMenu:(id)arg2;
- (void)openEnclosingMailbox:(id)arg1;
- (void)loadMessageWindowNib;
- (id)initForViewingMessage:(id)arg1 showAllHeaders:(BOOL)arg2 viewingState:(id)arg3 withDefaults:(id)arg4;
- (id)plainInit;
- (id)initWithMailboxUids:(id)arg1;
- (void)dealloc;
- (id)_store;
- (id)_messageIDDictionary;
- (void)_adjustNewSingleViewerWindowFrame;
- (void)_setupFromDefaults;
- (void)_setupNextKeyViewLoop;
- (void)showAndMakeKey:(BOOL)arg1;
- (void)_restoreViewer;
- (id)dictionaryRepresentation;
- (void)takeOverAsSelectionOwner;
- (void)resignAsSelectionOwner;
- (id)selectedMessages;
- (void)messageFlagsDidChange:(id)arg1;
- (BOOL)validateUserInterfaceItem:(id)arg1;
- (BOOL)validateToolbarItem:(id)arg1;
- (void)selectMailbox:(id)arg1;
- (void)messagesCompacted:(id)arg1;
- (void)setupToolbar;
- (void)_updateToolbarForResizing:(BOOL)arg1;
- (id)previousIdentifierForUpgradingToolbar:(id)arg1;
- (id)toolbar:(id)arg1 upgradedItemIdentifiers:(id)arg2;
- (BOOL)_isViewingMessage:(id)arg1;
- (BOOL)_selectionContainsMessagesWithReadStatusEqualTo:(BOOL)arg1;
- (BOOL)_selectionContainsMessagesWithFlaggedStatusEqualTo:(BOOL)arg1;
- (BOOL)_selectionContainsMessagesWithJunkMailLevelEqualTo:(int)arg1;
- (BOOL)_selectionContainsMessagesWithAttachments;
- (BOOL)shouldDeleteMessageGivenCurrentState;
- (BOOL)shouldDeleteMessagesGivenCurrentState;
- (void)deleteMessages:(id)arg1;
- (void)deleteMessagesAllowingMoveToTrash:(BOOL)arg1;
- (void)undeleteMessages:(id)arg1;
- (void)undeleteMessagesAllowUndo:(BOOL)arg1;
- (void)replyMessage:(id)arg1;
- (void)replyAllMessage:(id)arg1;
- (void)replyToSender:(id)arg1;
- (void)replyToOriginalSender:(id)arg1;
- (void)forwardMessage:(id)arg1;
- (void)redirectMessage:(id)arg1;
- (BOOL)send:(id)arg1;
- (void)editorDidLoad:(id)arg1;
- (BOOL)replaceWithEditorForType:(int)arg1;
- (void)keyDown:(id)arg1;
- (id)selection;
- (void)selectMessages:(id)arg1;
- (id)currentDisplayedMessage;
- (id)messageStore;
- (BOOL)transferSelectionToMailbox:(id)arg1 deleteOriginals:(BOOL)arg2;
- (void)_showSpotlightBarWithSearchString:(id)arg1;
- (void)_hideSpotlightBar;
- (void)setSearchString:(id)arg1;
- (void)setShowRevealMessageLink:(BOOL)arg1;
- (void)revealMessage:(id)arg1;
@property(retain, nonatomic) NSOperation *proxyIconOperation; // @synthesize proxyIconOperation=_proxyIconOperation;

@end
