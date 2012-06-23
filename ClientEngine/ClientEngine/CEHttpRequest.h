//
//  CEHttpRequest.h
//  ClientEngine
//
//  Created by Qiyu Tan on 6/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CEHttpRequestDelegate;
@class CEHttpResponse;

typedef enum {
    CEHttpRequestPriorityHigh = NSOperationQueuePriorityHigh,
    CEHttpRequestPriorityNormal = NSOperationQueuePriorityNormal,
    CEHttpRequestPriorityLow = NSOperationQueuePriorityLow
}CEHttpRequestPriority;

typedef void (^CEHttpRequestCompletionBlock)(CEHttpResponse *response);

@interface CEHttpRequest : NSObject

@property(nonatomic, assign) BOOL cookieRequired;
@property(nonatomic, assign) NSTimeInterval timoutInterval;
@property(nonatomic, assign) CEHttpRequestPriority priority;
@property(nonatomic, copy) CEHttpRequestCompletionBlock compeletionBlock;

+ (void)setSessionCookies:(NSMutableArray*)newSessionCookies;
+ (NSArray*)sessionCookies;
+ (void)addSessionCookie:(NSHTTPCookie *)newCookie;
+ (void)setMaxConcurrentRequestCount:(NSInteger)count;

- (id)initWithURL:(NSURL*)url;

- (void)addRequestHeader:(NSString*)header value:(NSString*)value;
- (void)appendPostData:(NSData*)data;

- (void)startSynchronous;
- (void)startAsynchronous;
- (void)cancel;

@end
