//
//  rtOpenGlView.h
//  raumtracker
//
//  Created by Alex Gustafson on 01/05/14.
//  Copyright (c) 2014 Alex Gustafson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <OpenGLES/ES2/gl.h>
#import <AVFoundation/AVFoundation.h>

@interface rtOpenGlView : UIView {

    UIView *captureView;
    AVCaptureSession *captureSession;
    AVCaptureVideoPreviewLayer *captureLayer;

    
    CAEAGLLayer* _eaglLayer;
    EAGLContext* _context;
    GLuint _colorRenderBuffer;
    
}




@end
