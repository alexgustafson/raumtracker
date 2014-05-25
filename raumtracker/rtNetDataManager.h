//
// Created by Alexander Gustafson on 25.05.14.
// Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface rtNetDataManager : NSObject
{
    NSURL *post_url;
    NSOperationQueue *queue;
}


-(void)initialize;
-(void)postJsonData:(NSData *)jsonData;

@end