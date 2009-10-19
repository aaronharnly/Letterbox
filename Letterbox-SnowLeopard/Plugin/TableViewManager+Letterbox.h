//
//  TableViewManager+Letterbox.h
//  Letterbox
//
//  Created by Aaron on 10/18/09.
//  Copyright 2009 Wireless Generation. All rights reserved.
//

#import <Cocoa/Cocoa.h>

static NSTableColumn *LetterboxSubjectColumn;
static NSTableColumn *LetterboxFromColumn;
static NSTableColumn *LetterboxReceivedColumn;

@interface TableViewManager_Letterbox : NSObject {

}
// swizzles
- (id) Letterbox_tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)column row:(long)row;
- (void) Letterbox_updateTableViewRowHeight;
- (void) Letterbox_awakeFromNib;
// additions
@property (readonly) BOOL Letterbox_showTwoLineSubjectColumn;
@end

@interface TableViewManager_Letterbox (TableViewManager)
- (NSTableView *) tableView;
- (void) updateTableViewRowHeight;
- (NSFont *)font;
@end
