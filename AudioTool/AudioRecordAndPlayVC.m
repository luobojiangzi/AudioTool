//
//  AudioRecordAndPlay.m
//  AudioTool
//
//  Created by zhihuili on 2018/12/24.
//  Copyright © 2018 智慧  李. All rights reserved.
//

#import "AudioRecordAndPlayVC.h"
#import "AudioPlayHeaderView.h"
#import "AudioPlayCell.h"
#import "BSVoiceModel.h"

@interface AudioRecordAndPlayVC ()<UITableViewDelegate,UITableViewDataSource>

@property(weak,nonatomic)UITableView *tableView;
@property(strong,nonatomic)NSMutableArray *eventVoicesArr;
@property(copy,nonatomic)NSString *filePath;
@property(assign,nonatomic)int voiceCount;

@end

static NSString *AudioRecordAndPlayVCHeaderViewRI = @"AudioRecordAndPlayVCHeaderViewRI";
static NSString *AudioRecordAndPlayVCCellRI = @"AudioRecordAndPlayVCCellRI";
/*
 iOS端音频录制我们设置的是wav格式   但是在安卓端是不能播放的，所以iOS妥协下，上传的时候wav转成mar格式到服务器，下载的时候mar再转成wav
 */
@implementation AudioRecordAndPlayVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.voiceCount = 0;
    //可以先获取界面数据，拿到音频网络路径后，开始下载[NetService downloadFile]  self.voiceCount是数据里面拿到的音频数量  然后新录制的 self.voiceCount+1
    //上传音频[NetService uploadVoiceTo]
    [self initUI];
}
-(void)initUI{
    
    self.title = @"音频录制和播放";
    
    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = back;
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"录音" style:UIBarButtonItemStylePlain target:self action:@selector(record)];
    self.navigationItem.rightBarButtonItem = right;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    tableView.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
    [tableView registerClass:[AudioPlayHeaderView class] forHeaderFooterViewReuseIdentifier:AudioRecordAndPlayVCHeaderViewRI];
    [tableView registerClass:[AudioPlayCell class] forCellReuseIdentifier:AudioRecordAndPlayVCCellRI];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.sectionFooterHeight = 10;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.bounces = NO;
    tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
    }];
    [self setAudioSession];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.eventVoicesArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AudioPlayCell *cell = [tableView dequeueReusableCellWithIdentifier:AudioRecordAndPlayVCCellRI];
    BSVoiceModel *voiceModel = self.eventVoicesArr[indexPath.row];
    cell.voiceModel = voiceModel;
    @weakify(self)
    cell.audioStartPlay = ^(NSTimeInterval curTime, NSTimeInterval duration) {
        NSLog(@"start");
        @strongify(self)
   
        [self setAudioSession];
        
        for (int i =0; i<self.eventVoicesArr.count; ++i) {
            if (i!=indexPath.row) {
                BSVoiceModel *model = self.eventVoicesArr[i];
                if (model.isCurPlayingCell) {
                    model.isCurPlayingCell = NO;
                    model.value = curTime/duration;
                    model.curTimeStr = [NSString convertTime:model.value*model.duration];
                    AudioPlayCell *cell = (AudioPlayCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:indexPath.section]];
                    cell.audioPlayBtn.selected = NO;
                    return ;
                }
            }
        }
    };
