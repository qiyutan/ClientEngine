//
//  CEHttpOperationTest.h
//  ClientEngine
//
//  Created by Qiyu Tan on 6/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "CEHttpOperation.h"

@interface CEHttpOperationTest : SenTestCase<CEHttpOperationDelegate>
{
    NSMutableArray *_requests;
    BOOL _completed;
}
@end
