#import <Cocoa/Cocoa.h>

@protocol MessageContentDisplay <NSObject>
+ (id)copyDocumentForMessage:(id)fp8 viewingState:(id)fp12;
- (id)contentView;
- (id)textView;
- (void)display:(id)fp8 inContainerView:(id)fp12 replacingView:(id)fp16 invokeWhenDisplayChanged:(id)fp20;
- (void)prepareToRemoveView;
- (void)highlightSearchText:(id)fp8;
- (id)selectedText;
- (id)selectedTextRepresentation;
- (void)setSelectedTextRepresentation:(id)fp8;
- (id)selectedWebArchive;
- (id)attachmentsInSelection;
- (id)webArchiveBaseURL:(id *)fp8;
- (void)adjustFontSizeBy:(int)fp8 viewingState:(id)fp12;
- (id)findTarget;
- (struct __CFDictionary *)stringsForURLification;
- (void)updateURLMatches:(id)fp8 viewingState:(id)fp12;
- (void)detectDataInMessage:(id)fp8 usingContext:(id)fp12;
- (id)delegate;
- (void)setDelegate:(id)fp8;
@end
