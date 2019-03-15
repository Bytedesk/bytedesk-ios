//
//  KFRateView.m
//  AppKeFuLib
//
//  Created by jack on 15/9/9.
//  Copyright (c) 2015年 appkefu.com. All rights reserved.
//

#import "KFRateView.h"
#import "KFStarView.h"

@interface KFRateView ()<UITextViewDelegate>

@property (nonatomic, strong) UILabel      *titleLabel;
@property (nonatomic, strong) KFStarView   *starView;
@property (nonatomic, strong) UITextView   *commentView;
@property (nonatomic, strong) UIButton     *submitButton;
@property (nonatomic, strong) UIButton     *rejectButton;
@property (nonatomic, strong) UIButton     *cancelButton;

@property (nonatomic, strong) UIView       *parentView;//parant view
@property (nonatomic, strong) UIView       *maskView;
@property (nonatomic, strong) UIView       *mainAlertView; //main alert view

@end



@implementation KFRateView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(instancetype)initWithParentView:(UIView *)parentView
{
    self = [self initWithFrame:parentView.bounds];
    if (self) {
        self.parentView = parentView;
        
        [self layout];
    }
    return self;
}


#pragma mark Layout

- (void)layout
{
    [self addView];
    [self.parentView addSubview:self];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.mainAlertView setBackgroundColor:[UIColor whiteColor]];
    [[self.mainAlertView layer] setCornerRadius:5.0f];
    
}

- (void)addView
{
    [self addSubview:self.maskView];
    [self addSubview:self.mainAlertView];
    
    [self.mainAlertView addSubview:self.titleLabel];
    [self.mainAlertView addSubview:self.starView];
    [self.mainAlertView addSubview:self.commentView];
    [self.mainAlertView addSubview:self.submitButton];
    [self.mainAlertView addSubview:self.cancelButton];
}

- (UIView *)maskView
{
    if (!_maskView) {
        _maskView = [[UIView alloc] initWithFrame:self.bounds];
        [_maskView setBackgroundColor:[UIColor blackColor]];
        [_maskView setAlpha:0.2];
        
        UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapped:)];
        [_maskView addGestureRecognizer:singleTapGestureRecognizer];
    }
    return _maskView;
}

//4s: 320*480
//5:  320x568
//6:  375x667
//6p: 414x736
//[UIScreen mainScreen].bounds
- (UIView *)mainAlertView
{
    if (!_mainAlertView) {
        _mainAlertView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [self mainScreenWith]*0.7, [self mainScreenHeight]*0.45)];
        [_mainAlertView setCenter:self.center];
    }
    return _mainAlertView;
}

-(UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake([self mainScreenWith]*0.08, [self mainScreenHeight]*0.03, [self mainScreenWith]*0.53, [self mainScreenHeight]*0.075)];
        [_titleLabel setText:AppKeFuLocalizedString(@"RateTitle", nil)];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

-(UIView *)starView
{
    if (!_starView) {
        _starView = [[KFStarView alloc] initWithFrame:CGRectMake(0, [self mainScreenHeight]*0.09, [self mainScreenWith]*0.7, [self mainScreenHeight]*0.075)];
        _starView.starNumber = 5;
    }
    return _starView;
}

-(UITextView *)commentView
{
    if (!_commentView) {
        _commentView = [[UITextView alloc] initWithFrame:CGRectMake([self mainScreenWith]*0.115, [self mainScreenHeight]*0.18, [self mainScreenWith]*0.53, [self mainScreenHeight]*0.15)];
        [_commentView setText:AppKeFuLocalizedString(@"tip", nil)];
        _commentView.layer.backgroundColor = [[UIColor clearColor] CGColor];
        _commentView.layer.borderColor = [[UIColor colorWithRed:230.0/255.0 green:250.0/255.0 blue:250.0/255.0 alpha:1.0]CGColor];
        _commentView.layer.borderWidth = 1.0;
        _commentView.layer.cornerRadius = 5.0f;
        [_commentView.layer setMasksToBounds:YES];
        _commentView.delegate = self;
    }
    return _commentView;
}

