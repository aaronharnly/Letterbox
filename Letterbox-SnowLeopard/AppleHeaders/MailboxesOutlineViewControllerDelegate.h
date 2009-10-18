#import <Cocoa/Cocoa.h>

@protocol MailboxesOutlineViewControllerDelegate <NSObject>
- (void)selectAllMessages;
- (void)focusMessages;
#ifdef __X86_64__
- (long long)viewerNumber;
@optional
- (void)mailboxSelectionChanged:(id)arg1;
#else
- (long)viewerNumber;
#endif
@end
