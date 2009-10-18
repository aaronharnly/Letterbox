#import <Cocoa/Cocoa.h>

@protocol MVTerminationHandler <NSObject>
- (void)nowWouldBeAGoodTimeToTerminate:(id)arg1;
#ifdef __X86_64__
@optional
- (BOOL)needsToPromptUserBeforeTermination:(id)arg1;
#else
#endif
@end
