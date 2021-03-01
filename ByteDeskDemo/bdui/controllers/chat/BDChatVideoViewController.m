//
//  BDChatVideoViewController.m
//  bytedesk-ui
//
//  Created by 宁金鹏 on 2021/2/9.
//  Copyright © 2021 KeFuDaShi. All rights reserved.
//

#import "BDChatVideoViewController.h"

#import <SJVideoPlayer/SJVideoPlayer.h>

@interface BDChatVideoViewController ()

//
@property (nonatomic, strong, readonly) SJVideoPlayer *player;

@end

@implementation BDChatVideoViewController

@synthesize videoUrl;

//https://github.com/changsanjiang/SJVideoPlayer
//https://github.com/changsanjiang/SJVideoPlayer/wiki/Documents#3.2
//https://github.com/changsanjiang/SJVideoPlayer/wiki/%E5%BF%AB%E9%80%9F%E5%BC%80%E5%A7%8B
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // TODO: 待优化界面
    _player = SJVideoPlayer.player;
    [self.view addSubview:_player.view];
    _player.view.frame = CGRectMake(0, 0, self.view.frame.size.width, 400);
    _player.view.center = self.view.center;
    
//    [_player.view mas_makeConstraints:^(MASConstraintMaker *make) {
//        if (@available(iOS 11.0, *)) {
//            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
//        } else {
//            make.top.offset(20);
//        }
//        make.left.right.offset(0);
//        make.height.equalTo(self.player.view.mas_width).multipliedBy(9/16.0);
//    }];
    
    // startPosition: 表示从0s的位置处开始播放
    SJVideoPlayerURLAsset *asset = [SJVideoPlayerURLAsset.alloc initWithURL:[NSURL URLWithString:videoUrl] startPosition:0];
    _player.URLAsset = asset;
    
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [_player vc_viewDidAppear];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_player vc_viewWillDisappear];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [_player vc_viewDidDisappear];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
