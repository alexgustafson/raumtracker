//
// Created by Alexander Gustafson on 25.05.14.
// Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import "rtNetDataManager.h"


@implementation rtNetDataManager {



}


-(void)initialize
{
    post_url = [[NSURL alloc] initWithString:@"http://raumtracker.againstyou.webfactional.com//api/rtdata_list/"];
    queue = [[NSOperationQueue alloc] init];

}

-(void)postJsonData:(NSData *)jsonData
{
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:post_url];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody: jsonData];
    [urlRequest setValue:@"text/html" forHTTPHeaderField:@"Content-Type"];
    [urlRequest setValue:[NSString stringWithFormat:@"%d", [jsonData length]] forHTTPHeaderField:@"Content-Length"];
    [urlRequest setTimeoutInterval:30.0f];

    [NSURLConnection
            sendAsynchronousRequest:urlRequest
            queue:queue
            completionHandler:^(
                    NSURLResponse *response,
                    NSData *data,
                    NSError *error) {

                        if([data length] > 0 && error == nil) {

                            NSString *html = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                            NSLog(@"Response: %@", html );

                        }


                    }
    ];


}

@end