//
//  UIButton+Add.h
//  AudioTool
//
//  Created by zhihuili on 2018/12/23.
//  Copyright © 2018 智慧  李. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SSEdgeInsetsType) {
    SSEdgeInsetsTypeTitle,//标题
    SSEdgeInsetsTypeImage//图片
};

typedef NS_ENUM(NSInteger, SSMarginType) {
    SSMarginTypeTop         ,
    SSMarginTypeLeft        ,
    SSMarginTypeBottom      ,
    SSMarginTypeRight       ,
    SSMarginTypeLeftTop     ,
    SSMarginTypeLeftBottom  ,
    SSMarginTypeRightTop    ,
    SSMarginTypeRightBottom
};

typedef void (^ActionBlock)(void);
//typedef void (^ActionBlock)(); //xcode 9以后会出现警告

#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 70000
#define SS_SINGLELINE_TEXTSIZE(text, font) [text length] > 0 ? [text \
sizeWithAttributes:@{NSFontAttributeName:font}] : CGSizeZero;
#else
#define SS_SINGLELINE_TEXTSIZE(text, font) [text length] > 0 ? [text sizeWithFont:font] : CGSizeZero;
#endif

@interface UIButton (Add)

- (void)HandleClickEvent:(UIControlEvents)aEvent withClickBlick:(ActionBlock)buttonClickEvent;

+ (UIButton *)creatWithTitle:(NSString *)title titleFont:(UIFont *)font titleColor:(UIColor *)color;

+ (UIButton *)creatWithTitle:(NSString *)title titleFont:(UIFont *)font titleColor:(UIColor *)color target:(id)target clickAction:(SEL)clickAction;

/**
 默认情况下，imageEdgeInsets和titleEdgeInsets都是0。先不考虑height,
 
 if (button.width小于imageView上image的width){图像会被压缩，文字不显示}
 
 if (button.width < imageView.width + label.width){图像正常显示，文字显示不全}
 
 if (button.width >＝ imageView.width + label.width){图像和文字都居中显示，imageView在左，label在右，中间没有空隙}
 */


/**
 *  图片在上，标题在下，居中显示
 *
 *  @param spacing image 和 title 之间的间隙
 */
- (void)setImageUpTitleDownWithSpacing:(CGFloat)spacing;

/**
 *  图片在右，标题在左
 *
 *  @param spacing image 和 title 之间的间隙
 */
- (void)setImageRightTitleLeftWithSpacing:(CGFloat)spacing;

/**
 *  按钮默认风格：图片在标题左边
 *
 *  @param spacing image 和 title 之间的间隙
 */
- (void)setDefaultImageTitleStyleWithSpacing:(CGFloat)spacing;


/**
 *  按钮只设置了title or image，该方法可以改变它们的位置
 *
 *  @param edgeInsetsType edgeInsetsType description
 *  @param marginType     <#marginType description#>
 *  @param margin         <#margin description#>
 */
- (void)setEdgeInsetsWithType:(SSEdgeInsetsType)edgeInsetsType marginType:(SSMarginType)marginType margin:(CGFloat)margin;

@end