-(UIButton *)submitButton
{
    if (!_submitButton) {
        _submitButton = [[UIButton alloc] initWithFrame:CGRectMake([self mainScreenWith]*0.12, [self mainScreenHeight]*0.36, [self mainScreenWith]*0.21, [self mainScreenHeight]*0.06)];
        [_submitButton setTitle:AppKeFuLocalizedString(@"Submit", nil) forState:UIControlStateNormal];
        [_submitButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
        [_submitButton addTarget:self action:@selector(submitButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [[_submitButton layer] setBorderColor:[UIColor greenColor].CGColor];
        [[_submitButton layer] setCornerRadius:4.0];
        [[_submitButton layer] setBorderWidth:1.0];
    }
    return _submitButton;
}

-(UIButton *)rejectButton
{
    if (!_rejectButton) {
        //_rejectButton = [[UIButton alloc] initWithFrame:CGRectMake(<#CGFloat x#>, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>)]
        
    }
    return _rejectButton;
}

-(UIButton *)cancelButton
{
    if (!_cancelButton) {
        _cancelButton = [[UIButton alloc] initWithFrame:CGRectMake([self mainScreenWith]*0.36, [self mainScreenHeight]*0.36, [self mainScreenWith]*0.21, [self mainScreenHeight]*0.06)];
        [_cancelButton setTitle:AppKeFuLocalizedString(@"Cancel", nil) forState:UIControlStateNormal];
        [_cancelButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(cancelButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [[_cancelButton layer] setBorderColor:[UIColor grayColor].CGColor];
        [[_cancelButton layer] setCornerRadius:4.0];
        [[_cancelButton layer] setBorderWidth:1.0];
    }
    return _cancelButton;
}


- (void)show
{
    [UIView animateWithDuration:0.2 animations:^{
        [self setAlpha:1];
    } completion:^(BOOL finished) {
        [self addObservers];
        [self.mainAlertView endEditing:YES];
    }];
}

- (void)hide
{
    [UIView animateWithDuration:0.3 animations:^{
        [self setAlpha:0];
    } completion:^(BOOL finished) {
        [self.mainAlertView endEditing:YES];
        [self removeObservers];
    }];
}


#pragma mark button clicked
-(void)submitButtonClicked:(UIButton *)btn
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(submitRateWithRate:withComment:)]) {
        NSString *rate = [NSString stringWithFormat:@"%ld", (long)_starView.starNumber];
        NSString *comment = [_commentView text];
        [self.delegate submitRateWithRate:rate withComment:comment];
    }
    
    [self hide];
}

-(void)cancelButtonClicked:(UIButton *)btn
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(cancelRate)]) {
        [self.delegate cancelRate];
    }
    
    [self hide];
}


#pragma mark Keyboard

- (void)addObservers
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)removeObservers
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}


- (void)keyboardWillShow:(NSNotification *)notification
{
    CGRect keyboardRect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    int keyboardY = [self convertRect:keyboardRect fromView:nil].origin.y;//键盘位置的y坐标
    
    [UIView animateWithDuration:duration
                     animations:^{
        CGRect f = self.mainAlertView.frame;
        f.origin.y = keyboardY - f.size.height;
        self.mainAlertView.frame = f;
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    [UIView animateWithDuration:0.2f
                     animations:^{
        CGRect f = self.mainAlertView.frame;
        f.origin.y = 0;
        self.mainAlertView.frame = f;
    }];
}

#pragma mark single tap
-(void)handleSingleTapped:(id)sender
{
    [self.mainAlertView endEditing:YES];
    
}

#pragma mark UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:AppKeFuLocalizedString(@"tip", nil)]) {
        textView.text = @"";
    }
};

- (void)textViewDidEndEditing:(UITextView *)textView{
    if (textView.text.length < 1 ) {
        textView.text = AppKeFuLocalizedString(@"tip", nil);
    }
};

#pragma mark
-(int)mainScreenWith
{
    return [UIScreen mainScreen].bounds.size.width;
}

-(int)mainScreenHeight
{
    return [UIScreen mainScreen].bounds.size.height;
}


@end















































