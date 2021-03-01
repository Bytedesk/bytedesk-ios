//
//  KFDSInputBar.h
//  feedback
//
//  Created by 宁金鹏 on 2017/2/22.
//  Copyright © 2017年 宁金鹏. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QMUIKit/QMUIKit.h>

@class KFDSTextView;


@protocol KFDSInputBarDelegate <NSObject>

-(void)textViewHeightChanged:(NSString *)text height:(CGFloat)textHeight;

-(void)showMenuButtonPressed:(id)sender;

-(void)switchVoiceButtonPressed:(id)sender;

-(void)switchEmotionButtonPressed:(id)sender;

-(void)switchPlusButtonPressed:(id)sender;

-(void)sendMessage:(NSString *)content;

-(void)recordVoiceButtonTouchDown:(id)sender;

-(void)recordVoiceButtonTouchUpInside:(id)sender;

-(void)recordVoiceButtonTouchUpOutside:(id)sender;

-(void)recordVoiceButtonTouchDragInside:(id)sender;

-(void)recordVoiceButtonTouchDragOutside:(id)sender;


@end


@interface KFDSInputBar : UIToolbar<UITextViewDelegate>

-(instancetype)initWithShowMenu:(BOOL)shouldShowInputBarSwitchMenu;

//
@property (nonatomic, weak) id<KFDSInputBarDelegate> mydelegate;            //

//
@property (nonatomic, strong) QMUIButton           *showMenuButton;        //显示自定义菜单
@property (nonatomic, strong) UIView             *verticalLineView;      //“显示自定义菜单”右侧黑色竖线

@property (nonatomic, strong) QMUIButton           *switchVoiceButton;     //
@property (nonatomic, strong) QMUIButton           *recordVoiceButton;     //

@property (nonatomic, strong) KFDSTextView         *inputTextView;         //文本输入框

@property (nonatomic, strong) QMUIButton           *switchEmotionButton;   //切换表情
@property (nonatomic, strong) QMUIButton           *switchPlusButton;      //切换扩展

@property (nonatomic, assign) CGFloat            inputTextViewMaxHeight;     //
@property (nonatomic, assign) CGFloat            inputTextViewMaxLinesCount; //


@end



