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

static NSMutableArray *s_sessionCookies = nil;
static NSInteger s_maxConcurrentRequestCount = 4;

@interface CEHttpRequest ()<CEHttpOperationDelegate>
{
    NSMutableDictionary *_requestHeaders;
    NSMutableData *_postData;
    NSURL *_url;
    NSMutableURLRequest *_urlRequest;
    NSError *_error;
    BOOL _sync;
}

- (void)buildRequest;
- (void)buildRequestHeaders;
- (void)buildPostBody;
- (void)buildSessionCookies;

@end

@implementation CEHttpRequest

@synthesize cookieRequired = _cookieRequired;
@synthesize priority = _priority;
@synthesize timoutInterval = _timoutInterval;
@synthesize compeletionBlock = _compeletionBlock;

+ (void)setSessionCookies:(NSMutableArray*)newSessionCookies
{
    s_sessionCookies = newSessionCookies;
}

+ (NSArray*)sessionCookies
{
    return s_sessionCookies;
}

+ (void)addSessionCookie:(NSHTTPCookie *)newCookie
{
    for(NSInteger i = 0; i < s_sessionCookies.count; i++){
        NSHTTPCookie *cookie = [s_sessionCookies objectAtIndex:i];
        if([cookie.name isEqualToString:newCookie.name]){
            [s_sessionCookies replaceObjectAtIndex:i withObject:newCookie];
            break;
        }
    }
}

+ (void)setMaxConcurrentRequestCount:(NSInteger)count
{
    s_maxConcurrentRequestCount = count;
}

- (id)initWithURL:(NSURL *)url
{
    _priority = CEHttpRequestPriorityNormal;
    self = [super init];
    if (self) {
        _url = url;
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
    _sync = NO;
    [self buildRequest];
    [CEHttpOperation executeOperationWithURLRequest:_urlRequest priority:_priority delegate:self];
}

- (void)cancel
{
    if(_sync){
        [NSURLConnection canHandleRequest:_urlRequest];
    }
    else {
        [CEHttpOperation cancelOperationWithURLRequest:_urlRequest];
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
        NSDictionary *cookieHeaders = [NSHTTPCookie requestHeaderFieldsWithCookies:s_sessionCookies];
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
