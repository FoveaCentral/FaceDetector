//
//  MainViewController.h
//  FaceDetector
//
//  Created by Roderick Monje on 6/19/12.
//  Copyright (c) 2012 All rights reserved.
//

#import "FCFaceDetector.h"

@interface MainViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) IBOutlet UISwitch *accuracySwitch;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UITextView *output;

- (void)addError:(NSString *)error from:(CIFaceFeature *)face;
- (void)addMessage:(NSString *)message;
- (void)checkImage:(CIImage *)photo;
- (IBAction)chooseImage:(id)sender;
- (void)clearText;
- (void)loadError:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;
- (void)loadImages;
- (void)logError:(CIFaceFeature *)face;
- (NSMutableArray *)messages;
- (void)updateText;
- (IBAction)updateView:(id)sender;
@end
