#import <Cocoa/Cocoa.h>

@protocol MVSelectionOwner
- (id)selection;
- (void)selectMessages:(id)fp8;
- (id)currentDisplayedMessage;
- (id)messageStore;
- (BOOL)transferSelectionToMailbox:(id)fp8 deleteOriginals:(BOOL)fp12;
@end
