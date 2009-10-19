//
//  LetterboxConstants.h
//  Letterbox
//
//  Created by Aaron on 12/2/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//
#import <Cocoa/Cocoa.h>

extern NSString *LetterboxPreviewPanePositionKey;
extern NSString *LetterboxPreviewPanePositionLeft;
extern NSString *LetterboxPreviewPanePositionRight;
extern NSString *LetterboxPreviewPanePositionBottom;

extern NSString *LetterboxAlternatingRowColorsKey;
extern NSString *LetterboxDividerLineKey;
extern NSString *LetterboxShowTwoLineColumnKey;

extern NSString *LetterboxDividerTypeKey;
extern NSString *LetterboxDividerTypeNormal;
extern NSString *LetterboxDividerTypeHairline;

// Columns
extern NSString *LetterboxSubjectColumnIdentifier;
extern NSString *LetterboxFromColumnIdentifier;
extern NSString *LetterboxReceivedColumnIdentifier;

enum LetterboxPaneOrder {
	LetterboxPaneOrderMailboxListFirst,
	LetterboxPaneOrderMailboxListLast
};