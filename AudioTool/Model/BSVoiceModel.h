//
//  BSVoiceModel.h
//  AudioTool
//
//  Created by zhihuili on 2018/12/23.
//  Copyright © 2018 智慧  李. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BSVoiceModel : NSObject
//音频ID
@property(copy,nonatomic)NSString *attach_id;
//音频名字
@property(copy,nonatomic)NSString *attach_name;
//音频网络路径
@property(copy,nonatomic)NSString *attach_url;
//音频时长
@property(copy,nonatomic)NSString *voice_duration;
//音频本地路径
@property(copy,nonatomic)NSString *filePath;
//音频时长
@property(assign,nonatomic)double duration;
//音频当前时间
@property(copy,nonatomic)NSString *curTimeStr;
//音频总时间
@property(copy,nonatomic)NSString *allTimeStr;
//音频进度
@property(assign,nonatomic)float value;
//是否是正在播放的音频
@property(assign,nonatomic)BOOL isCurPlayingCell;

@end
