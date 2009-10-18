#import <Cocoa/Cocoa.h>

@protocol MailboxesOutlineViewControllerDelegate <NSObject>
- (void)selectAllMessages;
- (void)focusMessages;
- (long long)viewerNumber;

@optional
- (void)mailboxSelectionChanged:(id)arg1;
@end
