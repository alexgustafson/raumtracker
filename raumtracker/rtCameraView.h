//
// Created by Alexander Gustafson on 24.05.14.
// Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface rtCameraView : UIView {

    UIView *captureView;
    AVCaptureSession *captureSession;
    AVCaptureVideoPreviewLayer *captureLayer;
}

- (void)initialize;
- (void)startCameraPreview;
- (void)stopCameraPreview;

@end