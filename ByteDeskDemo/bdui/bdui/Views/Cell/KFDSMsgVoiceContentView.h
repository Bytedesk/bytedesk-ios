//
//  KFDSMsgVoiceContentView.h
//  feedback
//
//  Created by 萝卜丝·Bytedesk.com on 2017/2/18.
//  Copyright © 2017年 萝卜丝·Bytedesk.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KFDSMsgBaseContentView.h"

@protocol KFDSPlayAudioUIDelegate <NSObject>

-(void)startPlayingAudioUI;  //点击一开始就要显示

@optional

- (void)retryDownloadMsg; //重收消息

@end




@interface KFDSMsgVoiceContentView : KFDSMsgBaseContentView

@property (nonatomic, weak) id<KFDSPlayAudioUIDelegate> audioUIDelegate;

- (void)setPlaying:(BOOL)isPlaying;

@end
