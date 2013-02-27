//
//  FaceDetector.h
//  FaceDetector
//
//  Created by Roderick Monje on 6/20/12.
//  Copyright (c) 2012 All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FCFaceDetector : NSObject

+ (CIDetector *)detector:(BOOL)isFast;
+ (BOOL)isCentered:(CIFaceFeature *)face photo:(UIImage *)image;
+ (BOOL)isCorrectAspectRatio:(UIImage *)image;
+ (BOOL)isCorrectHeadToPhotoRatio:(CIFaceFeature *)face photo:(UIImage *)image;
+ (BOOL)isTilted:(CIFaceFeature *)face;

@end
