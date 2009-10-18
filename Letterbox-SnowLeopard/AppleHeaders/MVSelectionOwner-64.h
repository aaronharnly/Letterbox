#import <Cocoa/Cocoa.h>

@protocol MVSelectionOwner
- (id)selection;
- (void)selectMessages:(id)arg1;
- (id)currentDisplayedMessage;
- (id)messageStore;
- (BOOL)transferSelectionToMailbox:(id)arg1 deleteOriginals:(BOOL)arg2;
@end
