//
//  SUUnarchiver.h
//  Sparkle
//
//  Created by Andy Matuschak on 3/16/06.
//  Copyright 2006 Andy Matuschak. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface SUUnarchiver : NSObject {
	id delegate;
	BOOL authenticated;
}
- (id)initAuthenticated:(BOOL)wasAuthenticated;
- (void)unarchivePath:(NSString *)path;
- (void)setDelegate:delegate;
@property (readonly) BOOL authenticated;
@end

@interface NSObject (SUUnarchiverDelegate)
- (void)unarchiver:(SUUnarchiver *)unarchiver extractedLength:(long)length;
- (void)unarchiverDidFinish:(SUUnarchiver *)unarchiver;
- (void)unarchiverDidFail:(SUUnarchiver *)unarchiver;
@end
