//
//  rtOpenGlView.m
//  raumtracker
//
//  Created by Alex Gustafson on 01/05/14.
//  Copyright (c) 2014 Alex Gustafson. All rights reserved.
//

#import "rtOpenGlView.h"


@implementation rtOpenGlView

//source(1)
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupLayer];
        [self setupContext];
        [self setupRenderBuffer];
        [self setupFrameBuffer];
        [self render];
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {

    }
    return self;
}



//source(1)
-(void) dealloc
{
    //[_context release];
    _context = nil;
    //[super dealloc];
}

// source(1)
+ (Class)layerClass {
    return [CAEAGLLayer class];
}

// source(1)
- (void) setupLayer {
    _eaglLayer = (CAEAGLLayer *) self.layer;
    _eaglLayer.opaque = NO;
}

// source(1)
- (void) setupContext {
    EAGLRenderingAPI api = kEAGLRenderingAPIOpenGLES2;
    _context = [[EAGLContext alloc] initWithAPI:api];
    if (!_context) {
        NSLog(@"Failed to initialize OpenGLES 2.0 context");
        exit(1);
    }
    
    if (![EAGLContext setCurrentContext:_context]) {
        NSLog(@"Failed to set current OpenGL context");
        exit(1);
    }
}

// source(1)
- (void)setupRenderBuffer {
    glGenRenderbuffers(1, &_colorRenderBuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, _colorRenderBuffer);
    [_context renderbufferStorage:GL_RENDERBUFFER fromDrawable:_eaglLayer];
}


//source(1)
- (void)setupFrameBuffer {
    GLuint framebuffer;
    glGenFramebuffers(1, &framebuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, framebuffer);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, _colorRenderBuffer);
}

//source(1)
-(void)render {
    glClearColor(0, 0, 0, 0.0);
    glClear(GL_COLOR_BUFFER_BIT);
    [_context presentRenderbuffer:GL_RENDERBUFFER];
}



// sources
//
// source(1) : http://www.raywenderlich.com/3664/opengl-tutorial-for-ios-opengl-es-2-0
//






@end