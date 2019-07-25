//
//  KFDSInputView.m
//  ChatUI
//
//  Created by jack on 16/9/2.
//  Copyright © 2016年 chatsdk.org. All rights reserved.
//

#import "KFDSInputView.h"
#import "KFDSTextView.h"

//define this constant if you want to enable auto-boxing for default syntax
#define MAS_SHORTHAND_GLOBALS
#import <Masonry/Masonry.h>

@interface KFDSInputView ()<KFDSInputBarDelegate, KFDSEmotionViewDelegate, KFDSPlusViewDelegate>

@end

@implementation KFDSInputView

@synthesize inputToolbar, emotionView, plusView, menuView, delegate;

-(id) init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor greenColor];
        //Masonry will also call view1.translatesAutoresizingMaskIntoConstraints = NO; for you.
        //https://github.com/SnapKit/Masonry
        //        self.translatesAutoresizingMaskIntoConstraints = NO;
        
        [self addSubview:[self inputToolbar]];
        //
        [self initViewConstraints];
        
//        [self delayInit];
        [self performSelector:@selector(delayInit) withObject:nil afterDelay:1.0f];
    }
    return self;
}

-(void)delayInit {
    
    [self addSubview:[self emotionView]];
    [self addSubview:[self plusView]];
    
    __weak typeof(self) weakSelf = self;
    [emotionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(weakSelf);
        make.top.equalTo(inputToolbar.mas_bottom);
        make.height.equalTo(@(KFDS_EXTVIEW_HEIGHT));
    }];
    //
    [plusView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(weakSelf);
        make.top.equalTo(inputToolbar.mas_bottom);
        make.height.equalTo(@(KFDS_EXTVIEW_HEIGHT));
    }];
    
}

-(KFDSInputBar *)inputToolbar {
    if (!inputToolbar) {
        inputToolbar = [[KFDSInputBar alloc] initWithShowMenu:FALSE];
        [inputToolbar setBarStyle:UIBarStyleDefault];
        [inputToolbar setTranslucent:YES];
        [inputToolbar setTintColor:[UIColor whiteColor]];
        inputToolbar.mydelegate = self;
    }
    return inputToolbar;
}


-(KFDSEmotionView *)emotionView {
    if (!emotionView) {
        emotionView = [KFDSEmotionView new];
        emotionView.delegate = self;
        emotionView.hidden = TRUE;
    }
    return emotionView;
}


-(KFDSPlusView *)plusView {
    if (!plusView) {
        plusView = [KFDSPlusView new];
        plusView.delegate = self;
        plusView.hidden = TRUE;
    }
    return plusView;
}


-(KFDSMenuView *)menuView {
    if (!menuView) {
        menuView = [KFDSMenuView new];
    }
    return menuView;
}


-(void)initViewConstraints {
    
    __weak typeof(self) weakSelf = self;
    [inputToolbar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.and.top.equalTo(weakSelf);
        make.height.equalTo(@(KFDS_INPUTBAR_HEIGHT));
    }];
}


#pragma mark - KFDSInputBarDelegate

-(void)textViewHeightChanged:(NSString *)text height:(CGFloat)textHeight {
    NSLog(@"%s, %@, %f", __PRETTY_FUNCTION__, text, textHeight);
    
    [inputToolbar mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(textHeight));
    }];
    
    if ([delegate respondsToSelector:@selector(textViewHeightChanged:height:)]) {
        [delegate textViewHeightChanged:text height:textHeight];
    }
}

-(void)showMenuButtonPressed:(id)sender {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
}


-(void)switchVoiceButtonPressed:(id)sender {
//    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    if ([delegate respondsToSelector:@selector(switchVoiceButtonPressed:)]) {
        [delegate performSelector:@selector(switchVoiceButtonPressed:) withObject:nil];
    }
    
    if ([inputToolbar recordVoiceButton].hidden) {
        [emotionView setHidden:TRUE];
        [plusView setHidden:TRUE];
    }
}

-(void)switchEmotionButtonPressed:(id)sender {
//    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    if ([delegate respondsToSelector:@selector(switchEmotionButtonPressed:)]) {
        [delegate performSelector:@selector(switchEmotionButtonPressed:) withObject:nil];
    }
}

-(void)switchPlusButtonPressed:(id)sender {
//    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    if ([delegate respondsToSelector:@selector(switchPlusButtonPressed:)]) {
        [delegate performSelector:@selector(switchPlusButtonPressed:) withObject:nil];
    }
    
}

