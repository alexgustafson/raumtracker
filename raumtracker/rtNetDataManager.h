//
// Created by Alexander Gustafson on 25.05.14.
// Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface rtNetDataManager : NSObject
{
    NSURL *post_url;
    NSURL *session_url;
    NSString *upload_image_url;

    NSOperationQueue *queue;
}


-(void)initialize;
-(void)postJsonData:(NSData *)jsonData;
-(void)postSessionData:(NSData *)jsonData;
-(void)sendImageToServer:(NSData *)filePath andTimeStamp:(NSString *)timeStamp;
-(NSData *)dictToJSON:(NSDictionary *)dict;

@end