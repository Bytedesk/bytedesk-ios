//
//  KFInputView.m
//  ChatViewController
//
//  Created by jack on 14-4-29.
//  Copyright (c) 2014年 appkefu.com. All rights reserved.
//

#import "KFInputView.h"

#define INPUTBAR_HEIGHT 60.0f
#define INPUTBAR_MAX_HEIGHT 200.0f

#define INPUTBAR_SHOWMENU_BUTTON_WIDTH 46.0f

#define INPUTBAR_SWITCH_EMOTION_PLUS_BUTTON_WIDTH_HEIGHT 36.0f

#define INPUTBAR_SWITCH_EMOTION_PLUS_TOP_MARGIN 5.0f
#define INPUTBAR_SWITCH_EMOTION_LEFT_MARGIN 5.0f
#define INPUTBAR_SWITCH_EMOTION_RIGHT_MARGIN 3.0f
#define INPUTBAR_SWITCH_PLUS_RIGHT_MARGIN 6.0f

#define INPUTBAR_SWITCH_VOICE_LEFT_MARGIN 5.0f
#define INPUTBAR_SWITCH_VOICE_TOP_MARGIN  5.0f
#define INPUTBAR_SWITCH_VOICE_BUTTON_WIDTH_HEIGHT 36.0f

#define INPUTBAR_INPUT_TEXTVIEW_TOP_MARGIN 5.0f
#define INPUTBAR_INPUT_TEXTVIEW_LEFT_MARGIN 5.0f

#define INPUTBAR_INPUT_TEXTVIEW_HEIGHT 34.5f
#define INPUTBAR_INPUT_TEXTVIEW_MAX_HEIGHT 188.0f

#define INPUTBAR_RECORD_VOICE_BUTTON_TOP_MARGIN 5.0f
#define INPUTBAR_RECORD_VOICE_BUTTON_LEFT_MARGIN 5.0f
#define INPUTBAR_RECORD_VOICE_HEIGHT   34.5f

CGFloat const kFontSize = 17.0f;

@interface KFInputView ()

@property (nonatomic, assign) CGFloat   inputTextViewPreviousTextHeight;

@end


@implementation KFInputView

@synthesize shouldShowInputBarSwitchMenu,

            inputToolbar,
            showMenuButton,
            verticalLineView,
            switchVoiceButton,
            recordVoiceButton,
            inputTextView,
            switchEmotionButton,
            switchPlusButton,

            inputTextViewMaxHeight,
            inputTextViewMaxLinesCount,
            inputTextViewPreviousTextHeight,

            delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code

        [self setUpViews];
//        self.backgroundColor = [UIColor yellowColor];
        
    }
    return self;
}

- (BOOL)becomeFirstResponder
{
    return [[self inputTextView] becomeFirstResponder];
}

- (BOOL)canBecomeFirstResponder
{
    return [[self inputTextView] canBecomeFirstResponder];
}

- (BOOL)isFirstResponder
{
    return [[self inputTextView] isFirstResponder];
}

- (BOOL)resignFirstResponder
{
    return [[self inputTextView] resignFirstResponder];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)setShouldShowInputBarSwitchMenu:(BOOL)_shouldShowInputBarSwitchMenu
{
    shouldShowInputBarSwitchMenu = _shouldShowInputBarSwitchMenu;
    
    [self setUpViews];
}

#pragma mark Widgets Initialization
-(void)setUpViews
{
    self.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth;
    
    if (inputToolbar != nil) {
        [inputToolbar removeFromSuperview];
        inputToolbar = nil;
    }
    
    if (showMenuButton != nil) {
        [showMenuButton removeFromSuperview];
        showMenuButton = nil;
    }
    
    if (verticalLineView != nil) {
        [verticalLineView removeFromSuperview];
        verticalLineView = nil;
    }
    
    if (switchVoiceButton != nil) {
        [switchVoiceButton removeFromSuperview];
        switchVoiceButton = nil;
    }
    
    if (inputTextView != nil) {
        [inputTextView removeFromSuperview];
        inputTextView = nil;
    }
    
    if (recordVoiceButton != nil) {
        [recordVoiceButton removeFromSuperview];
        recordVoiceButton = nil;
    }
    
    if (switchEmotionButton != nil) {
        [switchEmotionButton removeFromSuperview];
        switchEmotionButton = nil;
    }
    
    if (switchPlusButton != nil) {
        [switchPlusButton removeFromSuperview];
        switchPlusButton = nil;
    }
    
    [self addSubview:[self inputToolbar]];
    
    //只有高级用户，才会显示自定义菜单
    if (shouldShowInputBarSwitchMenu) {
        [self addSubview:[self showMenuButton]];
        [self addSubview:[self verticalLineView]];
    }

    [self addSubview:[self switchVoiceButton]];
    [self addSubview:[self inputTextView]];
    [self addSubview:[self recordVoiceButton]];
    [self recordVoiceButton].hidden = TRUE;
    [self addSubview:[self switchEmotionButton]];
    [self addSubview:[self switchPlusButton]];
}


