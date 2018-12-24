//
//  UILabel+Add.h
//  AudioTool
//
//  Created by zhihuili on 2018/12/23.
//  Copyright © 2018 智慧  李. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Add)

+ (UILabel *)creatWithFont:(UIFont *)font TextColor:(UIColor *)color;

+ (UILabel *)creatWithFont:(UIFont *)font TextColor:(UIColor *)color Text:(NSString *)text;

@end
