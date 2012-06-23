//
//  CEHttpResponse.h
//  ClientEngine
//
//  Created by Qiyu Tan on 6/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CEHttpRequest;

@interface CEHttpResponse : NSObject

@property(nonatomic, readonly) CEHttpRequest *request;
@property(nonatomic, readonly) NSData *data;
@property(nonatomic, readonly) NSError *error;

+ (id)responseWithRequest:(CEHttpRequest*)request data:(NSData*)data error:(NSError*)error;
- (id)initWithRequest:(CEHttpRequest*)request data:(NSData*)data error:(NSError*)error;


@end
