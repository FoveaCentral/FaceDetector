//
//  FaceDetector.m
//  FaceDetector
//
//  Created by Roderick Monje on 6/20/12.
//  Copyright (c) 2012 All rights reserved.
//

#import "FCFaceDetector.h"

#define FDAspectRatio @"aspect ratio"
#define FDHeadRatioLowerBound @"head ratio lower bound"
#define FDHeadRatioUpperBound @"head ratio upper bound"

NSDictionary *currentPhotoParameters;
NSDictionary *photoParameters;

@implementation FCFaceDetector

+ (void)initialize {
    if (! photoParameters) {
        NSPropertyListFormat format;
        NSString *errorDesc = nil;
        NSString *plistPath;
        plistPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"PhotoParameters.plist"];
        if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath]) {
            plistPath = [[NSBundle mainBundle] pathForResource:@"PhotoParameters" ofType:@"plist"];
        }
        photoParameters = (NSDictionary *)[NSPropertyListSerialization
                                              propertyListFromData:[[NSFileManager defaultManager] contentsAtPath:plistPath]
                                              mutabilityOption:NSPropertyListMutableContainersAndLeaves
                                              format:&format
                                              errorDescription:&errorDesc];
        if (! photoParameters) {
            NSLog(@"Error reading plist: %@, format: %d", errorDesc, format);
        }
    }
}

+ (CIDetector *)detector:(BOOL)isFast {
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             (isFast ? CIDetectorAccuracyLow : CIDetectorAccuracyHigh),
                             CIDetectorAccuracy, nil];

    return [CIDetector detectorOfType:CIDetectorTypeFace context:nil options:options];
}

+ (BOOL)isCentered:(CIFaceFeature *)face photo:(UIImage *)image {
    if (! image) {
        NSLog(@"Image is null!");
        return false;
    }
    return fabs(face.leftEyePosition.x - (image.size.width - face.rightEyePosition.x)) <= 10;
}

+ (BOOL)isCorrectAspectRatio:(UIImage *)image {
    if (! image) {
        NSLog(@"Image is null!");
        return false;
    }
    return [[NSString stringWithFormat:@"%1.1f", (image.size.width / image.size.height)] isEqualToString:[self aspectRatio]];
}

+ (BOOL)isCorrectHeadToPhotoRatio:(CIFaceFeature *)face photo:(UIImage *)image {
    if (! image) {
        NSLog(@"Image is null!");
        return false;
    }
    float ratio = (face.bounds.size.height / image.size.height);
    NSLog(@"ratio: %f", ratio);
    return ratio >= [self headRatioLowerBound] && ratio <= [self headRatioUpperBound];
}

+ (BOOL)isTilted:(CIFaceFeature *)face {
    return fabs(face.leftEyePosition.y - face.rightEyePosition.y) > 5;
}

#pragma mark - Private

+ (NSString *)aspectRatio {
    return [[self currentPhotoParameters] objectForKey:FDAspectRatio];
}

+ (NSString *)currentCountry {
    return [[NSLocale currentLocale] objectForKey:NSLocaleCountryCode];
}

+ (NSDictionary *)currentPhotoParameters {
    if (! currentPhotoParameters) {
        currentPhotoParameters = [photoParameters objectForKey:[self currentCountry]];
    }
    return currentPhotoParameters;
}

+ (float)headRatioLowerBound {
    return [[[self currentPhotoParameters] objectForKey:FDHeadRatioLowerBound] floatValue];
}

+ (float)headRatioUpperBound {
    return [[[self currentPhotoParameters] objectForKey:FDHeadRatioUpperBound] floatValue];
}

@end
