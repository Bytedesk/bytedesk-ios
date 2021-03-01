//
//  KFDSRecordVoiceViewHUD.h
//  feedback
//
//  Created by 宁金鹏 on 2017/2/22.
//  Copyright © 2017年 宁金鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KFDSRecordVoiceViewHUD : UIView

@property (nonatomic, strong) UIImageView   *microphoneImageView;
@property (nonatomic, strong) UIImageView   *signalWaveImageView;
@property (nonatomic, strong) UIImageView   *cancelArrowImageView;
@property (nonatomic, strong) UILabel       *hintLabel;

//
-(void) startVoiceRecordingToUsername:(NSString *)username;

-(NSString *) stopVoiceRecording;

-(void) cancelVoiceRecording;

@end
