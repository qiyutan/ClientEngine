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

typedef void (^CEHttpRequestCompletionBlock)(CEHttpResponse *response);

@interface CEHttpRequest : NSObject

@property(nonatomic, assign) BOOL cookieRequired;
@property(nonatomic, assign) NSTimeInterval timoutInterval;
@property(nonatomic, copy) CEHttpRequestCompletionBlock compeletionBlock;
@property(nonatomic, readonly) NSDictionary *requestHeaders;
@property(nonatomic, readonly) NSURL *url;
@property(nonatomic, readonly) NSData *postData;
@property(nonatomic, retain) NSArray *sessionCookies;
@property(nonatomic, retain) NSString *method;

- (id)initWithURL:(NSURL*)url;

- (void)addRequestHeader:(NSString*)header value:(NSString*)value;
- (void)appendPostData:(NSData*)data;

- (void)startSynchronous;
- (void)startAsynchronous;
- (void)startAsynchronousInQueue:(NSOperationQueue*)queue priority:(NSOperationQueuePriority)priority;
- (void)cancel;

@end