-(void)sendMessage:(NSString *)content {
//    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    if ([delegate respondsToSelector:@selector(sendMessage:)]) {
        [delegate performSelector:@selector(sendMessage:) withObject:content];
    }
}

//
-(void)recordVoiceButtonTouchDown:(id)sender {
//    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    if ([delegate respondsToSelector:@selector(recordVoiceButtonTouchDown:)]) {
        [delegate performSelector:@selector(recordVoiceButtonTouchDown:) withObject:nil];
    }
}


-(void)recordVoiceButtonTouchUpInside:(id)sender {
//    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    if ([delegate respondsToSelector:@selector(recordVoiceButtonTouchUpInside:)]) {
        [delegate performSelector:@selector(recordVoiceButtonTouchUpInside:) withObject:nil];
    }
}


-(void)recordVoiceButtonTouchUpOutside:(id)sender {
    
    if ([delegate respondsToSelector:@selector(recordVoiceButtonTouchUpOutside:)]) {
        [delegate performSelector:@selector(recordVoiceButtonTouchUpOutside:) withObject:nil];
    }
    
}


-(void)recordVoiceButtonTouchDragInside:(id)sender {
    
    if ([delegate respondsToSelector:@selector(recordVoiceButtonTouchDragInside:)]) {
        [delegate performSelector:@selector(recordVoiceButtonTouchDragInside:) withObject:nil];
    }
}

-(void)recordVoiceButtonTouchDragOutside:(id)sender {
    
    if ([delegate respondsToSelector:@selector(recordVoiceButtonTouchUpOutside:)]) {
        [delegate performSelector:@selector(recordVoiceButtonTouchDragOutside:) withObject:nil];
    }
}


#pragma mark - KFDSEmotionViewDelegate

-(void)emotionFaceContent:(NSString *)emotionText {
    NSLog(@"%s, face:%@", __PRETTY_FUNCTION__, emotionText);
    
    NSString *content = [inputToolbar.inputTextView text];
    [inputToolbar.inputTextView setText:[NSString stringWithFormat:@"%@%@", content, emotionText]];
}

-(void)emotionFaceDelete {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    NSString *content = [inputToolbar.inputTextView text];
    NSInteger contentLength = [content length];
    NSString *newContent;
    
    if (contentLength > 0) {
        
        if ([@"]" isEqualToString:[content substringFromIndex:contentLength - 1]]) {
            if ([content rangeOfString:@"["].location == NSNotFound) {
                newContent = [content substringToIndex:contentLength - 1];
            }
            else {
                newContent = [content substringToIndex:[content rangeOfString:@"[" options:NSBackwardsSearch].location];
            }
        }
        else {
            newContent = [content substringToIndex:contentLength-1];
        }
        
        inputToolbar.inputTextView.text = newContent;
    }
    
    [inputToolbar textViewDidChange:inputToolbar.inputTextView];
}

-(void)emotionFaceSend {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    NSString *content = [inputToolbar.inputTextView text];
    [self sendMessage:content];
    //
    [inputToolbar.inputTextView setText:@""];
    [inputToolbar textViewDidChange:inputToolbar.inputTextView];
}


#pragma mark - KFDSPlusViewDelegate

-(void)sharePickPhotoButtonPressed:(id)sender {
//        NSLog(@"%s", __PRETTY_FUNCTION__);
    
    if ([delegate respondsToSelector:@selector(sharePickPhotoButtonPressed:)]) {
        [delegate performSelector:@selector(sharePickPhotoButtonPressed:) withObject:nil];
    }
}

-(void)shareTakePhotoButtonPressed:(id)sender {
//        NSLog(@"%s", __PRETTY_FUNCTION__);
    
    if ([delegate respondsToSelector:@selector(shareTakePhotoButtonPressed:)]) {
        [delegate performSelector:@selector(shareTakePhotoButtonPressed:) withObject:nil];
    }
    
}


-(void)shareRateButtonPressed:(id)sender {
//        NSLog(@"%s", __PRETTY_FUNCTION__);
    
    if ([delegate respondsToSelector:@selector(shareRateButtonPressed:)]) {
        [delegate performSelector:@selector(shareRateButtonPressed:) withObject:nil];
    }
}

#pragma mark

- (void) hideRate {
    
    if (plusView) {
        [plusView hideRate];
    }
}

- (void) showRate {
    
    if (plusView) {
        [plusView showRate];
    }
}



@end






























