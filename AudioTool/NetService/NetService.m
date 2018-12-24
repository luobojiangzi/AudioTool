//
//  NetService.m
//  AudioTool
//
//  Created by zhihuili on 2018/12/23.
//  Copyright © 2018 智慧  李. All rights reserved.
//

#import "NetService.h"
//自己服务器跟地址
#define url_header @"http://"

@implementation NetService
+ (void)downloadFile:(NSString *)urlStr andSaveTo:(NSString *)fileName success:(SuccessBlock)Success failure:(FailBlock)Fail{
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    AFHTTPSessionManager *manager = [NetService createHTTPSessionManager];
    NSURLSessionDownloadTask *downTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        return [NSURL fileURLWithPath:fileName];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if (nil == error && Success) {
            Success(filePath);
        }else if (Fail){
            Fail([NSString stringWithFormat:@"%ld",error.code],error.domain);
        }
    }];
    [downTask resume];
}

+ (AFHTTPSessionManager *)createHTTPSessionManager{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.requestSerializer.timeoutInterval = 60;
    manager.requestSerializer.cachePolicy = NSURLRequestUseProtocolCachePolicy;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/plain", nil];
//    NSString *token = [UserInfo shareUserInfo].token;
//    if (token) {
//        [manager.requestSerializer setValue:[NSString stringWithFormat:@"%@",token] forHTTPHeaderField:@"Authorization"];
//    }
    return manager;
}

+ (void)uploadVoiceTo:(NSString *)urlStr params:(NSDictionary *)params isAddShow:(BOOL)isShow voiceData:(NSData *)voice toScale:(float)scale  success:(SuccessBlock)Success failure:(FailBlock)Fail{
    
    AFHTTPSessionManager *manager = [self createHTTPSessionManager];
    NSString *realURL = [url_header stringByAppendingString:urlStr];
    [manager POST:realURL parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:voice name:@"file" fileName:@"amr" mimeType:@"amr"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *resultCode = [[responseObject objectForKey:@"status"] objectForKey:@"code"];
        NSString *resultMsg = [[responseObject objectForKey:@"status"] objectForKey:@"msg"];
        if ([resultCode isEqualToString:@"0"]||[resultCode isEqualToString:@"0000"]) {
            if (Success) {
                Success(responseObject[@"data"]);
            }
        }else{
            if (Fail) {
                Fail(resultCode,resultMsg);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (Fail) {
            Fail(@"-1",@"网络错误");
        }
    }];
}

@end
