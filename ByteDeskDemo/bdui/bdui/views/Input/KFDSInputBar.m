//
//  KFDSInputBar.m
//  ChatUI
//
//  Created by jack on 16/9/2.
//  Copyright © 2016年 chatsdk.org. All rights reserved.
//

#import "KFDSInputBar.h"
#import "KFDSTextView.h"

#define OFFSET 5

//define this constant if you want to enable auto-boxing for default syntax
#define MAS_SHORTHAND_GLOBALS
#import <Masonry/Masonry.h>

@interface KFDSInputBar()

@property(nonatomic, assign)  NSInteger     mScreenWidth;

@end

@implementation KFDSInputBar

@synthesize mydelegate,

showMenuButton,
verticalLineView,
switchVoiceButton,
recordVoiceButton,
inputTextView,
switchEmotionButton,
switchPlusButton,

inputTextViewMaxHeight,
inputTextViewMaxLinesCount;


-(id) initWithShowMenu:(BOOL)shouldShowInputBarSwitchMenu {
    
    self = [super init];
    if (self) {
        //Masonry will also call view1.translatesAutoresizingMaskIntoConstraints = NO; for you.
        //https://github.com/SnapKit/Masonry
        //self.translatesAutoresizingMaskIntoConstraints = NO;
        self.backgroundColor = [UIColor whiteColor];
        // iOS11适配UIToolbar无法点击问题
        // http://www.jianshu.com/p/539ca2895b97
        if (@available(iOS 11, *)) {
            [self layoutIfNeeded];
        }
        //
        _mScreenWidth = [UIScreen mainScreen].bounds.size.width;
        
        if (shouldShowInputBarSwitchMenu) {
            [self addSubview:[self showMenuButton]];
            [self addSubview:[self verticalLineView]];
        }

        [self addSubview:[self switchVoiceButton]];
        [self addSubview:[self recordVoiceButton]];
        [self addSubview:[self inputTextView]];
        [self addSubview:[self switchEmotionButton]];
        [self addSubview:[self switchPlusButton]];

        if (shouldShowInputBarSwitchMenu) {
            [self initViewConstraints];
        }
        else {
            [self initViewConstraintsWithoutMenu];
        }
        
        [self.recordVoiceButton setHidden:true];
    }
    return self;
}


//- (void)test:(QMUIButton *)button {
//    NSLog(@"%s", __PRETTY_FUNCTION__);
//}


