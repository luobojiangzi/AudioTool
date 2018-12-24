//
//  AudioTool.h
//  AudioTool
//
//  Created by zhihuili on 2018/12/23.
//  Copyright © 2018 智慧  李. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "VoiceConverter.h"

typedef NS_ENUM(NSInteger, AVRequestAccessType) {
    AVRequestAccessAudio = 0,
    AVRequestAccessVideo = 1
};

@protocol AudioToolDidFinish <NSObject>
@optional

-(void)playerPlaying:(NSTimeInterval)curTime andDuration:(NSTimeInterval)duration;

-(void)playerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag;

-(void)recorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag;

@end

@interface AudioTool : NSObject

+ (AudioTool *)shareInstance;

@property(weak,nonatomic)id<AudioToolDidFinish>delegate;

@property(copy,nonatomic)NSString *filePath;

@property(assign,nonatomic)BOOL isPlaying;

@property(assign,nonatomic)BOOL isRecording;

@property(assign,nonatomic)float curTime;
@property(assign,nonatomic)float duration;

-(void)requestAccessWith:(AVRequestAccessType)type isGranted:(void (^)(BOOL granted))grantedBlock;

-(void)startRecordBlock:(void(^)(void))recordBlock;

-(void)resumeRecord;

-(void)pauseRecord;

-(void)stopRecord;

-(void)startPlayWithUrl:(NSURL *)url atTime:(float)value;

-(void)pausePlay;

-(void)stopPlay;

@end
