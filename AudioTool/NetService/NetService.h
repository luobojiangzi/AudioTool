//
//  NetService.h
//  AudioTool
//
//  Created by zhihuili on 2018/12/23.
//  Copyright © 2018 智慧  李. All rights reserved.
//

#import "AFHTTPSessionManager.h"

typedef void(^SuccessBlock)(id objc);
typedef void(^FailBlock)(NSString * errorCode,NSString *errorMsg);

@interface NetService : AFHTTPSessionManager
//文件下载
+ (void)downloadFile:(NSString *)urlStr andSaveTo:(NSString *)fileName success:(SuccessBlock)Success failure:(FailBlock)Fail;
//上传音频
+ (void)uploadVoiceTo:(NSString *)urlStr params:(NSDictionary *)params isAddShow:(BOOL)isShow voiceData:(NSData *)voice toScale:(float)scale  success:(SuccessBlock)Success failure:(FailBlock)Fail;

@end
