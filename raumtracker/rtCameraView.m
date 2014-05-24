//
// Created by Alexander Gustafson on 24.05.14.
// Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import "rtCameraView.h"


@implementation rtCameraView {

}


- (void)initialize
{
    captureView = [[UIView alloc] initWithFrame:self.bounds];
    captureView.bounds = self.bounds;
    [self addSubview:captureView];
    [self sendSubviewToBack:captureView];


}

- (void)startCameraPreview
{
    AVCaptureDevice* camera = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (camera == nil) {
        return;
    }

    captureSession = [[AVCaptureSession alloc] init];
    AVCaptureDeviceInput *newVideoInput = [[AVCaptureDeviceInput alloc] initWithDevice:camera error:nil] ;
    [captureSession addInput:newVideoInput];

    captureLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:captureSession];
    captureLayer.frame = captureView.bounds;
    [captureLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [captureView.layer addSublayer:captureLayer];

    // Start the session. This is done asychronously since -startRunning doesn't return until the session is running.
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [captureSession startRunning];
    });
}

- (void)stopCameraPreview
{
    [captureSession stopRunning];
    [captureLayer removeFromSuperlayer];
    captureSession = nil;
    captureLayer = nil;
}


// sources
//
// source(2) : Apple Inc. pARK demo application
//

@end