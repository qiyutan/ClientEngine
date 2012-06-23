//
//  CEHttpOperationTest.m
//  ClientEngine
//
//  Created by Qiyu Tan on 6/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CEHttpOperationTest.h"
#import "CEHttpOperation.h"
#import "WaitForRunloop.h"


@implementation CEHttpOperationTest

- (void)setUp
{
    _requests = [[NSMutableArray alloc] initWithCapacity:3];
    [super setUp];
}

- (void)testEexecute
{
    NSURLRequest *request1 = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://www.sina.com"]];
    [CEHttpOperation executeOperationWithURLRequest:request1 delegate:self];
    [_requests addObject:request1];
    
    NSURLRequest *request2 = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://www.sohu.com"]];
    [CEHttpOperation executeOperationWithURLRequest:request2 delegate:self];
    [_requests addObject:request2];
    
    NSURLRequest *request3 = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://www.qq.com"]];
    [CEHttpOperation executeOperationWithURLRequest:request3 delegate:self];
    [_requests addObject:request3];
    
    STAssertTrue(WaitForRunloop(^{return _requests.count == 0;}), @"Error");
}

- (void)testPriority
{
    NSURLRequest *request1 = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://www.sina.com"]];
    [CEHttpOperation executeOperationWithURLRequest:request1 priority:NSOperationQueuePriorityVeryLow delegate:self];
    [_requests addObject:request1];
    
    NSURLRequest *request2 = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://www.sohu.com"]];
    [CEHttpOperation executeOperationWithURLRequest:request2 delegate:self];
    [_requests addObject:request2];
    
    NSURLRequest *request3 = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://www.qq.com"]];
    [CEHttpOperation executeOperationWithURLRequest:request3 delegate:self];
    [_requests addObject:request3];
    
    NSURLRequest *request4 = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://www.ifeng.com"]];
    [CEHttpOperation executeOperationWithURLRequest:request4 delegate:self];
    [_requests addObject:request4];
    
    STAssertTrue(WaitForRunloop(^{return _requests.count == 0;}), @"Error");

}

- (void)httpOperationDidFinishURLRequest:(NSURLRequest*)request responseData:(NSData*)data error:(NSError*)error
{
    [_requests removeObject:request];
    if(_requests.count == 0){
        
    }
}

@end
