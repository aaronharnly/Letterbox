#import <Cocoa/Cocoa.h>

@protocol MVMailboxSelectionOwner <NSObject>
- (id)selectedMailboxes;
- (id)selectedMailbox;
- (id)sortedSectionItemsForTimeMachine;
- (BOOL)isSelectedMailboxSpecial;
- (void)selectPathsToMailboxes:(id)arg1;
- (BOOL)mailboxIsExpanded:(id)arg1;
- (BOOL)sectionIsExpanded:(id)arg1;
- (void)revealMailbox:(id)arg1;
- (id)mailboxSelectionWindow;
#ifdef __X86_64__
@optional
- (id)expandedItems;
#else
#endif
@end
