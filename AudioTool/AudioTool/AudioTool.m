//
//  AudioTool.m
//  AudioTool
//
//  Created by zhihuili on 2018/12/23.
//  Copyright © 2018 智慧  李. All rights reserved.
//

#import "AudioTool.h"
#import "ZHWeakProxy.h"

static AudioTool *audioTool;

typedef void(^recordBlock)(void);

@interface AudioTool ()<AVAudioRecorderDelegate,AVAudioPlayerDelegate>

@property(strong,nonatomic)AVAudioRecorder *recorder;
@property(strong,nonatomic)AVAudioPlayer *player;

@property(strong,nonatomic)NSTimer *recordTimer;

@property(weak,nonatomic)CADisplayLink *displayLink;

@property(strong,nonatomic)NSURL *recoderUrl;
@property(assign,nonatomic)NSInteger seconds;

@end

@implementation AudioTool

+ (AudioTool *)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        audioTool = [[AudioTool alloc] init];
        audioTool.filePath = @"";
    });
    return audioTool;
}
-(void)requestAccessWith:(AVRequestAccessType)type isGranted:(void (^)(BOOL isGranted))grantedBlock{
    AVMediaType mediaType;
    if (type==AVRequestAccessAudio) {
        mediaType = AVMediaTypeAudio;
    } else {
        mediaType = AVMediaTypeVideo;
    }
    AVAuthorizationStatus videoAuthStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if (videoAuthStatus == AVAuthorizationStatusNotDetermined) {
        [AVCaptureDevice requestAccessForMediaType:mediaType completionHandler:^(BOOL granted) {
            if (grantedBlock) {
                grantedBlock(granted);
            }
        }];
    }else if(videoAuthStatus == AVAuthorizationStatusRestricted || videoAuthStatus == AVAuthorizationStatusDenied) {
        if (grantedBlock) {
            grantedBlock(NO);
        }
    }else{
        if (grantedBlock) {
            grantedBlock(YES);
        }
    }
}

-(void)startRecordBlock:(void(^)(void))recordBlock{
    
    NSDictionary *recordSetting = [self getAudioSetting];
    NSError *recorderError;
    
    self.recorder = [[AVAudioRecorder alloc] initWithURL:[NSURL fileURLWithPath:self.filePath] settings:recordSetting error:&recorderError];
    if (recorderError) {
        NSLog(@"%@", [recorderError description]);
    } else {
        self.recorder.meteringEnabled = YES;
        self.recorder.delegate = self;
        [self.recorder prepareToRecord];
        [self.recorder record];
    }
}

-(void)resumeRecord{
    [self.recorder record];
}

-(void)pauseRecord{
    if ([self.recorder isRecording]) {
        [self.recorder pause];
    }
}

-(void)stopRecord{
    [self.recorder stop];
    self.recorder = nil;
    [self.recordTimer invalidate];
    self.recordTimer = nil;
}

-(void)startPlayWithUrl:(NSURL *)url atTime:(float)value{
    
    NSError *playerError;
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&playerError];
    if (playerError) {
        NSLog(@"playerError = %@", [playerError description]);
        return;
    } else {
        self.player.delegate = self;
        self.player.volume = 0.99;
        [self.player prepareToPlay];
        self.player.currentTime = self.player.duration*value;
        [self.player play];
        
        CADisplayLink *displayLink = [CADisplayLink displayLinkWithTarget:[ZHWeakProxy proxyWithTarget:self] selector:@selector(update)];
        displayLink.paused = NO;
        [displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
        self.displayLink = displayLink;
    }
}
-(void)update{
    @weakify(self)
    if ([self.delegate respondsToSelector:@selector(playerPlaying:andDuration:)]) {
        @strongify(self)
        [self.delegate playerPlaying:self.player.currentTime andDuration:self.player.duration];
    }
}

-(void)pausePlay{
    [self.player pause];
    self.displayLink.paused = YES;
}

-(void)stopPlay{
    [self invalidateDisplayLink];
    [self.player stop];
    self.player = nil;
    self.delegate = nil;
}

-(void)invalidateDisplayLink{
    self.displayLink.paused = YES;
    [self.displayLink invalidate];
    self.displayLink = nil;
}

-(BOOL)isPlaying{
    return self.player.isPlaying;
}
-(BOOL)isRecording{
    return self.recorder.isRecording;
}
-(float)curTime{
    return self.player.currentTime;
}
-(float)duration{
    return self.player.duration;
}

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag{
    self.recordTimer.fireDate = [NSDate distantFuture];
    if ([self.delegate respondsToSelector:@selector(recorderDidFinishRecording:successfully:)]) {
        [self.delegate recorderDidFinishRecording:recorder successfully:flag];
    }
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    [[AVAudioSession sharedInstance] setActive:NO withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:nil];
    if ([self.delegate respondsToSelector:@selector(playerDidFinishPlaying:successfully:)]) {
        [self.delegate playerDidFinishPlaying:player successfully:flag];
    }
}

-(NSDictionary *)getAudioSetting{
    NSMutableDictionary *dicM = [NSMutableDictionary dictionary];
    [dicM setObject:@(kAudioFormatLinearPCM) forKey:AVFormatIDKey];
    [dicM setObject:@(8000) forKey:AVSampleRateKey];
    [dicM setObject:@(1) forKey:AVNumberOfChannelsKey];
    [dicM setObject:@(16) forKey:AVLinearPCMBitDepthKey];
    [dicM setObject:@(YES) forKey:AVLinearPCMIsFloatKey];
    return dicM;
}

@end
