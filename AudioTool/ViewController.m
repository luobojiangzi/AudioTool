//
//  ViewController.m
//  AudioTool
//
//  Created by zhihuili on 2018/12/23.
//  Copyright © 2018 智慧  李. All rights reserved.
//

#import "ViewController.h"
#import "AudioRecordAndPlayVC.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"AudioTool";
    UIButton *recordAndPlayBtn = [[UIButton alloc] init];
    [recordAndPlayBtn setTitle:@"音频录制和播放" forState:UIControlStateNormal];
    [recordAndPlayBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [recordAndPlayBtn addTarget:self action:@selector(recordAndPlay) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:recordAndPlayBtn];
    [recordAndPlayBtn makeConstraints:^(MASConstraintMaker *make) {
        make.center.offset(0);
    }];
    
}
-(void)recordAndPlay{
    [self.navigationController pushViewController:[[AudioRecordAndPlayVC alloc] init] animated:YES];
}
@end
