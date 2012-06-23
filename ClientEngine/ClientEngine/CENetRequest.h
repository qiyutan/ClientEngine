//
//  CENetRequest.h
//  ClientEngine
//
//  Created by Qiyu Tan on 6/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CEHttpRequest.h"
@interface CENetRequest : CEHttpRequest
{
    
}
@property(nonatomic, assign) NSInteger requestId;
@property(nonatomic, assign) NSInteger retryCountLimit;

- (BOOL)isEqualToNetRequest:(id)object;
@end
