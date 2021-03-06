#import <Cocoa/Cocoa.h>

@protocol MessageContentDisplay <NSObject>
+ (id)copyDocumentForMessage:(id)arg1 viewingState:(id)arg2;
- (id)contentView;
- (id)textView;
- (void)display:(id)arg1 inContainerView:(id)arg2 replacingView:(id)arg3 invokeWhenDisplayChanged:(id)arg4;
- (void)prepareToRemoveView;
- (void)highlightSearchText:(id)arg1;
- (id)selectedText;
- (id)selectedTextRepresentation;
- (void)setSelectedTextRepresentation:(id)arg1;
- (id)selectionParsedMessage;
- (id)attachmentsInSelection;
- (id)parsedMessage;
- (id)findTarget;
- (void)detectDataInMessage:(id)arg1 usingContext:(id)arg2;
- (void)cancelDataDetection;
#ifdef __X86_64__
- (void)adjustFontSizeBy:(long long)arg1 viewingState:(id)arg2;
@optional
- (BOOL)isOkayToDownloadAttachment:(id)arg1;
@property id delegate;
#else
- (void)adjustFontSizeBy:(long)arg1 viewingState:(id)arg2;
#endif
@end
