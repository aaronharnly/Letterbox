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
// swizzles
- (void) Letterbox_show;
- (void) Letterbox__setUpMenus;
- (BOOL) Letterbox_validateMenuItem:(NSMenuItem *)item;

// actions
- (IBAction) Letterbox_setPreviewPaneRight:(id)sender;
- (IBAction) Letterbox_setPreviewPaneLeft:(id)sender;
- (IBAction) Letterbox_setPreviewPaneBottom:(id)sender;

- (IBAction) Letterbox_hidePreviewPane:(id)sender;
- (IBAction) Letterbox_showPreviewPane:(id)sender;
- (IBAction) Letterbox_togglePreviewPane:(id)sender;

// accessors
@property (readonly) id Letterbox_contentController; // returns a MessageContentController
@property (readonly) id Letterbox_splitView; // returns an ExpandingSplitView
@property (readonly) id Letterbox_messageListTableView; // returns an ASExtendedTableView
@property (readonly) id Letterbox_tableManager; // returns a TableViewManager
@property (copy) NSString *Letterbox_previewPanePosition;
@property BOOL Letterbox_drawsAlternatingRowColors;
@property BOOL Letterbox_drawsDividerLines;
@end

@interface MessageViewer_Letterbox (MessageViewer)
@property BOOL Letterbox_previewPaneVisible;
@end