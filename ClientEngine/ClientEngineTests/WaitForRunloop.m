#import "WaitForRunloop.h"

BOOL WaitForRunloop(int(^conditionBlock)())
{
    NSTimeInterval t0 =  [[NSProcessInfo processInfo] systemUptime];
    while (!conditionBlock() && [[NSProcessInfo processInfo] systemUptime] - t0 < 10) {
        [[NSRunLoop currentRunLoop] runMode:@"" beforeDate:[NSDate distantFuture]];
    }
    return conditionBlock();
}