//
//  CEHttpOperation.m
//  ClientEngine
//
//  Created by Qiyu Tan on 6/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CEHttpOperation.h"

static NSOperationQueue *s_operationQueue = nil;

@interface CEHttpOperation()<NSURLConnectionDataDelegate>
{
    NSURLRequest *_request;
    id<CEHttpOperationDelegate> _delegate;
    BOOL _isFinished;
    BOOL _isExecuting;
    NSURLConnection *_connection;
}
@property(nonatomic, readonly) NSURLRequest *request;
- (id)initWithURLReuqest:(NSURLRequest*)request delegate:(id<CEHttpOperationDelegate>)delegate;
@end

@implementation CEHttpOperation
@synthesize request = _request;

+ (void)initialize
{
    s_operationQueue = [[NSOperationQueue alloc] init];
}

+ (void)setMaxConcurrentOperationCount:(NSInteger)count
{
    s_operationQueue.maxConcurrentOperationCount = count;
}

+ (void)executeOperationWithURLRequest:(NSURLRequest*)request
{
    [[self class] executeOperationWithURLRequest:request priority:NSOperationQueuePriorityNormal delegate:nil];
}

+ (void)executeOperationWithURLRequest:(NSURLRequest*)request delegate:(id<CEHttpOperationDelegate>)delegate
{
    [[self class] executeOperationWithURLRequest:request priority:NSOperationQueuePriorityNormal delegate:delegate];
}

+ (void)executeOperationWithURLRequest:(NSURLRequest *)request priority:(NSOperationQueuePriority)priority delegate:(id<CEHttpOperationDelegate>)delegate
{
    CEHttpOperation *operaton = [[CEHttpOperation alloc] initWithURLReuqest:request delegate:delegate];
    operaton.queuePriority = priority;
    [s_operationQueue addOperation:operaton];
}

+ (void)cancelOperationWithURLRequest:(NSURLRequest *)request
{
    for(CEHttpOperation *operaton in s_operationQueue.operations){
        if(operaton.request == request){
            [operaton cancel];
        }
    }
}

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
    }
    return self;
}

- (void)main
{
    NSURLResponse *response;
    NSError *error;
     NSLog(@"execute %@", _request);
    NSData *data = [NSURLConnection sendSynchronousRequest:_request returningResponse:&response error:&error];
    [_delegate httpOperationDidFinishURLRequest:_request responseData:data error:error];
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


@end
