//
//  AudioPlayCell.m
//  AudioTool
//
//  Created by zhihuili on 2018/12/23.
//  Copyright © 2018 智慧  李. All rights reserved.
//

#import "AudioPlayCell.h"
#import "BSVoiceModel.h"

@interface AudioPlayCell ()<AudioToolDidFinish>

@property(weak,nonatomic)UIView *lineView;
@property(weak,nonatomic)UIButton *micBtn;
@property(weak,nonatomic)UILabel *promptLab;
@property(weak,nonatomic)UIButton *editBtn;

@property(weak,nonatomic)UILabel *currentTimeLab;
@property(weak,nonatomic)UISlider *slider;
@property(weak,nonatomic)UILabel *allTimeLab;

@end

@implementation AudioPlayCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = KColorHex(@"eeeeee");
        [self.contentView addSubview:lineView];
        self.lineView = lineView;
        
        UIButton *micBtn = [[UIButton alloc] init];
        [micBtn setImage:KImageNamed(@"microphone") forState:UIControlStateNormal];
        [micBtn setTitleColor:KColorHex(@"333333") forState:UIControlStateNormal];
        micBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        [micBtn setTitle:@"" forState:UIControlStateNormal];
        [micBtn setDefaultImageTitleStyleWithSpacing:5];
        [self.contentView addSubview:micBtn];
        self.micBtn = micBtn;
        
        UILabel *promptLab = [UILabel creatWithFont:[UIFont systemFontOfSize:11] TextColor:KColorHex(@"cccccc") Text:@"（向左滑动可以删除录音）"];
        [self.contentView addSubview:promptLab];
        self.promptLab = promptLab;
        
        UIButton *editBtn = [[UIButton alloc] init];
        [editBtn setImage:KImageNamed(@"edit_audioName") forState:UIControlStateNormal];
        [editBtn addTarget:self action:@selector(editBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:editBtn];
        self.editBtn = editBtn;
        
        UIButton *audioPlayBtn = [[UIButton alloc] init];
        [audioPlayBtn addTarget:self action:@selector(audioPlayBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [audioPlayBtn setImage:KImageNamed(@"audioPlay") forState:UIControlStateNormal];
        [audioPlayBtn setImage:KImageNamed(@"audioPause") forState:UIControlStateSelected];
        [audioPlayBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [self.contentView addSubview:audioPlayBtn];
        self.audioPlayBtn = audioPlayBtn;
        
        UILabel *currentTimeLab = [UILabel creatWithFont:[UIFont systemFontOfSize:11]   TextColor:KColorHex(@"9a9a9a")];
        currentTimeLab.text = @"00:00";
        [self.contentView addSubview:currentTimeLab];
        self.currentTimeLab = currentTimeLab;
        
        UISlider *slider = [[UISlider alloc] init];
        slider.value = 0;
        slider.continuous = NO;
        [slider setThumbImage:[UIImage imageNamed:@"voice_point"] forState:UIControlStateNormal];
        [slider setThumbImage:[UIImage imageNamed:@"voice_point"] forState:UIControlStateHighlighted];
        slider.minimumTrackTintColor = [UIColor colorWithRed:57/255.0 green:163/255.0 blue:239/255.0 alpha:1.f];
        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)];
        [slider addGestureRecognizer:tap2];
        [slider addTarget:self action:@selector(sliderTouchDown:) forControlEvents:UIControlEventTouchDown];
        [slider addTarget:self action:@selector(sliderProgressChange:) forControlEvents:UIControlEventValueChanged];
        [slider addTarget:self action:@selector(sliderTouchUpInSide:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:slider];
        self.slider = slider;
        
        UILabel *allTimeLab = [UILabel creatWithFont:[UIFont systemFontOfSize:11] TextColor:KColorHex(@"9a9a9a")];
        [self.contentView addSubview:allTimeLab];
        self.allTimeLab = allTimeLab;
        
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.lineView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.offset(0);
        make.height.equalTo(KLineWidth);
    }];
    
    [self.micBtn makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.offset(17);
    }];
    
    [self.promptLab makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.micBtn.right).offset(2);
        make.centerY.equalTo(self.micBtn);
    }];
    
    [self.editBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-17);
        make.centerY.equalTo(self.micBtn);
        make.size.equalTo(CGSizeMake(40, 45));
    }];
    
    [self.audioPlayBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.micBtn);
        make.width.equalTo(24);
        make.top.equalTo(self.editBtn.bottom);
        make.bottom.offset(0);
    }];
    
    [self.currentTimeLab makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.audioPlayBtn);
        make.left.equalTo(self.audioPlayBtn.right).offset(0);
    }];
    
    [self.slider mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.audioPlayBtn.right).mas_offset(35);
        make.right.offset(-55);
        make.centerY.mas_equalTo(self.audioPlayBtn);
        make.height.mas_equalTo(30);
    }];
    
    [self.allTimeLab makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.audioPlayBtn);
        make.right.equalTo(self.editBtn);
    }];
    
}

