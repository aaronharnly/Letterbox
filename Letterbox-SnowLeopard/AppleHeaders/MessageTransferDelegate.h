#import <Cocoa/Cocoa.h>

@protocol MessageTransferDelegate <NSObject>
- (void)transfer:(id)arg1 didCompleteWithError:(id)arg2;
- (id)undoManagerForMessageTransfer:(id)arg1;
- (void)hideMessagesForMessageTransfer:(id)arg1;
- (void)unhideMessagesForMessageTransfer:(id)arg1;
- (void)messageTransferDidTransferMessages:(id)arg1;
- (void)messageTransferDidUndoTransferOfMessages:(id)arg1;
@end
