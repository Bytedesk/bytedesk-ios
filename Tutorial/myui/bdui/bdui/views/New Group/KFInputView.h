//
//  KFInputView.h
//  ChatViewController
//
//  Created by jack on 14-4-29.
//  Copyright (c) 2014年 appkefu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KFInputViewDelegate <NSObject>

-(void)showMenuButtonPressed:(id)sender;            //
-(void)switchVoiceButtonPressed:(id)sender;         //
-(void)switchEmotionButtonPressed:(id)sender;       //
-(void)switchPlusButtonPressed:(id)sender;          //
-(void)sendMessage:(NSString *)content;             //

//
-(void)recordVoiceButtonTouchDown:(id)sender;       //
-(void)recordVoiceButtonTouchUpInside:(id)sender;   //
-(void)recordVoiceButtonTouchUpOutside:(id)sender;  //
-(void)recordVoiceButtonTouchDragInside:(id)sender; //
-(void)recordVoiceButtonTouchDragOutside:(id)sender;//

@end


@interface KFInputView : UIView<UITextViewDelegate>

@property (nonatomic, weak) id<KFInputViewDelegate> delegate;            //

//是否显示自定义菜单switch按钮，只有高级用户可以显示，通过判断appkey验证返回
@property (nonatomic, assign) BOOL               shouldShowInputBarSwitchMenu;   //

//
@property (nonatomic, strong) UIToolbar          *inputToolbar;          //输入框主View

@property (nonatomic, strong) UIButton           *showMenuButton;        //显示自定义菜单
@property (nonatomic, strong) UIView             *verticalLineView;      //“显示自定义菜单”右侧黑色竖线
@property (nonatomic, strong) UIButton           *switchVoiceButton;     //
@property (nonatomic, strong) UIButton           *recordVoiceButton;     //
@property (nonatomic, strong) UITextView         *inputTextView;         //文本输入框
@property (nonatomic, strong) UIButton           *switchEmotionButton;   //切换表情
@property (nonatomic, strong) UIButton           *switchPlusButton;      //切换扩展

@property (nonatomic, assign) CGFloat            inputTextViewMaxHeight;     //
@property (nonatomic, assign) CGFloat            inputTextViewMaxLinesCount; //



@end
