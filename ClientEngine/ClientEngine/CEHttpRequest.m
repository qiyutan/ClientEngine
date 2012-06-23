//
//  CEHttpRequest.m
//  ClientEngine
//
//  Created by Qiyu Tan on 6/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CEHttpRequest.h"
#import "CEHttpOperation.h"
#import "CEHttpResponse.h"

static NSOperationQueue *s_defaultOperationQueue = nil;

@interface CEHttpRequest ()<CEHttpOperationDelegate>
{
    NSMutableDictionary *_requestHeaders;
    NSMutableData *_postData;
    NSURL *_url;
    NSMutableURLRequest *_urlRequest;
    NSError *_error;
    BOOL _sync;
    CEHttpOperation *_operation;
}

- (void)buildRequest;
- (void)buildRequestHeaders;
- (void)buildPostBody;
- (void)buildSessionCookies;

@end

@implementation CEHttpRequest

@synthesize cookieRequired = _cookieRequired;
@synthesize timoutInterval = _timoutInterval;
@synthesize compeletionBlock = _compeletionBlock;
@synthesize sessionCookies = _sessionCookies;
@synthesize requestHeaders = _requestHeaders;
@synthesize url = _url;
@synthesize postData = _postData;
@synthesize method = _method;

+ (void)initialize
{
    s_defaultOperationQueue = [[NSOperationQueue alloc] init];
}

- (id)initWithURL:(NSURL *)url
{
    self = [super init];
    if (self) {
        _url = url;
        _method = @"Get";
    }
    return self;
}

- (void)addRequestHeader:(NSString*)header value:(NSString*)value
{
    if (!_requestHeaders) {
		_requestHeaders = [[NSMutableDictionary alloc] initWithCapacity:1];
	}
	[_requestHeaders setObject:value forKey:header];
}

- (void)appendPostData:(NSData*)data
{
    if(!_postData){
        _postData = [[NSMutableData alloc] init];
    }
    [_postData appendData:data];
}

- (void)startSynchronous
{
    _sync = YES;
    [self buildRequest];
    NSURLResponse *response;
    NSError *error;
    NSData *data = [NSURLConnection sendSynchronousRequest:_urlRequest returningResponse:&response error:&error];
    [self httpOperationDidFinishURLRequest:_urlRequest responseData:data error:error];
}

- (void)startAsynchronous
{
    [self startAsynchronousInQueue:nil priority:NSOperationQueuePriorityNormal];
}

- (void)startAsynchronousInQueue:(NSOperationQueue*)queue priority:(NSOperationQueuePriority)priority
{
    _sync = NO;
    [self buildRequest];
    _operation = [[CEHttpOperation alloc] initWithURLReuqest:_urlRequest delegate:self];
    _operation.queuePriority = priority;
    if(queue){
        [queue addOperation:_operation];
    }
    else {
        [s_defaultOperationQueue addOperation:_operation];
    }
}

- (void)cancel
{
    if(_sync){
        [NSURLConnection canHandleRequest:_urlRequest];
    }
    else {
        [_operation cancel];
    }
}
     

#pragma mark - Private
- (void)buildRequest
{
    if(_urlRequest){
        return;
    }
    
    if(_timoutInterval > 0){
        _urlRequest = [NSMutableURLRequest requestWithURL:_url 
                                              cachePolicy:NSURLRequestUseProtocolCachePolicy 
                                          timeoutInterval:_timoutInterval];
    }
    else {
        _urlRequest = [NSMutableURLRequest requestWithURL:_url];
    }
    _urlRequest.HTTPMethod = _method;
    [self buildRequestHeaders];
    [self buildPostBody];
}

- (void)buildRequestHeaders
{
    [_requestHeaders enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [_urlRequest addValue:obj forHTTPHeaderField:key];
    }];
}

- (void)buildPostBody
{
    [_urlRequest setHTTPBody:_postData];
}

- (void)buildSessionCookies
{
    if(_cookieRequired){
        NSDictionary *cookieHeaders = [NSHTTPCookie requestHeaderFieldsWithCookies:_sessionCookies];
        [cookieHeaders enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            [_urlRequest addValue:obj forHTTPHeaderField:key];
        }];
    }
}


#pragma mark CEHttpOperatonDelegate
- (void)httpOperationDidFinishURLRequest:(NSURLRequest*)request responseData:(NSData*)data error:(NSError*)error
{
    CEHttpResponse *response = [CEHttpResponse responseWithRequest:self data:data error:error];
    _compeletionBlock(response);
}

@end
