//
// Created by Alexander Gustafson on 25.05.14.
// Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import "rtNetDataManager.h"


@implementation rtNetDataManager {



}


-(void)initialize
{
    //post_url = [[NSURL alloc] initWithString:@"http://raumtracker.againstyou.webfactional.com/api/rtdata/"];
    //session_url = [[NSURL alloc] initWithString:@"http://raumtracker.againstyou.webfactional.com/api/rtsession/"];
    post_url = [[NSURL alloc] initWithString:@"http://192.168.1.2:8000/api/rtdata/"];
    session_url = [[NSURL alloc] initWithString:@"http://192.168.1.2:8000/api/rtsession/"];
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

-(void)postSessionData:(NSData *)jsonData
{
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:session_url];
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

- (NSData *)dictToJSON:(NSDictionary *)dict {
    // source: http://www.codetuition.com/ios-tutorials/convert-nsdictionary-or-nsarray-to-json-nsstring-and-vice-versa/
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&error];
    if(!jsonData) {
        NSLog(@"JSON error: %@", error);
    }else{
        //NSString *JsonString = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
        //NSLog(@"json output %@", JsonString);
    }
    return jsonData;
}


@end