-(UIButton *)showMenuButton {
    
    if (!showMenuButton) {
        showMenuButton = [QMUIButton new];
        [showMenuButton setImage:[UIImage imageNamed:@"Mode_texttolist_ios7" inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
        [showMenuButton setImage:[UIImage imageNamed:@"Mode_texttolistHL_ios7" inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil] forState:UIControlStateHighlighted];
        [showMenuButton addTarget:self action:@selector(showMenuButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return showMenuButton;
}


-(UIView *)verticalLineView {
    
    if (!verticalLineView) {
        verticalLineView = [UIView new];
        [verticalLineView setBackgroundColor:[UIColor lightGrayColor]];
    }
    return verticalLineView;
}


-(UIButton *)switchVoiceButton {
    
    if (!switchVoiceButton) {
        switchVoiceButton = [QMUIButton new];
        [switchVoiceButton setImage:[UIImage imageNamed:@"ToolViewInputVoice_ios7" inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
        [switchVoiceButton setImage:[UIImage imageNamed:@"ToolViewInputVoiceHL_ios7" inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil] forState:UIControlStateHighlighted];
        
        [switchVoiceButton addTarget:self action:@selector(switchVoiceButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return switchVoiceButton;
}


-(UIButton *)recordVoiceButton {
    if (!recordVoiceButton) {
        recordVoiceButton = [QMUIButton new];
        
        [recordVoiceButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [recordVoiceButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
        [[recordVoiceButton titleLabel] setFont:[UIFont systemFontOfSize:14.0f]];
        [recordVoiceButton setTitle:NSLocalizedString(@"Press To Record", nil) forState:UIControlStateNormal];
        [recordVoiceButton setTitle:NSLocalizedString(@"Lose To Cancel", nil) forState:UIControlStateHighlighted];
        
        UIImage *normalImage = [UIImage imageNamed:@"VoiceBtn_Black_ios7" inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil];
        [recordVoiceButton setBackgroundImage:[normalImage stretchableImageWithLeftCapWidth:normalImage.size.width/2 topCapHeight:normalImage.size.height/2] forState:UIControlStateNormal];
        UIImage *highligntedImage = [UIImage imageNamed:@"VoiceBtn_BlackHL_ios7" inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil];
        [recordVoiceButton setBackgroundImage:[highligntedImage stretchableImageWithLeftCapWidth:highligntedImage.size.width/2 topCapHeight:highligntedImage.size.height/2] forState:UIControlStateHighlighted];
        
        //
        [recordVoiceButton addTarget:self action:@selector(recordVoiceButtonTouchDown:) forControlEvents:UIControlEventTouchDown];
        [recordVoiceButton addTarget:self action:@selector(recordVoiceButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        [recordVoiceButton addTarget:self action:@selector(recordVoiceButtonTouchUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
        [recordVoiceButton addTarget:self action:@selector(recordVoiceButtonTouchDragInside:) forControlEvents:UIControlEventTouchDragInside];
        [recordVoiceButton addTarget:self action:@selector(recordVoiceButtonTouchDragOutside:) forControlEvents:UIControlEventTouchDragOutside];
        
    }
    return recordVoiceButton;
}

-(KFDSTextView *)inputTextView {
    
    if (!inputTextView) {
        inputTextView = [KFDSTextView new];
        inputTextView.delegate = self;
        // 设置文本框最大行数
        inputTextView.maxNumberOfLines = 4;
        
        // 监听文本框文字高度改变
        __weak __typeof(self)weakSelf = self;
        inputTextView.yz_textHeightChangeBlock = ^(NSString *text,CGFloat textHeight){
            // 文本框文字高度改变会自动执行这个【block】，可以在这【修改底部View的高度】
            // 设置底部条的高度 = 文字高度 + textView距离上下间距约束
            // 为什么添加10 ？（10 = 底部View距离上（5）底部View距离下（5）间距总和）
            //            _bottomHCons.constant = textHeight + 10;
            
            NSLog(@"%s", __PRETTY_FUNCTION__);
            if (text.length == 0) {
                return ;
            }
            
            [weakSelf.inputTextView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@(textHeight));
            }];
            
            CGFloat barHeight = textHeight + 2*OFFSET;
            if ([weakSelf.mydelegate respondsToSelector:@selector(textViewHeightChanged:height:)]) {
                [weakSelf.mydelegate textViewHeightChanged:text height:barHeight];
            }
            
        };
    }
    return inputTextView;
}

-(UIButton *)switchEmotionButton {
    
    if (!switchEmotionButton) {
        switchEmotionButton = [QMUIButton new];
        [switchEmotionButton setImage:[UIImage imageNamed:@"ToolViewEmotion_ios7" inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
        [switchEmotionButton setImage:[UIImage imageNamed:@"ToolViewEmotionHL_ios7" inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil] forState:UIControlStateHighlighted];
        [switchEmotionButton addTarget:self action:@selector(switchEmotionButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return switchEmotionButton;
}

-(UIButton *)switchPlusButton {
    
    if (!switchPlusButton) {
        switchPlusButton = [QMUIButton new];
        [switchPlusButton setImage:[UIImage imageNamed:@"TypeSelectorBtn_Black_ios7" inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
        [switchPlusButton setImage:[UIImage imageNamed:@"TypeSelectorBtnHL_Black_ios7" inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil] forState:UIControlStateHighlighted];
        [switchPlusButton addTarget:self action:@selector(switchPlusButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return switchPlusButton;
}

-(CGFloat)inputTextViewMaxHeight
{
    if (!inputTextViewMaxHeight) {
        inputTextViewMaxHeight = 100.0f;
    }
    return inputTextViewMaxHeight;
}


#pragma mark - Constrains

//具有自定义菜单
-(void)initViewConstraints {
    
    __weak typeof(self) weakSelf = self;
    [showMenuButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf);
        make.bottom.equalTo(weakSelf.mas_bottom).offset(-OFFSET);
        make.width.equalTo(@43);
        make.height.equalTo(@43);
    }];

    [verticalLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(showMenuButton.mas_right).offset(0.5);
        make.bottom.equalTo(weakSelf.mas_bottom);
        make.width.equalTo(@0.5);
        make.height.equalTo(weakSelf.mas_height);
    }];

    [switchVoiceButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(verticalLineView.mas_right).offset(OFFSET);
        make.bottom.equalTo(weakSelf.mas_bottom).offset(-OFFSET);
        make.height.equalTo(@36);
        make.width.equalTo(@36);
    }];
    
    [self initViewsConstainsCommon:weakSelf];
}

///无自定义菜单
-(void)initViewConstraintsWithoutMenu {
    
    __weak typeof(self) weakSelf = self;
    [switchVoiceButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).offset(OFFSET);
        make.bottom.equalTo(weakSelf).offset(-OFFSET);
        make.height.equalTo(@36);
        make.width.equalTo(@36);
    }];
    
    [self initViewsConstainsCommon:weakSelf];
}


//公共函数
-(void)initViewsConstainsCommon:(UIView *)superView {
    
    [switchPlusButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(superView.mas_bottom).offset(-OFFSET);
        make.right.equalTo(superView.mas_right).offset(-5);
        make.height.equalTo(@36);
        make.width.equalTo(@36);
    }];
    
    [switchEmotionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(superView.mas_bottom).offset(-OFFSET);
        make.right.equalTo(switchPlusButton.mas_left).offset(-2);
        make.height.equalTo(@36);
        make.width.equalTo(@36);
    }];
    
    [inputTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(switchVoiceButton.mas_right).offset(OFFSET);
        make.bottom.equalTo(superView.mas_bottom).offset(-OFFSET);
//        make.right.equalTo(switchEmotionButton.mas_left).offset(-OFFSET);
        make.width.equalTo(@(_mScreenWidth - 36 * 3 - OFFSET * 4));
        make.height.equalTo(@34.5);
    }];

    [recordVoiceButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(switchVoiceButton.mas_right);
        make.bottom.equalTo(superView.mas_bottom).offset(-OFFSET);
//        make.right.equalTo(switchEmotionButton.mas_left);
        make.width.equalTo(@(_mScreenWidth - 36 * 3 - OFFSET * 4));
        make.height.equalTo(@36);
    }];
}

#pragma mark UITextViewmydelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
//        NSLog(@"%s", __PRETTY_FUNCTION__);
    
    if(![textView hasText] && [text isEqualToString:@""]) {
        return NO;
    }
    
    if ([text isEqualToString:@"\n"]) {
        
        NSString *content = [textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        if ([content length] == 0) {
            return NO;
        }
        
        if ([mydelegate respondsToSelector:@selector(sendMessage:)]) {
            [mydelegate performSelector:@selector(sendMessage:) withObject:content];
        }
        
        [textView setText:@""];
        [self textViewDidChange:textView];
        
        return NO;
    }
    return YES;
}

-(void)textViewDidChange:(UITextView *)textView
{
//    NSLog(@"%s", __PRETTY_FUNCTION__);
    
}


#pragma mark - Selectors

-(void)showMenuButtonPressed:(id)sender {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
}

-(void)switchVoiceButtonPressed:(id)sender {
//    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    if ([mydelegate respondsToSelector:@selector(switchVoiceButtonPressed:)]) {
        [mydelegate performSelector:@selector(switchVoiceButtonPressed:) withObject:nil];
    }
    
    //如果当前按住说话按钮隐藏，则将其显示，并隐藏输入框
    if ([self recordVoiceButton].hidden) {
        
        [self recordVoiceButton].hidden = FALSE;
        [[self inputTextView] resignFirstResponder];
        [self inputTextView].hidden = TRUE;
        
        [[self switchVoiceButton] setImage:[UIImage imageNamed:@"ToolViewInputText_ios7" inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
        [[self switchVoiceButton] setImage:[UIImage imageNamed:@"ToolViewInputTextHL_ios7" inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil] forState:UIControlStateHighlighted];
        
        ////
        [[self switchEmotionButton] setImage:[UIImage imageNamed:@"ToolViewEmotion_ios7" inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
        [[self switchEmotionButton] setImage:[UIImage imageNamed:@"ToolViewEmotionHL_ios7" inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil] forState:UIControlStateHighlighted];
    }
    //如果当前按住说话按钮显示，则将其隐藏，并显示输入框，并将其获取焦点
    else
    {
        [self recordVoiceButton].hidden = TRUE;
        [self inputTextView].hidden = FALSE;
        [[self inputTextView] becomeFirstResponder];
        
        [[self switchVoiceButton] setImage:[UIImage imageNamed:@"ToolViewInputVoice_ios7" inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
        [[self switchVoiceButton] setImage:[UIImage imageNamed:@"ToolViewInputVoiceHL_ios7" inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil] forState:UIControlStateHighlighted];
    }
    
}

-(void)switchEmotionButtonPressed:(id)sender {
//    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    //执行mydelegate
    if ([mydelegate respondsToSelector:@selector(switchEmotionButtonPressed:)]) {
        [mydelegate performSelector:@selector(switchEmotionButtonPressed:) withObject:nil];
    }
    
    if (![self isFirstResponder])
    {
        //        [self becomeFirstResponder];
        
        [self recordVoiceButton].hidden = TRUE;
        [self inputTextView].hidden = FALSE;
        
        [[self switchVoiceButton] setImage:[UIImage imageNamed:@"ToolViewInputVoice_ios7" inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
        [[self switchVoiceButton] setImage:[UIImage imageNamed:@"ToolViewInputVoiceHL_ios7" inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil] forState:UIControlStateHighlighted];
        
        [[self switchEmotionButton] setImage:[UIImage imageNamed:@"ToolViewEmotion_ios7" inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
        [[self switchEmotionButton] setImage:[UIImage imageNamed:@"ToolViewEmotionHL_ios7" inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil] forState:UIControlStateHighlighted];
    }
    else
    {
        [self resignFirstResponder];
        
        [[self switchEmotionButton] setImage:[UIImage imageNamed:@"ToolViewInputText_ios7" inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
        [[self switchEmotionButton] setImage:[UIImage imageNamed:@"ToolViewInputTextHL_ios7" inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil] forState:UIControlStateHighlighted];
    }
    
}

-(void)switchPlusButtonPressed:(id)sender {
//    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    if ([mydelegate respondsToSelector:@selector(switchPlusButtonPressed:)]) {
        [mydelegate performSelector:@selector(switchPlusButtonPressed:) withObject:nil];
    }
    
    if (![self isFirstResponder])
    {
        [self recordVoiceButton].hidden = TRUE;
        [self inputTextView].hidden = FALSE;
        
        [[self switchVoiceButton] setImage:[UIImage imageNamed:@"ToolViewInputVoice_ios7" inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
        [[self switchVoiceButton] setImage:[UIImage imageNamed:@"oolViewInputVoiceHL_ios7" inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil] forState:UIControlStateHighlighted];
        
        [[self switchEmotionButton] setImage:[UIImage imageNamed:@"ToolViewEmotion_ios7" inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
        [[self switchEmotionButton] setImage:[UIImage imageNamed:@"ToolViewEmotionHL_ios7" inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil] forState:UIControlStateHighlighted];
    }
    else {
        
        [self resignFirstResponder];
        
        [[self switchEmotionButton] setImage:[UIImage imageNamed:@"ToolViewInputText_ios7" inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
        [[self switchEmotionButton] setImage:[UIImage imageNamed:@"ToolViewInputTextHL_ios7" inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil] forState:UIControlStateHighlighted];
    }
    
}

//
-(void)recordVoiceButtonTouchDown:(id)sender {
//    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    if ([mydelegate respondsToSelector:@selector(recordVoiceButtonTouchDown:)]) {
        [mydelegate performSelector:@selector(recordVoiceButtonTouchDown:) withObject:nil];
    }
    
}


-(void)recordVoiceButtonTouchUpInside:(id)sender {
//    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    if ([mydelegate respondsToSelector:@selector(recordVoiceButtonTouchUpInside:)]) {
        [mydelegate performSelector:@selector(recordVoiceButtonTouchUpInside:) withObject:nil];
    }
    
}


-(void)recordVoiceButtonTouchUpOutside:(id)sender{
//    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    if ([mydelegate respondsToSelector:@selector(recordVoiceButtonTouchUpOutside:)]) {
        [mydelegate performSelector:@selector(recordVoiceButtonTouchUpOutside:) withObject:nil];
    }
    
}


-(void)recordVoiceButtonTouchDragInside:(id)sender
{
    if ([mydelegate respondsToSelector:@selector(recordVoiceButtonTouchDragInside:)]) {
        [mydelegate performSelector:@selector(recordVoiceButtonTouchDragInside:) withObject:nil];
    }
}

-(void)recordVoiceButtonTouchDragOutside:(id)sender
{
    if ([mydelegate respondsToSelector:@selector(recordVoiceButtonTouchUpOutside:)]) {
        [mydelegate performSelector:@selector(recordVoiceButtonTouchDragOutside:) withObject:nil];
    }
    
}




@end





















