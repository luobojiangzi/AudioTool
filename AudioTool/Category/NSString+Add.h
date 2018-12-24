//
//  NSString+Add.h
//  AudioTool
//
//  Created by zhihuili on 2018/12/23.
//  Copyright © 2018 智慧  李. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Add)

//将数值转换成时间
+(NSString *)convertTime:(double)second;

//是否为空
- (BOOL)isEmpty;

@end
