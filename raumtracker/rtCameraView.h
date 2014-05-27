//
// Created by Alexander Gustafson on 24.05.14.
// Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <ImageIO/CGImageProperties.h>
#import "rtNetDataManager.h"

@interface rtCameraView : UIView <AVCaptureVideoDataOutputSampleBufferDelegate> {

    UIView *captureView;
    AVCaptureSession *captureSession;
    AVCaptureVideoPreviewLayer *captureLayer;
    AVCaptureVideoDataOutput *frameOutput;
    AVCaptureStillImageOutput *stillImageOutput;
    rtNetDataManager *netHandler;
}


- (void)initialize;
- (void)startCameraPreview;
- (void)stopCameraPreview;
- (void)captureImage;
@end