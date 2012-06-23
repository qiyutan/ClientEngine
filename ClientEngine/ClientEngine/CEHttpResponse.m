//
//  CEHttpResponse.m
//  ClientEngine
//
//  Created by Qiyu Tan on 6/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CEHttpResponse.h"

@implementation CEHttpResponse

@synthesize request = _request;
@synthesize data = _data;
@synthesize error = _error;

+ (id)responseWithRequest:(CEHttpRequest *)request data:(NSData *)data error:(NSError *)error
{
    return [[CEHttpResponse alloc] initWithRequest:request data:data error:error];
}

- (id)initWithRequest:(CEHttpRequest *)request data:(NSData *)data error:(NSError *)error
{
    self = [super init];
    if(self){
        _request = request;
        _data = data;
        _error = error;
    }
    return self;
}


@end
