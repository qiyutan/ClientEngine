#import "WaitForRunloop.h"

BOOL WaitForRunloop(int(^conditionBlock)())
{
    NSTimeInterval t0 =  [[NSProcessInfo processInfo] systemUptime];
    while (!conditionBlock() && [[NSProcessInfo processInfo] systemUptime] - t0 < 100) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    return conditionBlock();
}