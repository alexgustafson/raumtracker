//
// Created by Alexander Gustafson on 25.05.14.
// Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import "rtNetDataManager.h"


@implementation rtNetDataManager {


}


- (void)initialize {
    post_url = [[NSURL alloc] initWithString:@"http://raumtracker.againstyou.webfactional.com/api/rtdata/"];
    session_url = [[NSURL alloc] initWithString:@"http://raumtracker.againstyou.webfactional.com/api/rtsession/"];
    upload_image_url = @"http://raumtracker.againstyou.webfactional.com/upload_image/";

    //post_url = [[NSURL alloc] initWithString:@"http://192.168.1.2:8000/api/rtdata/"];
    //session_url = [[NSURL alloc] initWithString:@"http://192.168.1.2:8000/api/rtsession/"];
    //upload_image_url = @"http://192.168.1.2:8000/upload_image/";
    queue = [[NSOperationQueue alloc] init];

}

- (void)postJsonData:(NSData *)jsonData {
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:post_url];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:jsonData];
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

        if ([data length] > 0 && error == nil) {

            NSString *html = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog (@"Response: %@", html);

        }


    }
    ];
}

- (void)postSessionData:(NSData *)jsonData {
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:session_url];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:jsonData];
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

        if ([data length] > 0 && error == nil) {

            NSString *html = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog (@"Response: %@", html);

        }
    }
    ];
}

- (NSData *)dictToJSON:(NSDictionary *)dict {
    // source: http://www.codetuition.com/ios-tutorials/convert-nsdictionary-or-nsarray-to-json-nsstring-and-vice-versa/
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&error];
    if (!jsonData) {
        NSLog (@"JSON error: %@", error);
    } else {
        //NSString *JsonString = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
        //NSLog(@"json output %@", JsonString);
    }
    return jsonData;
}

- (void)sendImageToServer:(NSData *)fileData andTimeStamp:(NSString *)timeStamp {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"timestamp" : timeStamp};

    [manager POST:upload_image_url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        NSError *error;
        [formData appendPartWithFileData:fileData name:@"file" fileName:@"file.png" mimeType:@"image/png"];

    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog (@"Success: %@", responseObject);
    }     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog (@"Error: %@", error);
    }];
}

@end