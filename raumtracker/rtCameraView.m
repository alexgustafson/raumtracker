//
// Created by Alexander Gustafson on 24.05.14.
// Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import "rtCameraView.h"


@implementation rtCameraView {

}


- (void)initialize {
    captureView = [[UIView alloc] initWithFrame:self.bounds];
    captureView.bounds = self.bounds;
    [self addSubview:captureView];
    [self sendSubviewToBack:captureView];
    netHandler = [[rtNetDataManager alloc] init];
    [netHandler initialize];

}

- (void)startCameraPreview {
    AVCaptureDevice *camera = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (camera == nil) {
        return;
    }

    captureSession = [[AVCaptureSession alloc] init];
    AVCaptureDeviceInput *newVideoInput = [[AVCaptureDeviceInput alloc] initWithDevice:camera error:nil];
    [captureSession addInput:newVideoInput];

    captureLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:captureSession];
    captureLayer.frame = captureView.bounds;
    [captureLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [captureView.layer addSublayer:captureLayer];

    stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys: AVVideoCodecJPEG, AVVideoCodecKey, nil];
    [stillImageOutput setOutputSettings:outputSettings];
    [captureSession addOutput:stillImageOutput];



    // Start the session. This is done asychronously since -startRunning doesn't return until the session is running.
    dispatch_async (dispatch_get_global_queue (DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [captureSession startRunning];
    });
}

- (void)stopCameraPreview {
    [captureSession stopRunning];
    [captureLayer removeFromSuperlayer];
    captureSession = nil;
    captureLayer = nil;
}

- (void)captureImage {
    AVCaptureConnection *videoConnection = nil;
    for (AVCaptureConnection *connection in stillImageOutput.connections)
    {
        for (AVCaptureInputPort *port in [connection inputPorts])
        {
            if ([[port mediaType] isEqual:AVMediaTypeVideo] )
            {
                videoConnection = connection;
                break;
            }
        }
        if (videoConnection)
        {
            break;
        }
    }

    NSLog(@"about to request a capture from: %@", stillImageOutput);
    [stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler: ^(CMSampleBufferRef imageSampleBuffer, NSError *error)
    {
        CFDictionaryRef exifAttachments = CMGetAttachment( imageSampleBuffer, kCGImagePropertyExifDictionary, NULL);
        if (exifAttachments)
        {
            // Do something with the attachments.
            NSLog(@"attachements: %@", exifAttachments);
        } else {
            NSLog(@"no attachments");
        }

        NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
        UIImage *image = [[UIImage alloc] initWithData:imageData];

        //self.vImage.image = image;

        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    }];
}



- (void)thisImage:(UIImage *)image hasBeenSavedInPhotoAlbumWithError:(NSError *)error usingContextInfo:(void*)ctxInfo {
    if (error) {
        // Do anything needed to handle the error or display it to the user
    } else {
        // .... do anything you want here to handle
        // .... when the image has been saved in the photo album
        [netHandler sendImageToServer:image];
    }
}



// sources
//
// source(2) : Apple Inc. pARK demo application
//

@end