-(UIToolbar *)inputToolbar
{
    if (!inputToolbar) {
        
        CGRect frame = [self bounds];
        frame.origin.y = 0.5f;
        frame.size.height = INPUTBAR_HEIGHT;
        inputToolbar = [[UIToolbar alloc] init];
        inputToolbar.frame = frame;
        [inputToolbar setBarStyle:UIBarStyleDefault];
        [inputToolbar setTranslucent:YES];
        [inputToolbar setTintColor:[UIColor whiteColor]];
        [inputToolbar setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin];
    }
    
    return inputToolbar;
}

-(UIButton *)showMenuButton
{
    if (!showMenuButton) {
        
        showMenuButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 0, INPUTBAR_SHOWMENU_BUTTON_WIDTH, INPUTBAR_HEIGHT)];
        [showMenuButton setImage:[UIImage imageNamed:@"Mode_texttolist_ios7" inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
        [showMenuButton setImage:[UIImage imageNamed:@"Mode_texttolistHL_ios7" inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil] forState:UIControlStateHighlighted];
        
        [showMenuButton addTarget:self action:@selector(showMenuButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return showMenuButton;
}

-(UIView *)verticalLineView
{
    if (!verticalLineView) {
        
        verticalLineView = [[UIView alloc] initWithFrame:CGRectMake(INPUTBAR_SHOWMENU_BUTTON_WIDTH,
                                                                    0,
                                                                    0.5f,
                                                                    INPUTBAR_SHOWMENU_BUTTON_WIDTH)];
        [verticalLineView setBackgroundColor:[UIColor lightGrayColor]];
        
    }
    
    return verticalLineView;
}

-(UIButton *)switchVoiceButton
{
    if (!switchVoiceButton) {
        
        switchVoiceButton = [[UIButton alloc] initWithFrame:CGRectMake(shouldShowInputBarSwitchMenu ? INPUTBAR_SHOWMENU_BUTTON_WIDTH + INPUTBAR_SWITCH_VOICE_LEFT_MARGIN : INPUTBAR_SWITCH_VOICE_LEFT_MARGIN,
                                                                       INPUTBAR_SWITCH_VOICE_TOP_MARGIN,
                                                                       INPUTBAR_SWITCH_VOICE_BUTTON_WIDTH_HEIGHT,
                                                                       INPUTBAR_SWITCH_VOICE_BUTTON_WIDTH_HEIGHT)];
        [switchVoiceButton setImage:[UIImage imageNamed:@"ToolViewInputVoice_ios7" inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
        [switchVoiceButton setImage:[UIImage imageNamed:@"ToolViewInputVoiceHL_ios7" inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil] forState:UIControlStateHighlighted];
        
        [switchVoiceButton addTarget:self action:@selector(switchVoiceButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return switchVoiceButton;
}

-(UITextView *)inputTextView
{
    if (!inputTextView) {
        
        CGRect frame = CGRectMake( (shouldShowInputBarSwitchMenu ? INPUTBAR_SHOWMENU_BUTTON_WIDTH + INPUTBAR_SWITCH_VOICE_LEFT_MARGIN : INPUTBAR_SWITCH_VOICE_LEFT_MARGIN)
                                  + INPUTBAR_SWITCH_VOICE_BUTTON_WIDTH_HEIGHT + INPUTBAR_INPUT_TEXTVIEW_LEFT_MARGIN,
                                  INPUTBAR_INPUT_TEXTVIEW_TOP_MARGIN,
                                  self.bounds.size.width - (shouldShowInputBarSwitchMenu ? INPUTBAR_SHOWMENU_BUTTON_WIDTH + INPUTBAR_SWITCH_VOICE_LEFT_MARGIN : 0) - INPUTBAR_SWITCH_VOICE_BUTTON_WIDTH_HEIGHT - INPUTBAR_INPUT_TEXTVIEW_LEFT_MARGIN - INPUTBAR_SWITCH_EMOTION_PLUS_BUTTON_WIDTH_HEIGHT*2 - INPUTBAR_SWITCH_EMOTION_LEFT_MARGIN - INPUTBAR_SWITCH_EMOTION_RIGHT_MARGIN - INPUTBAR_SWITCH_PLUS_RIGHT_MARGIN * 2,
                                  INPUTBAR_INPUT_TEXTVIEW_HEIGHT);
        
        inputTextView = [[UITextView alloc] initWithFrame:frame];
        inputTextView.scrollIndicatorInsets = UIEdgeInsetsMake(10.0f, 0.0f, 10.0f, 8.0f);
        inputTextView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
        inputTextView.scrollEnabled = YES;
        inputTextView.scrollsToTop = NO;
        inputTextView.userInteractionEnabled = YES;
        inputTextView.textColor = [UIColor blackColor];
        inputTextView.keyboardAppearance = UIKeyboardAppearanceDefault;
        inputTextView.keyboardType = UIKeyboardTypeDefault;
        inputTextView.returnKeyType = UIReturnKeySend;
        inputTextView.font = [UIFont systemFontOfSize:kFontSize];
        
        inputTextView.layer.cornerRadius = 5.0f;
        inputTextView.layer.borderWidth = 0.7f;
        inputTextView.layer.borderColor =  [UIColor colorWithRed:200.0f/255.0f
                                                           green:200.0f/255.0f
                                                            blue:205.0f/255.0f
                                                           alpha:1.0f].CGColor;
        inputTextView.delegate = self;
        
        [inputTextView setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
    }
    
    return inputTextView;
}

-(UIButton *)recordVoiceButton
{
    if (!recordVoiceButton) {
        
        CGRect frame = [self inputTextView].frame;
        frame.origin.x -= 5.0f;
        frame.origin.y -= 1.0f;
        frame.size.width += 10.0f;
        frame.size.height += 2.0f;
        
        recordVoiceButton = [[UIButton alloc] initWithFrame:frame];
        
        [recordVoiceButton setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
        
        [recordVoiceButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [recordVoiceButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
        [[recordVoiceButton titleLabel] setFont:[UIFont systemFontOfSize:14.0f]];
        [recordVoiceButton setTitle:@"按住 说话" forState:UIControlStateNormal];
        [recordVoiceButton setTitle:@"松开 取消" forState:UIControlStateHighlighted];
        
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

-(UIButton *)switchEmotionButton
{
    if (!switchEmotionButton) {
        
        switchEmotionButton = [[UIButton alloc] initWithFrame:
                               CGRectMake(self.bounds.size.width - INPUTBAR_SWITCH_PLUS_RIGHT_MARGIN - INPUTBAR_SWITCH_EMOTION_PLUS_BUTTON_WIDTH_HEIGHT * 2 - INPUTBAR_SWITCH_EMOTION_RIGHT_MARGIN * 2,
                                          INPUTBAR_SWITCH_EMOTION_PLUS_TOP_MARGIN,
                                          INPUTBAR_SWITCH_EMOTION_PLUS_BUTTON_WIDTH_HEIGHT,
                                          INPUTBAR_SWITCH_EMOTION_PLUS_BUTTON_WIDTH_HEIGHT)];
        [switchEmotionButton setImage:[UIImage imageNamed:@"ToolViewEmotion_ios7" inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
        [switchEmotionButton setImage:[UIImage imageNamed:@"ToolViewEmotionHL_ios7" inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil] forState:UIControlStateHighlighted];
        
        [switchEmotionButton setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin];
        
        [switchEmotionButton addTarget:self action:@selector(switchEmotionButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    return switchEmotionButton;
}

-(UIButton *)switchPlusButton
{
    if (!switchPlusButton) {
        
        switchPlusButton = [[UIButton alloc] initWithFrame:
                            CGRectMake(self.bounds.size.width - INPUTBAR_SWITCH_EMOTION_PLUS_BUTTON_WIDTH_HEIGHT - INPUTBAR_SWITCH_PLUS_RIGHT_MARGIN * 2,
                                                                      INPUTBAR_SWITCH_EMOTION_PLUS_TOP_MARGIN,
                                                                      INPUTBAR_SWITCH_EMOTION_PLUS_BUTTON_WIDTH_HEIGHT,
                                                                      INPUTBAR_SWITCH_EMOTION_PLUS_BUTTON_WIDTH_HEIGHT)];
        [switchPlusButton setImage:[UIImage imageNamed:@"TypeSelectorBtn_Black_ios7" inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
        [switchPlusButton setImage:[UIImage imageNamed:@"TypeSelectorBtnHL_Black_ios7" inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil] forState:UIControlStateHighlighted];
        
        [switchPlusButton setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleTopMargin];
        
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

#pragma mark UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
	if(![textView hasText] && [text isEqualToString:@""])
    {
        return NO;
	}
    
	if ([text isEqualToString:@"\n"])
    {
        NSString *content = [textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        if ([content length] == 0) {
            return NO;
        }
        
        
        if ([delegate respondsToSelector:@selector(sendMessage:)]) {
            
            [delegate performSelector:@selector(sendMessage:) withObject:content];
            
        }

        return NO;
	}
	return YES;
}

-(void)textViewDidChange:(UITextView *)textView
{
    
    CGFloat previewHeight = [self inputTextViewPreviousTextHeight];
    
    CGFloat textViewHeight = [self inputTextViewHeight];
    
    if (textViewHeight > 150) {
        return;
    }
    
    CGFloat deltaHeight = textViewHeight - previewHeight;
    
    inputTextViewPreviousTextHeight = textViewHeight;
    
    [UIView animateWithDuration:0.20
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         
                         CGRect barFrame = [[self inputToolbar] frame];
                         
                         barFrame.size.height += deltaHeight;
                         if (barFrame.size.height < INPUTBAR_HEIGHT)
                         {
                             barFrame.size.height = INPUTBAR_HEIGHT;
                             
                             barFrame.origin.y = [self switchVoiceButton].frame.origin.y - INPUTBAR_SWITCH_VOICE_TOP_MARGIN;
                         }
                         else if (barFrame.size.height > INPUTBAR_MAX_HEIGHT)
                         {
                             barFrame.size.height = INPUTBAR_MAX_HEIGHT;
                             
                             barFrame.origin.y = [self switchVoiceButton].frame.origin.y - 161.0f;
                         }
                         else if (previewHeight == textViewHeight
                                  && textViewHeight > INPUTBAR_MAX_HEIGHT
                                  && deltaHeight == 0.0)
                         {
                             barFrame.size.height = INPUTBAR_MAX_HEIGHT;
                             
                             barFrame.origin.y = [self switchVoiceButton].frame.origin.y - 161.0f;
                         }
                         else
                         {
                             barFrame.origin.y -= deltaHeight;
                         }
                         [[self inputToolbar] setFrame:barFrame];
                         
                         ///////////////////////////////////////////////////////////////////////
                         
                         CGRect textViewFrame = [[self inputTextView] frame];
                         textViewFrame.size.height += deltaHeight;
                         
                         if (textViewFrame.size.height < INPUTBAR_INPUT_TEXTVIEW_HEIGHT)
                         {
                             textViewFrame.size.height = INPUTBAR_INPUT_TEXTVIEW_HEIGHT;
                             
                             textViewFrame.origin.y = [self recordVoiceButton].frame.origin.y + 1;
                             
                         }
                         else if(textViewFrame.size.height > INPUTBAR_INPUT_TEXTVIEW_MAX_HEIGHT)
                         {
                             textViewFrame.size.height = INPUTBAR_INPUT_TEXTVIEW_MAX_HEIGHT;
                             
                             textViewFrame.origin.y = [self recordVoiceButton].frame.origin.y - 155.0f;
                         }
                         else if (previewHeight == textViewHeight
                                  && textViewHeight > INPUTBAR_MAX_HEIGHT
                                  && deltaHeight == 0.0)
                         {
                             textViewFrame.size.height = INPUTBAR_INPUT_TEXTVIEW_MAX_HEIGHT;
                             
                             textViewFrame.origin.y = [self recordVoiceButton].frame.origin.y - 155.0f;
                         }
                         else
                         {
                             textViewFrame.origin.y -= deltaHeight;
                         }
                         [[self inputTextView] setFrame:textViewFrame];
                         
                         
                         
                         
                         ///////////////////////////////////////////////////////////////////////
                         
                         CGRect verticalLineFrame = [[self verticalLineView] frame];
                         verticalLineFrame.size.height += deltaHeight;
                         if (verticalLineFrame.size.height < INPUTBAR_SHOWMENU_BUTTON_WIDTH) {
                             verticalLineFrame.size.height = INPUTBAR_SHOWMENU_BUTTON_WIDTH;
                         }
                         else if (verticalLineFrame.size.height > INPUTBAR_MAX_HEIGHT)
                         {
                             verticalLineFrame.size.height = INPUTBAR_MAX_HEIGHT;
                         }
                         else
                         {
                             verticalLineFrame.origin.y -=  deltaHeight;
                         }
                         [[self verticalLineView] setFrame:verticalLineFrame];
        
    } completion:^(BOOL finished) {
        
    }];
}


-(CGFloat)inputTextViewPreviousTextHeight
{
    if (!inputTextViewPreviousTextHeight) {
        
        inputTextViewPreviousTextHeight = [self inputTextViewHeight];
    }
    
    return inputTextViewPreviousTextHeight;
}

-(CGFloat) inputTextViewHeight {
    
    CGFloat height = [inputTextView sizeThatFits:CGSizeMake([inputTextView frame].size.width, FLT_MAX)].height;
    
    return ceilf(height);
}

#pragma mark UIButton Selectors

-(void)showMenuButtonPressed:(id)sender
{
    if ([delegate respondsToSelector:@selector(showMenuButtonPressed:)]) {
        
        [delegate performSelector:@selector(showMenuButtonPressed:) withObject:nil];
    }
}

-(void)switchVoiceButtonPressed:(id)sender
{

    if ([delegate respondsToSelector:@selector(switchVoiceButtonPressed:)]) {
        [delegate performSelector:@selector(switchVoiceButtonPressed:) withObject:nil];
    }
    
    if ([[self inputTextView] isFirstResponder]) {
        
        [[self switchVoiceButton] setImage:[UIImage imageNamed:@"ToolViewInputVoice_ios7" inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
        [[self switchVoiceButton] setImage:[UIImage imageNamed:@"ToolViewInputVoiceHL_ios7" inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil] forState:UIControlStateHighlighted];
    }
    else
    {
        [[self switchVoiceButton] setImage:[UIImage imageNamed:@"ToolViewInputText_ios7" inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
        [[self switchVoiceButton] setImage:[UIImage imageNamed:@"ToolViewInputTextHL_ios7" inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil] forState:UIControlStateHighlighted];
        
        ////
        [[self switchEmotionButton] setImage:[UIImage imageNamed:@"ToolViewEmotion_ios7" inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
        [[self switchEmotionButton] setImage:[UIImage imageNamed:@"ToolViewEmotionHL_ios7" inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil] forState:UIControlStateHighlighted];
    }
    
}

-(void)switchEmotionButtonPressed:(id)sender
{
    //执行Delegate
    if ([delegate respondsToSelector:@selector(switchEmotionButtonPressed:)]) {
        
        [delegate performSelector:@selector(switchEmotionButtonPressed:) withObject:nil];
        
    }
    
    if ([[self inputTextView] isFirstResponder]) {
        
        [[self switchEmotionButton] setImage:[UIImage imageNamed:@"ToolViewEmotion_ios7" inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
        [[self switchEmotionButton] setImage:[UIImage imageNamed:@"ToolViewEmotionHL_ios7" inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil] forState:UIControlStateHighlighted];
        
    }
    else
    {
        [[self switchEmotionButton] setImage:[UIImage imageNamed:@"ToolViewInputText_ios7" inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
        [[self switchEmotionButton] setImage:[UIImage imageNamed:@"ToolViewInputTextHL_ios7" inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil] forState:UIControlStateHighlighted];
        
    }
    
}

-(void)switchPlusButtonPressed:(id)sender
{
    if ([delegate respondsToSelector:@selector(switchPlusButtonPressed:)]) {
        
        [delegate performSelector:@selector(switchPlusButtonPressed:) withObject:nil];
        
    }
}


//
-(void)recordVoiceButtonTouchDown:(id)sender
{
    if ([delegate respondsToSelector:@selector(recordVoiceButtonTouchDown:)]) {
        
        [delegate performSelector:@selector(recordVoiceButtonTouchDown:) withObject:nil];
        
    }
}


-(void)recordVoiceButtonTouchUpInside:(id)sender
{
    if ([delegate respondsToSelector:@selector(recordVoiceButtonTouchUpInside:)]) {
        
        [delegate performSelector:@selector(recordVoiceButtonTouchUpInside:) withObject:nil];
        
    }
}


-(void)recordVoiceButtonTouchUpOutside:(id)sender
{
    if ([delegate respondsToSelector:@selector(recordVoiceButtonTouchUpOutside:)]) {
        
        [delegate performSelector:@selector(recordVoiceButtonTouchUpOutside:) withObject:nil];
        
    }
    
}


-(void)recordVoiceButtonTouchDragInside:(id)sender
{
    if ([delegate respondsToSelector:@selector(recordVoiceButtonTouchDragInside:)]) {
        
        [delegate performSelector:@selector(recordVoiceButtonTouchDragInside:) withObject:nil];
        
    }
}

-(void)recordVoiceButtonTouchDragOutside:(id)sender
{
    if ([delegate respondsToSelector:@selector(recordVoiceButtonTouchUpOutside:)]) {
        
        [delegate performSelector:@selector(recordVoiceButtonTouchDragOutside:) withObject:nil];
        
    }
    
}


@end