//    cell.audioEndPlay = ^{
//        NSLog(@"end");
//        voiceModel.isCurPlayingCell = NO;
//        voiceModel.value = 0.0;
//    };
    cell.editName = ^(UIButton *btn) {
        @strongify(self)
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"修改音频名称" message:btn.currentTitle preferredStyle:UIAlertControllerStyleAlert];
        [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = @"请输入音频名称";
            textField.text = btn.currentTitle;
        }];
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UITextField *textField = alertController.textFields.firstObject;
            if (textField.text.length<0) {
                kMBShowPrompt(@"音频名称不能为空", nil)
                return ;
            }
            voiceModel.attach_name = textField.text;
            [btn setTitle:textField.text forState:UIControlStateNormal];
        }]];
        [self presentViewController:alertController animated:true completion:nil];
    };
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}
- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        BSVoiceModel *voiceModel =  self.eventVoicesArr[indexPath.row];
        if (voiceModel.isCurPlayingCell) {
            [[AudioTool shareInstance] stopPlay];
        }
        [self.eventVoicesArr removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self deleteFilePath:[self getMarFilePathWithStr:indexPath.row]];
        [self deleteFilePath:[self getWavFilePathWithStr:indexPath.row]];
    }];
    return @[deleteRowAction];
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
      AudioPlayHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:AudioRecordAndPlayVCHeaderViewRI];
    return headerView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 350;
}
-(void)record{
//    if (self.eventVoicesArr.count>2) {
//        NSLog(@"最多录制3个音频");
//        return ;
//    }
    if ([AudioTool shareInstance].isPlaying) {
        for (int i = 0; i<self.eventVoicesArr.count; ++i) {
            BSVoiceModel *model = self.eventVoicesArr[i];
            if (model.isCurPlayingCell) {
                model.isCurPlayingCell = NO;
                model.value = [AudioTool shareInstance].curTime/[AudioTool shareInstance].duration;
                [self.tableView  reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
                break;
            }
        }
        [[AudioTool shareInstance] stopPlay];
    }
    [self setAudioSession];
    NSString *filePath = [self getWavFilePathWithStr:self.voiceCount];
    self.filePath = filePath;
    RecordVoiceView *view = [[RecordVoiceView alloc] initWithTitle:@"" withFileName:@"新录音"];
    view.begainRecordBlock = ^{
        [AudioTool shareInstance].filePath = filePath;
        [[AudioTool shareInstance] startRecordBlock:^{
        }];
    };
    view.resumeRecordBlock = ^{
        [[AudioTool shareInstance] resumeRecord];
    };
    view.pauseRecordBlock = ^{
        [[AudioTool shareInstance] pauseRecord];
    };
    view.removeRecordBlock = ^{
        [self deleteFilePath:self.filePath];
        [[AudioTool shareInstance] stopRecord];
    };
    view.saveRecordBlock = ^(int timeNum){
        [self setAudioSession];
        [[AudioTool shareInstance] stopRecord];
        if (timeNum<1) {
            kMBShowPrompt(@"录音时间太短", nil)
            return ;
        }
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *wavStr = self.filePath;
        NSString *amrStr = [[self.filePath stringByDeletingPathExtension] stringByAppendingString:@".amr"];
        if ([fileManager fileExistsAtPath:wavStr]) {
            NSLog(@"wav存在");
            BOOL isSuccess = [VoiceConverter ConvertWavToAmr:wavStr amrSavePath:amrStr];
            NSLog(@"isSuccess=%d",isSuccess);
            if (isSuccess) {
                if ([fileManager fileExistsAtPath:amrStr]) {
                    /*
                    NSData *data = [NSData dataWithContentsOfFile:amrStr];
                    [NetService uploadVoiceTo:@"app/event/saveEventVoices" params:@{@"event_id":@"1"} isAddShow:NO voiceData:data toScale:1.0 success:^(id objc) {
                        kMBShowPrompt(@"---上传成功---", nil)
                        BSVoiceModel *voiceModel = [[BSVoiceModel alloc] init];
                        voiceModel.attach_id = objc[@"attach_id"];
                        voiceModel.attach_name = objc[@"attach_name"];
                        voiceModel.attach_url = objc[@"attach_url"];
                        voiceModel.filePath = wavStr;
                        voiceModel.duration = timeNum;
                        voiceModel.curTimeStr = @"00:00";
                        voiceModel.allTimeStr = [NSString convertTime:timeNum];
                        voiceModel.value = 0.0;
                        voiceModel.isCurPlayingCell = NO;
                        [self.eventVoicesArr addObject:voiceModel];
                        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
                        self.voiceCount+=1;
                    } failure:^(NSString *errorCode, NSString *errorMsg) {
                        kMBShowPrompt(@"---上传失败---", nil)
                        [self deleteFilePath:wavStr];
                    }];
                    */
                    
                    BSVoiceModel *voiceModel = [[BSVoiceModel alloc] init];
                    voiceModel.attach_name = [NSString stringWithFormat:@"音频%d",self.voiceCount];
                    voiceModel.filePath = wavStr;
                    voiceModel.duration = timeNum;
                    voiceModel.curTimeStr = @"00:00";
                    voiceModel.allTimeStr = [NSString convertTime:timeNum];
                    voiceModel.value = 0.0;
                    voiceModel.isCurPlayingCell = NO;
                    [self.eventVoicesArr addObject:voiceModel];
                    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
                    self.voiceCount+=1;
                    [self deleteFilePath:amrStr];
                } else {
                    kMBShowPrompt(@"amr文件不存在", nil)
                    [self deleteFilePath:wavStr];
                }
            } else {
                kMBShowPrompt(@"wav转mar失败", nil)
                [self deleteFilePath:wavStr];
                [self deleteFilePath:amrStr];
            }
        }else{
            kMBShowPrompt(@"wav文件不存在", nil)
        }
    };
    
}
-(void)back{
    //清除本地音频数据
    [self deleteCaches];
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)deleteFilePath:(NSString *)filePath{
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager  fileExistsAtPath:filePath]) {
        if ([manager isDeletableFileAtPath:filePath]) {
            [manager removeItemAtPath:filePath error:nil];
        }
    } else {
        
    }
}
- (void)deleteCaches {
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSFileManager *manager = [NSFileManager defaultManager];
    NSArray *paths = [manager contentsOfDirectoryAtPath:documentPath error:nil];
    for (int i = 0; i < paths.count; i ++) {
        NSString *subPath  = paths[i];
        BOOL isFound = ([subPath rangeOfString:@".wav"].location!=NSNotFound)||([subPath rangeOfString:@".mar"].location!=NSNotFound);
        if (isFound) {
            if ([manager isDeletableFileAtPath:subPath]) {
                [manager removeItemAtPath:subPath error:nil];
            }
        }
    }
}
#pragma mark 获取Wav路径
-(NSString *)getWavFilePathWithStr:(NSInteger)num{
    NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"myRecord%zd.wav",num]];
    NSLog(@"WavFilePath=%@",filePath);
    return filePath;
}
#pragma mark 获取Mar路径
-(NSString *)getMarFilePathWithStr:(NSInteger)num{
    NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"myRecord%zd.mar",num]];
    NSLog(@"MarFilePath=%@",filePath);
    return filePath;
}
/**
 *  设置音频会话
 */
