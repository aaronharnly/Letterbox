#import <Cocoa/Cocoa.h>

@protocol MailboxesOutlineViewControllerDelegate <NSObject>
- (void)selectAllMessages;
- (void)focusMessages;
- (long)viewerNumber;
@end
