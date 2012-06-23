//
//  CEHttpOperation.h
//  ClientEngine
//
//  Created by Qiyu Tan on 6/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CEHttpResponse;
@protocol CEHttpOperationDelegate;

@interface CEHttpOperation : NSOperation
- (id)initWithURLReuqest:(NSURLRequest*)request delegate:(id<CEHttpOperationDelegate>)delegate;
@end

@protocol CEHttpOperationDelegate <NSObject>

- (void)httpOperationDidFinishURLRequest:(NSURLRequest*)request responseData:(NSData*)data error:(NSError*)error;

@end
