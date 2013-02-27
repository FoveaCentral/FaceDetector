//
//  MainViewController.m
//  FaceDetector
//
//  Created by Roderick Monje on 6/19/12.
//  Copyright (c) 2012 All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController () {
    NSMutableArray *_messages;
}

@end

@implementation MainViewController

@synthesize accuracySwitch;
@synthesize imageView;
@synthesize output;

- (void)addError:(NSString *)error from:(CIFaceFeature *)face {
    [[self messages] addObject:error];
    output.textColor = [UIColor redColor];

    if (face) {
        [self logError:face];
    }
}

- (void)addMessage:(NSString *)message {
    [[self messages] addObject:message];
}

- (void)checkImage:(CIImage *)photo {
    NSArray* features = [[FCFaceDetector detector:! accuracySwitch.on] featuresInImage:photo];

    if ([features count] == 0) {
        [self addError:@"Can't find a face!" from:nil];
        return;
    } else if ([features count] > 1) {
        [self addError:[NSString stringWithFormat:@"Found %d faces!", [features count]] from:nil];
        return;
    }

    for(CIFaceFeature *face in features) {
        // guidelines http://travel.state.gov/passport/pptphotoreq/photoexamples/photoexamples_5300.html
        // eye height

        if (! [FCFaceDetector isCorrectAspectRatio:imageView.image]) {
            [self addError:@"Photo must be 2\" square!" from:face];
            return;
        }

        if (! [FCFaceDetector isCentered:face photo:imageView.image]) {
            [self addError:@"Head isn't centered!" from:face];
            return;
        }
        // facing camera

        if ([FCFaceDetector isTilted:face]) {
            [self addError:@"Head is tilted!" from:face];
            return;
        }

        if (! [FCFaceDetector isCorrectHeadToPhotoRatio:face photo:imageView.image]) {
            [self addError:@"Head should be 1 - 1 3/8\" high!" from:face];
            return;
        }
    }

    [self addMessage:@"Happy travels!"];
}

- (IBAction)chooseImage:(id)sender {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    imagePicker.delegate = self;
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [self presentModalViewController:imagePicker animated:YES];
}

- (void)clearText {
    [[self messages] removeAllObjects];
    output.textColor = [UIColor greenColor];
    output.text = nil;
}

- (void)loadImages {
    for (NSString *path in [[NSBundle mainBundle] pathsForResourcesOfType:@"jpg" inDirectory:nil]) {
        UIImageWriteToSavedPhotosAlbum([UIImage imageNamed:[path lastPathComponent]], self, @selector(loadError:didFinishSavingWithError:contextInfo:), nil);
        [NSThread sleepForTimeInterval:0.1];
    }
}

- (void)logError:(CIFaceFeature *)face {
    NSLog(@"Image: %1.1f x %1.1f, Face: %1.1f x %1.1f", imageView.image.size.width, imageView.image.size.height, face.bounds.size.width, face.bounds.size.height);
    NSLog(@"Left eye: %1.1f, %1.1f / Right eye: %1.1f, %1.1f", face.leftEyePosition.x, face.leftEyePosition.y, face.rightEyePosition.x, face.rightEyePosition.y);
}

- (NSMutableArray *)messages {
    if (!_messages) {
        _messages = [[NSMutableArray alloc] init];
    }

    return _messages;
}

- (void)updateText {
    for (NSString *text in [self messages]) {
        output.text = [output.text stringByAppendingFormat:@"%@\n", text];
    }
    output.hidden = NO;
}

- (IBAction)updateView:(id)sender {
    [self clearText];
    [self checkImage:[CIImage imageWithCGImage:imageView.image.CGImage]];
    [self updateText];
}

#pragma mark - Overrides: Apple

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [self dismissModalViewControllerAnimated:YES];
    [self imageView].image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self updateView:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [self dismissModalViewControllerAnimated:YES];
}

- (void)loadError:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)context {
    if(error != nil) {
        NSLog(@"Can't save: %@!",[error localizedDescription]);
    }
}

#pragma mark - Default

- (void)viewDidLoad
{
#if TARGET_IPHONE_SIMULATOR
    [self loadImages];
#endif
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [self setImageView:nil];
    [self setOutput:nil];
    [self setAccuracySwitch:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
