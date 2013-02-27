//
//  Unit_Tests.h
//  Unit Tests
//
//  Created by Roderick Monje on 6/22/12.
//  Copyright (c) 2012 All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "FCFaceDetector.h"

@interface FCFaceDetectorTests : SenTestCase {
    CIDetector *fastDetector;
    CIDetector *slowDetector;
}
@end
