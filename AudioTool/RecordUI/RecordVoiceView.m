//
//  RecordVoiceView.m
//  AudioTool
//
//  Created by zhihuili on 2018/12/23.
//  Copyright © 2018 智慧  李. All rights reserved.
//

#import "RecordVoiceView.h"

@interface RecordVoiceView () {
    UIWindow *_window;
}

@property (nonatomic, strong)UIView   *contentView;
@property (nonatomic, strong)NSString *title;
@property (nonatomic, strong)NSString *fileName;
@property (nonatomic, strong)UILabel  *timeLabel;
@property (nonatomic, strong)UIView   *backView;
@property (nonatomic, strong)NSTimer  *timer;
@property (nonatomic, assign)int     timeNum;
@property (nonatomic, strong)UILabel  *begainLabel;
@property (nonatomic, assign)float    contentViewH;

@end

@implementation RecordVoiceView

- (instancetype)initWithTitle:(NSString *)title withFileName:(NSString *)fileName{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.title = title;
        self.fileName = fileName;
        [self createUI];
    }
    
    return self;
}

- (void)createUI {
    
    _window = [UIApplication sharedApplication].keyWindow;
    [_window addSubview:self];
    
    self.contentViewH = FONT_TEXT(180)+FONT_TEXT(75)+FONT_TEXT(49)+FONT_TEXT(57)+FONT_TEXT(10)+FONT_TEXT(20)+FONT_TEXT(50);
    self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height, WIDTH, self.contentViewH)];
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.contentView];
    
    __weak typeof(self) mySelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        mySelf.contentView.frame = CGRectMake(0, mySelf.frame.size.height-mySelf.contentViewH, WIDTH, mySelf.contentViewH);
    } completion:nil];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    //    titleLabel.text = self.title;
    titleLabel.text = self.fileName;
    titleLabel.font = [UIFont boldSystemFontOfSize:16];
    titleLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.f];
    [self.contentView addSubview:titleLabel];
    [titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(FONT_TEXT(20));
        make.right.mas_equalTo(-FONT_TEXT(20));
        make.top.mas_equalTo(FONT_TEXT(15));
    }];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor colorWithRed:221/255.0 green:221/255.0 blue:221/255.0 alpha:1.f];
    [self.contentView addSubview:lineView];
    [lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self);
        make.top.mas_equalTo(titleLabel.mas_bottom).mas_offset(FONT_TEXT(10));
        make.height.mas_equalTo(0.5);
    }];
    
    //    UILabel *recordLabel = [[UILabel alloc] init];
    //    recordLabel.textColor = [UIColor colorWithRed:COLORNUM(51) green:COLORNUM(51) blue:COLORNUM(51) alpha:1.f];
    //    recordLabel.font = FONT_Bold(13);
    //    recordLabel.text = self.fileName;
    //    [self.contentView addSubview:recordLabel];
    //    [recordLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
    //        make.left.mas_equalTo(FONT_TEXT(20));
    //        make.right.mas_equalTo(-FONT_TEXT(20));
    //        make.top.mas_equalTo(lineView.mas_bottom).mas_offset(FONT_TEXT(15));
    //    }];
    
    //y:105
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.frame.size.width/2, FONT_TEXT(180)) radius:FONT_TEXT(75) startAngle:0 endAngle:2*M_PI clockwise:YES];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = path.CGPath;
    shapeLayer.lineWidth = FONT_TEXT(3);
    shapeLayer.strokeColor = [UIColor colorWithRed:221/255.0 green:221/255.0 blue:221/255.0 alpha:1.f].CGColor;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    [self.contentView.layer addSublayer:shapeLayer];
    
    UIView *lineV = [[UIView alloc] init];
    lineV.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:lineV];
    [lineV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(FONT_TEXT(180));
        make.width.mas_equalTo(10);
        
    }];
    
    self.backView = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width/2-FONT_TEXT(75)-1, FONT_TEXT(105)-1, FONT_TEXT(150)+2, FONT_TEXT(150)+2)];
    self.backView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.backView];
    
    UIView *colorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, FONT_TEXT(75)+1, FONT_TEXT(75)+1)];
    colorView.layer.masksToBounds = YES;
    [self.backView addSubview:colorView];
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = colorView.frame;
    gradientLayer.colors = @[(__bridge id)[UIColor colorWithRed:57/255.0 green:163/255.0 blue:239/255.0 alpha:1.f].CGColor,(__bridge id)[UIColor colorWithRed:221/255.0 green:221/255.0 blue:221/255.0 alpha:1.f].CGColor];
    gradientLayer.startPoint = CGPointMake(1, 0);
    gradientLayer.endPoint = CGPointMake(0, 1);
    gradientLayer.locations = @[@0,@1];
    [colorView.layer addSublayer:gradientLayer];
    
    UIBezierPath *path2 = [UIBezierPath bezierPathWithArcCenter:CGPointMake(0, 0) radius:FONT_TEXT(75) startAngle:M_PI endAngle:M_PI+M_PI/2 clockwise:YES];
    
    CAShapeLayer *shapeLayer2 = [CAShapeLayer layer];
    shapeLayer2.position = CGPointMake(colorView.frame.size.width, colorView.frame.size.height);
    shapeLayer2.path = path2.CGPath;
    shapeLayer2.lineWidth = FONT_TEXT(3);
    shapeLayer2.lineCap = kCALineCapRound;
    shapeLayer2.strokeColor = [UIColor colorWithRed:57/255.0 green:163/255.0 blue:239/255.0 alpha:1.f].CGColor;
    shapeLayer2.fillColor = [UIColor clearColor].CGColor;
    shapeLayer2.backgroundColor = [UIColor clearColor].CGColor;
    colorView.layer.mask = shapeLayer2;
    
    CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    basicAnimation.fromValue = @(0);
    basicAnimation.toValue = @(M_PI*2);
    basicAnimation.duration = 3;
    basicAnimation.repeatCount = LONG_MAX;
    [self.backView.layer addAnimation:basicAnimation forKey:@"loadingAnimation"];
    
    self.timeLabel = [[UILabel alloc] init];
    self.timeLabel.textColor = [UIColor colorWithRed:57/255.0 green:163/255.0 blue:239/255.0 alpha:1.f];
    self.timeLabel.font = [UIFont systemFontOfSize:16];
    self.timeLabel.text = @"00:00:00";
    self.timeLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.timeLabel];
    [self.timeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.centerY.mas_equalTo(lineV.mas_top);
        make.width.mas_equalTo(FONT_TEXT(140));
        
    }];
    
    NSArray *arr = @[@"删除",@"开始",@"保存"];
    NSArray *imageArr = @[@"voice_remove",@"voice_begin",@"voice_save"];
    for (int i=0; i<arr.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        btn.tag = 50 + i;
        btn.frame = CGRectMake(self.frame.size.width/4-FONT_TEXT(57)/2+i*self.frame.size.width/4, FONT_TEXT(180)+FONT_TEXT(75)+FONT_TEXT(49), FONT_TEXT(57), FONT_TEXT(57));
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = FONT_TEXT(57)/2;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn setBackgroundImage:[UIImage imageNamed:imageArr[i]] forState:UIControlStateNormal];
        [self.contentView addSubview:btn];
        
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = [UIColor colorWithRed:154/255.0 green:154/255.0 blue:154/255.0 alpha:1.f];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = arr[i];
        [self.contentView addSubview:label];
        [label mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(btn.mas_left);
            make.right.mas_equalTo(btn.mas_right);
            make.top.mas_equalTo(btn.mas_bottom).mas_offset(FONT_TEXT(10));
        }];
        if (i == 1) {
            self.begainLabel = label;
        }
    }
    
    [self pauseAnimation];
    
}

