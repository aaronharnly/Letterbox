//
//  TableViewManager+Letterbox.m
//  Letterbox
//
//  Created by Aaron on 10/18/09.
//  Copyright 2009 Wireless Generation. All rights reserved.
//

#import "TableViewManager+Letterbox.h"
#import "NSObject+LetterboxSwizzle.h"
#import "LetterboxConstants.h"
#import "LetterboxBundle.h"

@implementation TableViewManager_Letterbox

+ (void) load {
	NSString *targetClass = @"TableViewManager";
	// swizzles
	[TableViewManager_Letterbox Letterbox_addMethod:@selector(Letterbox_tableView:objectValueForTableColumn:row:) toClassNamed:targetClass];
	[TableViewManager_Letterbox Letterbox_addMethod:@selector(Letterbox_updateTableViewRowHeight) toClassNamed:targetClass];
	[TableViewManager_Letterbox Letterbox_addMethod:@selector(Letterbox_awakeFromNib) toClassNamed:targetClass];
	// accessors
	[TableViewManager_Letterbox Letterbox_addMethod:@selector(Letterbox_showTwoLineSubjectColumn) toClassNamed:targetClass];
	// notifications
	[TableViewManager_Letterbox Letterbox_addMethod:@selector(observeValueForKeyPath:ofObject:change:context:) toClassNamed:targetClass];
}

- (void) Letterbox_awakeFromNib {
	// invoke default
	[self Letterbox_awakeFromNib];
	
	// attach observer
	NSLog(@"Attaching observer");
	[[[LetterboxBundle sharedInstance] defaultsController] addObserver:self forKeyPath:[NSString stringWithFormat:@"values.%@", LetterboxShowTwoLineColumnKey] options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqual:[NSString stringWithFormat:@"values.%@",LetterboxShowTwoLineColumnKey]]) {
		[[self tableView] setNeedsDisplay];
		[self updateTableViewRowHeight];
	}
}

- (id) Letterbox_tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)column row:(long)row
{
	id defaultValue = [self Letterbox_tableView:tableView objectValueForTableColumn:column row:row];
	if ([[column identifier] isEqualToString:LetterboxSubjectColumnIdentifier]) {
		if ([self Letterbox_showTwoLineSubjectColumn]) {
			NSTableColumn *subjectColumn = [self _columnWithIdentifierTag:LetterboxSubjectColumnTag];
			NSAttributedString *subject = [[self Letterbox_tableView:tableView objectValueForTableColumn:subjectColumn row:row] copy];
			NSTableColumn *fromColumn = [self _columnWithIdentifierTag:LetterboxFromColumnTag];
			NSAttributedString *from = [[self Letterbox_tableView:tableView objectValueForTableColumn:fromColumn row:row] copy];
			NSTableColumn *receivedColumn = [self _columnWithIdentifierTag:LetterboxReceivedColumnTag];
			NSAttributedString *received = [[self Letterbox_tableView:tableView objectValueForTableColumn:receivedColumn row:row] copy];
			NSLog(@"Have received: %@", received);
			NSString *combinedString = [NSString stringWithFormat:@"%@   %@\n%@", [from string], [received string], [subject string]];
			NSMutableAttributedString *formatted = [[[NSMutableAttributedString alloc] initWithString:combinedString] autorelease];
			
			NSFont *standardFont = [self font];
			NSFont *boldFont = [[NSFontManager sharedFontManager] convertFont:standardFont toHaveTrait:NSBoldFontMask];
			[formatted addAttribute:NSFontAttributeName value:boldFont range:NSMakeRange(0, [from length])];
			
			//NSAttributedString *combined = [[NSAttributedString alloc] initWithString:combinedString];
			//NSLog(@"Making custom two-line value: %@", combined);
			return formatted;
		}
	}
	return defaultValue;
}

- (void) Letterbox_updateTableViewRowHeight {
	if ([self Letterbox_showTwoLineSubjectColumn]) {
		NSLayoutManager *layout = [[NSLayoutManager alloc] init];
		CGFloat lineSize = [layout defaultLineHeightForFont:[self font]];
		CGFloat twoLineSize = lineSize * 2.1;
		[[self tableView] setRowHeight:twoLineSize];
		[layout release];
	} else {
		[self Letterbox_updateTableViewRowHeight];
	}
}

- (BOOL) Letterbox_showTwoLineSubjectColumn {
	return [[[[LetterboxBundle sharedInstance] defaults] objectForKey:LetterboxShowTwoLineColumnKey] boolValue];
}

@end
