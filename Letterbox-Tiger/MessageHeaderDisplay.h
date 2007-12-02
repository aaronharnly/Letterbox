
#import <Cocoa/Cocoa.h>
@class MessageHeaderView;
@class MessageContentController;
@class MessageTextContainer;

@interface MessageHeaderDisplay : NSObject
{
    MessageHeaderView *headerView;
    MessageContentController *contentController;
    MessageTextContainer *specialContainer;
    NSImageView *senderImageView;
    NSString *unloadedSender;
    float oldHeaderViewWidth;
    BOOL isCalculatingAddressLines;
    BOOL isForPrinting;
    BOOL isViewingSource;
}

+ (id)copyHeadersForMessage:(id)fp8 viewingState:(id)fp12;
+ (void)setUpAttachmentsDescriptionForMessage:(id)fp8 viewingState:(id)fp12;
+ (id)formattedAttachmentsSizeForAttachments:(id)fp8;
+ (id)formattedAttachmentsSizeForMessage:(id)fp8;
+ (int)numberOfAddressesThatFitOnTwoLinesAttachments:(id)fp8 strings:(id)fp12 inTextContainer:(id)fp16 withIndent:(int)fp20 andVerticalLocation:(int)fp24 forPrinting:(BOOL)fp28;
+ (id)linkForMoreAddressesCount:(int)fp8 headerKey:(id)fp12 font:(id)fp16;
+ (id)copyViewingState:(id)fp8;
+ (void)setUpEncryptionAndSignatureImageForMessage:(id)fp8 viewingState:(id)fp12;
+ (id)orderedKeys:(id)fp8 withTableViewOrder:(id)fp12;
+ (id)regularParagraphStyleForTabPosition:(int)fp8;
+ (id)regularParagraphStyleForTabPosition:(int)fp8 paragraphSpacing:(int)fp12;
+ (id)addressParagraphStyleForTabPosition:(int)fp8 withLineBreakMode:(int)fp12 forPrinting:(BOOL)fp16;
+ (void)setTabsWithPosition:(int)fp8 inAttributedString:(id)fp12 withKeys:(id)fp16 addressKeys:(id)fp20 addressAttachments:(id)fp24 forPrinting:(BOOL)fp28;
+ (id)attributedStringOfLength:(int)fp8 usingAttachments:(id)fp12 startingAtIndex:(int)fp16 strings:(id)fp20 newAttachments:(id *)fp24 forPrinting:(BOOL)fp28;
+ (void)rangeOfAddresses:(struct _NSRange *)fp8 rangeOfLink:(struct _NSRange *)fp12 forKey:(id)fp16 inAttributedString:(id)fp20;
- (void)dealloc;
- (void)awakeFromNib;
- (void)setUp;
- (void)display:(id)fp8;
- (void)prepareToRemoveView;
- (void)displayAttributedString:(id)fp8;
- (void)headerViewFrameChanged:(id)fp8;
- (void)recalculateAddressLinesShouldDisplay:(BOOL)fp8;
- (void)showAllAddressesForKey:(id)fp8;
- (id)textView:(id)fp8 willWriteSelectionToPasteboard:(id)fp12 type:(id)fp16;
- (BOOL)textView:(id)fp8 clickedOnLink:(id)fp12 atIndex:(unsigned int)fp16;
- (void)adjustFontSizeBy:(int)fp8 viewingState:(id)fp12;
- (id)selectedText;
- (id)textView:(id)fp8 dragImageForSelectionWithEvent:(id)fp12 origin:(struct _NSPoint *)fp16;
- (id)dragImageForSelection;
- (void)textViewDidSelectAll:(id)fp8;
- (void)selectAll;
- (void)textView:(id)fp8 setSelectedRange:(struct _NSRange)fp12 affinity:(int)fp20 stillSelecting:(BOOL)fp24;
- (void)messageTextIsChangingSelectionToRange:(struct _NSRange)fp8;
- (void)_addressPhotoLoaded:(id)fp8;
- (id)textView;
- (void)textView:(id)fp8 clickedOnCell:(id)fp12 event:(id)fp16 inRect:(struct _NSRect)fp20 atIndex:(unsigned int)fp36;
- (void)textView:(id)fp8 draggedCell:(id)fp12 inRect:(struct _NSRect)fp16 event:(id)fp32 atIndex:(unsigned int)fp36;
- (void)layoutManager:(id)fp8 didCompleteLayoutForTextContainer:(id)fp12 atEnd:(BOOL)fp16;
- (void)setIsForPrinting:(BOOL)fp8;

@end