- (void)btnClick:(UIButton *)send {
    if (send.tag == 50) {
        [self pauseAnimation];
        self.removeRecordBlock();
        [self removeView];
        
    } else if (send.tag == 51) {
        if ([self.begainLabel.text isEqualToString:@"开始"]) {
            [[AudioTool shareInstance] requestAccessWith:AVRequestAccessAudio isGranted:^(BOOL granted) {
                if (granted) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self resumeAnimation];
                        self.begainLabel.text = @"暂停";
                        send.tag = 60;
                    });
                    if (self.begainRecordBlock) {
                        self.begainRecordBlock();
                    }
                }
            }];
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self resumeAnimation];
                self.begainLabel.text = @"暂停";
                send.tag = 60;
            });
            if (self.resumeRecordBlock) {
                self.resumeRecordBlock();
            }
        }
    } else if (send.tag == 60) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self pauseAnimation];
            self.begainLabel.text = @"继续";
            send.tag = 51;
        });
        if (self.pauseRecordBlock) {
            self.pauseRecordBlock();
        }
    } else {
        [self pauseAnimation];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self removeView];
        });
        if (self.saveRecordBlock) {
            self.saveRecordBlock(self.timeNum);
        }
    }
}

- (void)createTimer {
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(refreshTime) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)removeTimer {
    [self.timer invalidate];
    self.timer = nil;
}

- (void)refreshTime {
    //最长30分钟
    if (self.timeNum==30*1) {
        [self pauseAnimation];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self removeView];
        });
        if (self.saveRecordBlock) {
            self.saveRecordBlock(self.timeNum);
        }
    }else{
        self.timeNum ++;
        long allMin = self.timeNum%3600;
        long hour = self.timeNum/3600;
        long min = allMin/60;
        long second = allMin%60;
        self.timeLabel.text = [NSString stringWithFormat:@"%.2ld:%.2ld:%.2ld",hour,min,second];
    }
}

//暂停动画
- (void)pauseAnimation {
    
    [self removeTimer];
    //（0-5）
    //开始时间：0
    //    myView.layer.beginTime
    //1.取出当前时间，转成动画暂停的时间
    CFTimeInterval pauseTime = [self.backView.layer convertTime:CACurrentMediaTime() fromLayer:nil];
    
    //2.设置动画的时间偏移量，指定时间偏移量的目的是让动画定格在该时间点的位置
    self.backView.layer.timeOffset = pauseTime;
    
    //3.将动画的运行速度设置为0， 默认的运行速度是1.0
    self.backView.layer.speed = 0;
    
}

//恢复动画
- (void)resumeAnimation {
    
    [self createTimer];
    //1.将动画的时间偏移量作为暂停的时间点
    CFTimeInterval pauseTime = self.backView.layer.timeOffset;
    
    //2.计算出开始时间
    CFTimeInterval begin = CACurrentMediaTime() - pauseTime;
    
    [self.backView.layer setTimeOffset:0];
    [self.backView.layer setBeginTime:begin];
    
    self.backView.layer.speed = 1;
}

- (void)removeView {
    
    __weak typeof(self)mySelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        mySelf.contentView.frame = CGRectMake(0, mySelf.frame.size.height, mySelf.frame.size.width, mySelf.contentViewH);
        
    } completion:^(BOOL finished) {
        [mySelf.contentView removeFromSuperview];
        [mySelf removeFromSuperview];
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint curPoint = [touch locationInView:_window];
    
    if (!CGRectContainsPoint(self.contentView.frame, curPoint)) {
        
        self.removeRecordBlock();
        [self removeView];
    }
}
-(void)dealloc{
    NSLog(@"---%@释放了---",NSStringFromClass([self class]));
}
@end