-(void)setAudioSession{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioRouteChangeListenerCallback:)   name:AVAudioSessionRouteChangeNotification object:nil];
    AVAudioSessionRouteDescription* route = [[AVAudioSession sharedInstance] currentRoute];
    for (AVAudioSessionPortDescription* desc in [route outputs]) {
        if ([[desc portType] isEqualToString:AVAudioSessionPortHeadphones]) {
            //耳机插入状态
            [self audioType2];
        } else {
            [self audioType1];
        }
    }
    [[UIDevice currentDevice] setProximityMonitoringEnabled:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(senderStateChange:) name:UIDeviceProximityStateDidChangeNotification object:nil];
}
- (void)audioRouteChangeListenerCallback:(NSNotification*)notification{
    NSDictionary *interuptionDict = notification.userInfo;
    NSInteger routeChangeReason = [[interuptionDict valueForKey:AVAudioSessionRouteChangeReasonKey] integerValue];
    switch (routeChangeReason) {
        case AVAudioSessionRouteChangeReasonNewDeviceAvailable:
        {
            NSLog(@"AVAudioSessionRouteChangeReasonNewDeviceAvailable");
            [self audioType2];
        }
            break;
        case AVAudioSessionRouteChangeReasonOldDeviceUnavailable:
        {
            NSLog(@"AVAudioSessionRouteChangeReasonOldDeviceUnavailable");
            NSLog(@"耳机拔出，停止播放操作");
            [self audioType1];
        }
            break;
        case AVAudioSessionRouteChangeReasonCategoryChange:
            // called at start - also when other audio wants to play
            NSLog(@"AVAudioSessionRouteChangeReasonCategoryChange");
            break;
    }
}
- (void)audioType1 {
    AVAudioSession *audioSession=[AVAudioSession sharedInstance];
    //设置为播放和录音状态，以便可以在录制完之后播放录音
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker error:nil];
    [audioSession setActive:YES error:nil];
    //此处需要设置一下，可能会出现音量变小的问题。
    [audioSession overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:nil];
}
- (void)audioType2 {
    AVAudioSession *audioSession=[AVAudioSession sharedInstance];
    //设置为播放和录音状态，以便可以在录制完之后播放录音
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    [audioSession setActive:YES error:nil];
}
- (void)senderStateChange:(NSNotificationCenter*)not{
    if ([[UIDevice currentDevice] proximityState] == YES){
        NSLog(@"Device is close to user");
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    }else{
        NSLog(@"Device is not close to user");
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    }
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"---%@释放了---",NSStringFromClass([self class]));
}
-(NSMutableArray *)eventVoicesArr{
    if (!_eventVoicesArr) {
        _eventVoicesArr = [NSMutableArray array];
    }
    return _eventVoicesArr;
}
@end
