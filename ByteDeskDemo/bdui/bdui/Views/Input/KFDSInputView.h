//
//  KFDSInputView.h
//  feedback
//
//  Created by 宁金鹏 on 2017/2/22.
//  Copyright © 2017年 宁金鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "KFDSInputBar.h"
#import "KFDSEmotionView.h"
#import "KFDSPlusView.h"
#import "KFDSMenuView.h"

@protocol KFDSInputViewDelegate <NSObject>

-(void)textViewHeightChanged:(NSString *)text height:(CGFloat)textHeight;

-(void)showMenuButtonPressed:(id)sender;

-(void)switchVoiceButtonPressed:(id)sender;

-(void)switchEmotionButtonPressed:(id)sender;

-(void)switchPlusButtonPressed:(id)sender;

-(void)sendMessage:(NSString *)content;

#pragma mark Record

-(void)recordVoiceButtonTouchDown:(id)sender;

-(void)recordVoiceButtonTouchUpInside:(id)sender;

-(void)recordVoiceButtonTouchUpOutside:(id)sender;

-(void)recordVoiceButtonTouchDragInside:(id)sender;

-(void)recordVoiceButtonTouchDragOutside:(id)sender;

#pragma mark Plus

-(void)sharePickPhotoButtonPressed:(id)sender;

-(void)shareTakePhotoButtonPressed:(id)sender;

-(void)shareRateButtonPressed:(id)sender;

@end



@interface KFDSInputView : UIView

@property (nonatomic, weak) id<KFDSInputViewDelegate> delegate;            //

//是否显示自定义菜单switch按钮，只有高级用户可以显示，通过判断appkey验证返回
@property (nonatomic, assign) BOOL                shouldShowInputBarSwitchMenu;   //

@property (nonatomic, strong) KFDSInputBar          *inputToolbar;          //输入框主View

@property (nonatomic, strong) KFDSEmotionView       *emotionView;

@property (nonatomic, strong) KFDSPlusView          *plusView;

@property (nonatomic, strong) KFDSMenuView          *menuView;

- (void) hideRate;

- (void) showRate;

@end



