//
//  AudioPlayHeaderView.m
//  AudioTool
//
//  Created by zhihuili on 2018/12/24.
//  Copyright © 2018 智慧  李. All rights reserved.
//

#import "AudioPlayHeaderView.h"

@interface AudioPlayHeaderView ()

@property(weak,nonatomic)UIImageView *imageView;

@end

@implementation AudioPlayHeaderView

-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        UIImageView *imageView = [[UIImageView  alloc] initWithImage:KImageNamed(@"familyCircle")];
        [self.contentView addSubview:imageView];
        self.imageView = imageView;
    }
    return self;
}
-(void)layoutSubviews{
    [super layoutSubviews];
    [self.imageView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
    }];
}
@end
