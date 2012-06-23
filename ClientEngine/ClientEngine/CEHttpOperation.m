//
//  CEHttpOperation.m
//  ClientEngine
//
//  Created by Qiyu Tan on 6/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CEHttpOperation.h"


@interface CEHttpOperation()<NSURLConnectionDataDelegate>
{
    NSURLRequest *_request;
    id<CEHttpOperationDelegate> _delegate;
    BOOL _isFinished;
    BOOL _isExecuting;
    NSThread *_delegateThread;
    NSData *_responseData;
    NSError *_error;
}
@property(nonatomic, readonly) NSURLRequest *request;
- (id)initWithURLReuqest:(NSURLRequest*)request delegate:(id<CEHttpOperationDelegate>)delegate;
@end

@implementation CEHttpOperation
@synthesize request = _request;


- (id)init
{
    NSAssert(0, @"NOT implemented yet!");
    return nil;
}

- (id)initWithURLReuqest:(NSURLRequest*)request delegate:(id<CEHttpOperationDelegate>)delegate
{
    self = [super init];
    if(self){
        _request = request;
        _delegate = delegate;
        if(_delegate){
            _delegateThread = [NSThread currentThread];
        }
    }
    return self;
}

- (void)main
{
    NSURLResponse *response;
    NSError *error;
    NSLog(@"execute %@", _request);
    _responseData = [NSURLConnection sendSynchronousRequest:_request returningResponse:&response error:&error];
    _error = error;
    if(_delegate && [_delegateThread isExecuting]){
        [self performSelector:@selector(callback:) 
                     onThread:_delegateThread
                   withObject:nil
                waitUntilDone:NO];
    }
    NSLog(@"finish %@", _request);
    
    [self willChangeValueForKey:@"isFinished"];
    [self willChangeValueForKey:@"isExecuting"];
    _isExecuting = NO;
    _isFinished = YES;
    [self didChangeValueForKey:@"isExecuting"];
    [self didChangeValueForKey:@"isFinished"];
    
}

#pragma mark - Concurrency
- (void)start
{
    // Always check for cancellation before launching the task.
    if ([self isCancelled])
    {
        // Must move the operation to the finished state if it is canceled.
        [self willChangeValueForKey:@"isFinished"];
        _isFinished = YES;
        [self didChangeValueForKey:@"isFinished"];
        return;
    }
    
    // If the operation is not canceled, begin executing the task.
    [self willChangeValueForKey:@"isExecuting"];
    [NSThread detachNewThreadSelector:@selector(main) toTarget:self withObject:nil];
    _isExecuting = YES;
    [self didChangeValueForKey:@"isExecuting"];
    NSLog(@"start %@", _request);
}

- (BOOL)isConcurrent
{
    return YES;
}

- (BOOL)isExecuting
{
    return _isExecuting;
}

- (BOOL)isFinished
{
    return _isFinished;
}

- (void)cancel
{
    [super cancel];
    [NSURLConnection canHandleRequest:_request];
}
         
#pragma mark - callback
- (void)callback:(NSArray*)arguments
{
    [_delegate httpOperationDidFinishURLRequest:_request
                                   responseData:_responseData
                                          error:_error];
}


@end
