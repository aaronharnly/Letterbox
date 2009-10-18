#import <Cocoa/Cocoa.h>

@protocol MVTerminationHandler <NSObject>
- (void)nowWouldBeAGoodTimeToTerminate:(id)arg1;

@optional
- (BOOL)needsToPromptUserBeforeTermination:(id)arg1;
@end
