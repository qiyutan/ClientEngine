//
//  CEHttpRequestTest.m
//  ClientEngine
//
//  Created by Qiyu Tan on 6/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CEHttpRequestTest.h"
#import "CEHttpRequest.h"
#import "CEHttpResponse.h"

@implementation CEHttpRequestTest

- (void)test1
{
    __block BOOL sucess = NO;
    CEHttpRequest *request = [[CEHttpRequest alloc] initWithURL:[NSURL URLWithString:@"http://www.sina.com"]];
    [request setCompeletionBlock:^(CEHttpResponse *response){
        sucess = response.data.length > 0;
    }];
    [request startSynchronous];
    STAssertTrue(sucess, @"");
}

@end
