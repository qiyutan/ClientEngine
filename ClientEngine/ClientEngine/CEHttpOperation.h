//
//  CEHttpOperation.h
//  ClientEngine
//
//  Created by Qiyu Tan on 6/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CEHttpResponse;
@protocol CEHttpOperationDelegate;

@interface CEHttpOperation : NSOperation
+ (void)setMaxConcurrentOperationCount:(NSInteger)count;
+ (void)executeOperationWithURLRequest:(NSURLRequest*)request;
+ (void)executeOperationWithURLRequest:(NSURLRequest*)request delegate:(id<CEHttpOperationDelegate>)delegate;
+ (void)executeOperationWithURLRequest:(NSURLRequest*)request priority:(NSOperationQueuePriority)priority delegate:(id<CEHttpOperationDelegate>)delegate;
+ (void)cancelOperationWithURLRequest:(NSURLRequest*)request;
@end

@protocol CEHttpOperationDelegate <NSObject>

- (void)httpOperationDidFinishURLRequest:(NSURLRequest*)request responseData:(NSData*)data error:(NSError*)error;

@end
