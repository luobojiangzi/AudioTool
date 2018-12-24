//
//  AudioPlayCell.h
//  AudioTool
//
//  Created by zhihuili on 2018/12/23.
//  Copyright © 2018 智慧  李. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BSVoiceModel;

typedef void(^audioStartPlayBlock)(NSTimeInterval curTime,NSTimeInterval duration);
typedef void(^audioEndPlayBlock)(void);
typedef void(^editNameBlock)(UIButton *btn);

@interface AudioPlayCell : UITableViewCell

@property (nonatomic, copy)audioStartPlayBlock            audioStartPlay;
@property (nonatomic, copy)audioEndPlayBlock            audioEndPlay;
@property (nonatomic, copy)editNameBlock           editName;

@property(strong,nonatomic)BSVoiceModel *voiceModel;

@property(weak,nonatomic)UIButton *audioPlayBtn;


@end