-(void)setVoiceModel:(BSVoiceModel *)voiceModel{
    _voiceModel = voiceModel;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.slider setValue:voiceModel.value animated:NO];
        self.audioPlayBtn.selected = voiceModel.isCurPlayingCell;
        if (voiceModel.allTimeStr.length>0) {
            self.currentTimeLab.text = voiceModel.curTimeStr;
            self.allTimeLab.text = voiceModel.allTimeStr;
            [self.micBtn setTitle:voiceModel.attach_name forState:UIControlStateNormal];
        }
    });
}
-(void)editBtnClick:(UIButton *)btn{
    if (self.editName) {
        self.editName(self.micBtn);
    }
}
-(void)audioPlayBtnClick:(UIButton *)btn{
    if (self.voiceModel.filePath.length<1) {
        kMBShowPrompt(@"抱歉该音频下载失败!", nil)
    }else{
        btn.selected = !btn.isSelected;
        if (btn.isSelected) {
            if (!self.voiceModel.isCurPlayingCell) {
                if (self.audioStartPlay) {
                    self.audioStartPlay([AudioTool shareInstance].curTime,[AudioTool shareInstance].duration);
                }
                [[AudioTool shareInstance] stopPlay];
                self.voiceModel.isCurPlayingCell = YES;
            }
            [self startPlayAudio];
        } else {
            self.voiceModel.value = self.slider.value;
            self.voiceModel.isCurPlayingCell = NO;
            [[AudioTool shareInstance] stopPlay];
        }
    }
}

-(void)handleTap:(UITapGestureRecognizer *)gesture{
    if (self.voiceModel.isCurPlayingCell) {
        [[AudioTool shareInstance] stopPlay];
    }
    CGPoint point = [gesture locationInView:self.slider];
    CGFloat pointX = point.x;
    CGFloat sliderWidth = self.slider.frame.size.width;
    self.voiceModel.value = pointX/sliderWidth;
    self.voiceModel.curTimeStr = [NSString convertTime:self.slider.value*self.voiceModel.duration];
    self.slider.value = pointX/sliderWidth;
    self.currentTimeLab.text = self.voiceModel.curTimeStr;
    if (self.voiceModel.isCurPlayingCell) {
        if (self.audioPlayBtn.isSelected) {
            [self startPlayAudio];
        }
    }
}
-(void)sliderTouchDown:(UISlider *)slider{
    if (self.voiceModel.isCurPlayingCell) {
        if (self.audioPlayBtn.isSelected) {
            [[AudioTool shareInstance] stopPlay];
        }
    }
}
-(void)sliderProgressChange:(UISlider *)slider{
    self.voiceModel.curTimeStr = [NSString convertTime:slider.value*self.voiceModel.duration];
}
-(void)sliderTouchUpInSide:(UISlider *)slider{
    self.voiceModel.value = slider.value;
    self.voiceModel.curTimeStr = [NSString convertTime:slider.value*self.voiceModel.duration];
    if (self.voiceModel.isCurPlayingCell) {
        if (self.audioPlayBtn.isSelected) {
            [[AudioTool shareInstance] stopPlay];
            [self startPlayAudio];
        }
    }
}
-(void)startPlayAudio{
    [AudioTool shareInstance].delegate = self;
    [[AudioTool shareInstance] startPlayWithUrl:[NSURL URLWithString:self.voiceModel.filePath] atTime:self.slider.value];
}

-(void)playerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    [[AudioTool shareInstance] stopPlay];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.audioPlayBtn.selected = NO;
        [self.slider setValue:0.0 animated:YES];
        self.currentTimeLab.text = @"00:00";
    });
    self.voiceModel.value = 0.0;
    self.voiceModel.isCurPlayingCell = NO;
    self.voiceModel.curTimeStr = @"00:00";
}
-(void)playerPlaying:(NSTimeInterval)curTime andDuration:(NSTimeInterval)duration{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.slider setValue:curTime/duration animated:YES];
        self.currentTimeLab.text = [NSString convertTime:curTime];
    });
}

@end
