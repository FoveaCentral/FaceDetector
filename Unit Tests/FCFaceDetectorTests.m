//
//  Unit_Tests.m
//  Unit Tests
//
//  Created by Roderick Monje on 6/22/12.
//  Copyright (c) 2012 All rights reserved.
//

#import "FCFaceDetectorTests.h"

@implementation FCFaceDetectorTests

- (void)setUp {
    [super setUp];
    fastDetector = [FCFaceDetector detector:YES];
    slowDetector = [FCFaceDetector detector:NO];
}

- (void)tearDown {
    [super tearDown];
    fastDetector = nil;
    slowDetector = nil;
}

- (void)testIsCenteredWhenCentered {
    UIImage *image = [UIImage imageNamed:@"000headPosition2.jpg"];
    STAssertTrue([FCFaceDetector isCentered:[self fastFace:[self coreImage:image]] photo:image], @"Didn't detect centered face!");
}

- (void)testIsCenteredWhenNotCentered {
    UIImage *image = [UIImage imageNamed:@"003centered.jpg"];
    STAssertFalse([FCFaceDetector isCentered:[self fastFace:[self coreImage:image]] photo:image], @"Didn't detect off-center face!");
}

- (void)testIsCorrectAspectRatioWhenLandscape {
    STAssertFalse([FCFaceDetector isCorrectAspectRatio:[UIImage imageNamed:@"landscape.jpg"]], @"Didn't detect portrait aspect ratio!");
}

- (void)testIsCorrectAspectRatioWhenPortrait {
    STAssertFalse([FCFaceDetector isCorrectAspectRatio:[UIImage imageNamed:@"portrait.jpg"]], @"Didn't detect landscape aspect ratio!");
}

- (void)testIsCorrectAspectRatioWhenSquare {
    STAssertTrue([FCFaceDetector isCorrectAspectRatio:[UIImage imageNamed:@"square.jpg"]], @"Didn't detect square aspect ratio!");
}

- (void)testIsCorrectHeadToPhotoRatioWhenJustRight {
    UIImage *image = [UIImage imageNamed:@"000headPosition2.jpg"];
    STAssertTrue([FCFaceDetector isCorrectHeadToPhotoRatio:[self fastFace:[self coreImage:image]] photo:image], @"Didn't detect correct head:photo!");
}

- (void)testIsCorrectHeadToPhotoRatioWhenTooLarge {
    UIImage *image = [UIImage imageNamed:@"001toolarge.jpg"];
    STAssertFalse([FCFaceDetector isCorrectHeadToPhotoRatio:[self fastFace:[self coreImage:image]] photo:image], @"Didn't detect large head!");
}

- (void)testIsCorrectHeadToPhotoRatioWhenTooSmall {
    UIImage *image = [UIImage imageNamed:@"002toosmall.jpg"];
    STAssertFalse([FCFaceDetector isCorrectHeadToPhotoRatio:[self fastFace:[self coreImage:image]] photo:image], @"Didn't detect small head!");
}

- (void)testIsTiltedWhenNotTilted {
    STAssertFalse([FCFaceDetector isTilted:[self fastFace:[self coreImage:[UIImage imageNamed:@"level.jpg"]]]], @"Didn't detect level head!");
}

- (void)testIsTiltedWhenTilted {
    STAssertTrue([FCFaceDetector isTilted:[self fastFace:[self coreImage:[UIImage imageNamed:@"005tilted.jpg"]]]], @"Didn't detect titled head!");
}

#pragma mark - Private

- (CIImage *)coreImage:(UIImage *)image {
    return [[CIImage alloc] initWithImage:image];
}

- (CIFaceFeature *)face:(CIDetector *)detector image:(CIImage *)image {
    NSArray *_faces = [detector featuresInImage:image];
    if ([_faces count] == 0) {
        NSLog(@"Can't find a face!");
        [NSException raise:nil format:nil];
    }
    return [_faces objectAtIndex:0];
}

- (CIFaceFeature *)fastFace:(CIImage *)image {
    return [self face:fastDetector image:image];
}

- (CIFaceFeature *)slowFace:(CIImage *)image {
    return [self face:slowDetector image:image];
}

@end
