//
//  UILabel+Add.m
//  AudioTool
//
//  Created by zhihuili on 2018/12/23.
//  Copyright © 2018 智慧  李. All rights reserved.
//

#import "UILabel+Add.h"

@interface UILabel()

@end

@implementation UILabel (Add)

+ (UILabel *)creatWithFont:(UIFont *)font TextColor:(UIColor *)color{
    UILabel *label = [[UILabel alloc]init];
    label.font = font;
    label.textColor = color;
    label.numberOfLines = 0;
    return label;
}

+ (UILabel *)creatWithFont:(UIFont *)font TextColor:(UIColor *)color Text:(NSString *)text{
    UILabel *label = [self creatWithFont:font TextColor:color];
    label.text = text;
    return label;
}

@end
