#import <Cocoa/Cocoa.h>

@protocol MVMailboxSelectionOwner
- (id)selectedMailboxes;
- (id)selectedMailbox;
- (void)selectPathsToMailboxes:(id)fp8;
- (BOOL)mailboxIsExpanded:(id)fp8;
- (void)revealMailbox:(id)fp8;
- (id)mailboxSelectionWindow;
@end
