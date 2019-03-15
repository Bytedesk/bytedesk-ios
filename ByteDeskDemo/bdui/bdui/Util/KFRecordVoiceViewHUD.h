//
//  KFRecordVoiceViewHUD.h
//  ChatViewController
//
//  Created by jack on 14-5-20.
//  Copyright (c) 2014年 appkefu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KFRecordVoiceViewHUD : UIView

//+(KFRecordVoiceViewHUD *)sharedInstance;

@property (nonatomic, strong) UIImageView   *microphoneImageView;
@property (nonatomic, strong) UIImageView   *signalWaveImageView;
@property (nonatomic, strong) UIImageView   *cancelArrowImageView;
@property (nonatomic, strong) UILabel       *hintLabel;

//
-(void) startVoiceRecordingToUsername:(NSString *)username;
-(NSString *) stopVoiceRecording;
-(void) cancelVoiceRecording;

//
//-(void) startVoicePlayingWithFilename:(NSString *)filename;


@end
