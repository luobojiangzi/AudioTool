//
//  RecordVoiceView.h
//  AudioTool
//
//  Created by zhihuili on 2018/12/23.
//  Copyright © 2018 智慧  李. All rights reserved.
//

#import <UIKit/UIKit.h>

//开始
typedef void(^BegainRecordBlock)(void);
//继续
typedef void(^ResumeRecordBlock)(void);
//暂停
typedef void(^PauseRecordBlock)(void);
//保存
typedef void(^SaveRecordBlock)(int timeNum);
//删除
typedef void(^RemoveRecordBlock)(void);

@interface RecordVoiceView : UIView

@property (nonatomic, copy)BegainRecordBlock begainRecordBlock;
@property(copy,nonatomic)ResumeRecordBlock resumeRecordBlock;
@property (nonatomic, copy)PauseRecordBlock   pauseRecordBlock;
@property (nonatomic, copy)SaveRecordBlock   saveRecordBlock;
@property (nonatomic, copy)RemoveRecordBlock removeRecordBlock;

- (instancetype)initWithTitle:(NSString *)title withFileName:(NSString *)fileName;

@end
