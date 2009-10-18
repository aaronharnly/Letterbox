//
//  MessageViewer+Letterbox.h
//  Letterbox
//
//  Created by Aaron on 12/3/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
// #import "../AppleHeaders/MessageViewer.h"
// @class ASExtendedTableView;

@interface MessageViewer_Letterbox : NSObject
// overrides
- (void) Letterbox__setUpWindowContents;
- (BOOL) Letterbox_validateMenuItem:(NSMenuItem *)item;

// actions
- (IBAction) setPreviewPaneRight:(id)sender;
- (IBAction) setPreviewPaneLeft:(id)sender;
- (IBAction) setPreviewPaneBottom:(id)sender;

- (IBAction) hidePreviewPane:(id)sender;
- (IBAction) showPreviewPane:(id)sender;
- (IBAction) togglePreviewPane:(id)sender;

// accessors
@property (readonly) id contentController; // returns a MessageContentController
@property (readonly) id splitView; // returns an ExpandingSplitView
@property (readonly) id messageListTableView; // returns an ASExtendedTableView
@property (readonly) id tableManager; // returns a TableViewManager
@property (copy) NSString *previewPanePosition;
@property BOOL drawsAlternatingRowColors;
@property BOOL drawsDividerLines;
@end

@interface MessageViewer_Letterbox (MessageViewer)
@property BOOL previewPaneVisible;
@end