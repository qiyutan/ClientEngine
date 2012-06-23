//
//  CENetRequest.m
//  ClientEngine
//
//  Created by Qiyu Tan on 6/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CENetRequest.h"

@implementation CENetRequest
@synthesize requestId = _requestId;
@synthesize retryCountLimit = _retryCountLimit;

- (id)initWithURL:(NSURL *)url
{
    self = [super initWithURL:url];
    if(self){
        static NSInteger s_requestId = 1;
        _requestId = s_requestId++;
    }
    return self;
}

- (BOOL)isEqualToNetRequest:(id)object
{
    if([object isKindOfClass:[CENetRequest class]] == NO){
        return NO;
    }
    CENetRequest *netRequest = (CENetRequest*)object;
    if([netRequest.url.absoluteString isEqualToString:self.url.absoluteString] == NO){
        return NO;
    }
    
    if([netRequest.method isEqualToString:self.method] == NO){
        return NO;
    }
    
    if(netRequest.requestHeaders.count != self.requestHeaders.count){
        return NO;
    }
    
    if(netRequest.postData.length != self.postData.length){
        return NO;
    }
    
    __block BOOL isRequestHeaderTheSame = YES;
    [self.requestHeaders enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if([[netRequest.requestHeaders objectForKey:key] isEqualToString:obj] == NO){
            isRequestHeaderTheSame = NO;
            *stop = YES;
        }
    }];

    if(!isRequestHeaderTheSame){
        return NO;
    }
    return YES;
}

@end
