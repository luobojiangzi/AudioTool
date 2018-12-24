//
//  MBProgressHUD+MS.h
//
//  Created by mashuai on 13-4-18.
//  Copyright (c) 2013年 . All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (MS)

#define kMBShowSucc(text,view) [MBProgressHUD showSuccess:text toView:view];

#define kMBShowErro(text,view) [MBProgressHUD showError:text toView:view];

#define kMBShowPrompt(text,view) [MBProgressHUD showPrompt:text toView:view];

#define kMBShowMessage(text,view) [MBProgressHUD showMessage:text toView:view];

#define kMBHideMessage(view) [MBProgressHUD hideHUDForView:view];

+ (void)showSuccess:(NSString *)success;

+ (void)showError:(NSString *)error;

+ (void)showSuccess:(NSString *)success toView:(UIView *)view;

+ (void)showError:(NSString *)error toView:(UIView *)view;

+(void)showPrompt:(NSString *)promptText;

+(void)showPrompt:(NSString *)promptText toView:(UIView *)view;



+ (MBProgressHUD *)showMessage:(NSString *)message;

+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view;


+ (void)hideHUDForView:(UIView *)view;

+ (void)hideHUD;

@end
