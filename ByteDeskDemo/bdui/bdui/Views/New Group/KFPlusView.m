//
//  KFPlusView.m
//  ChatViewController
//
//  Created by jack on 14-5-4.
//  Copyright (c) 2014年 appkefu.com. All rights reserved.
//

#import "KFPlusView.h"

//#define SHAREMORE_ITEMS_LEFT_MARGIN     22.0f
#define SHAREMORE_ITEMS_TOP_MARGIN      15.0f

#define SHAREMORE_ITEMS_WIDTH            53.0f
#define SHAREMORE_ITEMS_HEIGHT           55.0f

#define SHAREMORE_ITEM_LABEL_TOP_MARGIN  2.0f
#define SHAREMORE_ITEM_LABEL_WIDTH       50.0f
#define SHAREMORE_ITEM_LABEL_HEIGHT      30.0f

#define SHAREMORE_ITEM_LABEL_FONTSIZE    13.0f


@interface KFPlusView ()

@property (nonatomic, strong) UIView    *topLineView;

@property (nonatomic, strong) UIButton  *sharePickPhotoButton;
@property (nonatomic, strong) UILabel   *sharePickPhotoLabel;

@property (nonatomic, strong) UIButton  *shareTakePhotoButton;
@property (nonatomic, strong) UILabel   *shareTakePhotoLabel;

@property (nonatomic, strong) UIButton  *shareShowFAQButton;
@property (nonatomic, strong) UILabel   *shareShowFAQLabel;

@property (nonatomic, strong) UIButton  *shareRateButton;
@property (nonatomic, strong) UILabel   *shareRateLabel;

@property(nonatomic, strong) UIButton *shareFilebButton;
@property(nonatomic, strong) UILabel *shareFileLabel;

@property(nonatomic, strong) UIButton *shareDestroyAfterReadingButton;
@property(nonatomic, strong) UILabel *shareDestroyAfterReadingLabel;

@property (nonatomic, assign) NSInteger m_buttonMargin;

@end

@implementation KFPlusView

@synthesize delegate,
            topLineView,
            sharePickPhotoButton,
            sharePickPhotoLabel,

            shareTakePhotoButton,
            shareTakePhotoLabel,

            shareShowFAQButton,
            shareShowFAQLabel,

            shareRateButton,
            shareRateLabel,

            shareFilebButton,
            shareFileLabel,

            shareDestroyAfterReadingButton,
            shareDestroyAfterReadingLabel,

            m_buttonMargin;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        m_buttonMargin = ([UIScreen mainScreen].bounds.size.width - SHAREMORE_ITEMS_WIDTH*4)/5;
        
        
        self.backgroundColor = UIColorFromRGB(0XEBEBEB);
        self.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth;

        [self setUpSubViews];
    }
    return self;
}

-(void)dealloc
{
    topLineView = nil;
    sharePickPhotoButton = nil;
    sharePickPhotoLabel = nil;
    shareTakePhotoButton = nil;
    shareTakePhotoLabel = nil;
    shareShowFAQButton = nil;
    shareShowFAQLabel = nil;
    shareRateButton = nil;
    shareRateLabel = nil;
    shareFilebButton = nil;
    shareFileLabel = nil;
    shareDestroyAfterReadingButton = nil;
    shareDestroyAfterReadingLabel = nil;

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)setUpSubViews
{
    [self addSubview:[self topLineView]];
    [self addSubview:[self sharePickPhotoButton]];
    [self addSubview:[self sharePickPhotoLabel]];
    [self addSubview:[self shareTakePhotoButton]];
    [self addSubview:[self shareTakePhotoLabel]];
    [self addSubview:[self shareRateButton]];
    [self addSubview:[self shareRateLabel]];
    [self addSubview:[self shareShowFAQButton]];
    [self addSubview:[self shareShowFAQLabel]];

    [self addSubview:[self shareFilebButton]];
    [self addSubview:[self shareFileLabel]];
    
//    [self addSubview:[self shareDestroyAfterReadingButton]];
//    [self addSubview:[self shareDestroyAfterReadingLabel]];
    
}

#pragma mark Init SubViews
-(UIView *)topLineView
{
    if (!topLineView) {
        
        topLineView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.bounds.size.width, 0.5f)];
        topLineView.backgroundColor = UIColorFromRGB(0X939698);
        topLineView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
    }
    
    return topLineView;
}

-(UIButton *)sharePickPhotoButton
{
    if (!sharePickPhotoButton) {
        
        CGRect frame = CGRectMake(m_buttonMargin,
                                  SHAREMORE_ITEMS_TOP_MARGIN,
                                  SHAREMORE_ITEMS_WIDTH,
                                  SHAREMORE_ITEMS_HEIGHT);
        
        sharePickPhotoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [sharePickPhotoButton setFrame:frame];
        [sharePickPhotoButton setBackgroundImage:[UIImage imageNamed:@"sharemore_pic_ios7" inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
        //
        sharePickPhotoButton.layer.cornerRadius = 5.0;
        sharePickPhotoButton.layer.masksToBounds = YES;
        sharePickPhotoButton.layer.borderColor = [UIColor colorWithWhite:0.0 alpha:0.2].CGColor;
        sharePickPhotoButton.layer.borderWidth = 0.5;
        
        [sharePickPhotoButton addTarget:self action:@selector(sharePickPhotoButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return sharePickPhotoButton;
}

-(UILabel *)sharePickPhotoLabel
{
    if (!sharePickPhotoLabel) {
        
        CGRect frame = CGRectMake(m_buttonMargin + 12.0f,
                                  SHAREMORE_ITEMS_TOP_MARGIN + SHAREMORE_ITEMS_HEIGHT + SHAREMORE_ITEM_LABEL_TOP_MARGIN,
                                  SHAREMORE_ITEM_LABEL_WIDTH,
                                  SHAREMORE_ITEM_LABEL_HEIGHT);
        
        sharePickPhotoLabel = [[UILabel alloc] initWithFrame:frame];
        [sharePickPhotoLabel setTextColor:[UIColor blackColor]];
        [sharePickPhotoLabel setFont:[UIFont systemFontOfSize:SHAREMORE_ITEM_LABEL_FONTSIZE]];
        [sharePickPhotoLabel setText:@"相册"];
        [sharePickPhotoLabel setBackgroundColor:[UIColor clearColor]];
    }
    
    return sharePickPhotoLabel;
}

-(UIButton *)shareTakePhotoButton
{
    if (!shareTakePhotoButton) {
        
        CGRect frame = CGRectMake(m_buttonMargin*2 + SHAREMORE_ITEMS_WIDTH,
                                  SHAREMORE_ITEMS_TOP_MARGIN,
                                  SHAREMORE_ITEMS_WIDTH,
                                  SHAREMORE_ITEMS_HEIGHT);
        
        shareTakePhotoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [shareTakePhotoButton setFrame:frame];
        [shareTakePhotoButton setBackgroundImage:[UIImage imageNamed:@"sharemore_video_ios7" inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
        
        //
        shareTakePhotoButton.layer.cornerRadius = 5.0;
        shareTakePhotoButton.layer.masksToBounds = YES;
        shareTakePhotoButton.layer.borderColor = [UIColor colorWithWhite:0.0 alpha:0.2].CGColor;
        shareTakePhotoButton.layer.borderWidth = 0.5;
        
        [shareTakePhotoButton addTarget:self action:@selector(shareTakePhotoButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return shareTakePhotoButton;
}

-(UILabel *)shareTakePhotoLabel
{
    if (!shareTakePhotoLabel) {
        
        CGRect frame = CGRectMake(m_buttonMargin*2 + SHAREMORE_ITEMS_WIDTH + 13.0f,
                                  SHAREMORE_ITEMS_TOP_MARGIN + SHAREMORE_ITEMS_HEIGHT + SHAREMORE_ITEM_LABEL_TOP_MARGIN,
                                  SHAREMORE_ITEM_LABEL_WIDTH,
                                  SHAREMORE_ITEM_LABEL_HEIGHT);
        shareTakePhotoLabel = [[UILabel alloc] initWithFrame:frame];
        [shareTakePhotoLabel setTextColor:[UIColor blackColor]];
        [shareTakePhotoLabel setFont:[UIFont systemFontOfSize:SHAREMORE_ITEM_LABEL_FONTSIZE]];
        [shareTakePhotoLabel setText:@"拍照"];
        [shareTakePhotoLabel setBackgroundColor:[UIColor clearColor]];
        
    }
    
    return shareTakePhotoLabel;
}

-(UIButton *)shareRateButton
{
    if (!shareRateButton) {
        
        CGRect frame = CGRectMake(m_buttonMargin*3 + SHAREMORE_ITEMS_WIDTH*2,
                                  SHAREMORE_ITEMS_TOP_MARGIN,
                                  SHAREMORE_ITEMS_WIDTH,
                                  SHAREMORE_ITEMS_HEIGHT);
        
        shareRateButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [shareRateButton setFrame:frame];
        [shareRateButton setBackgroundImage:[UIImage imageNamed:@"sharemore_friendcard_ios7" inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
        
        //
        shareRateButton.layer.cornerRadius = 5.0;
        shareRateButton.layer.masksToBounds = YES;
        shareRateButton.layer.borderColor = [UIColor colorWithWhite:0.0 alpha:0.2].CGColor;
        shareRateButton.layer.borderWidth = 0.5;
        
        [shareRateButton addTarget:self action:@selector(shareRateButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return shareRateButton;
}

-(UILabel *)shareRateLabel
{
    if (!shareRateLabel) {
        
        CGRect frame = CGRectMake(m_buttonMargin*3 + SHAREMORE_ITEMS_WIDTH*2 + 13.0f,
                                  SHAREMORE_ITEMS_TOP_MARGIN + SHAREMORE_ITEMS_HEIGHT + SHAREMORE_ITEM_LABEL_TOP_MARGIN,
                                  SHAREMORE_ITEM_LABEL_WIDTH,
                                  SHAREMORE_ITEM_LABEL_HEIGHT);
        
        shareRateLabel = [[UILabel alloc] initWithFrame:frame];
        [shareRateLabel setTextColor:[UIColor blackColor]];
        [shareRateLabel setFont:[UIFont systemFontOfSize:SHAREMORE_ITEM_LABEL_FONTSIZE]];
        [shareRateLabel setText:@"商品"];
        [shareRateLabel setBackgroundColor:[UIColor clearColor]];
    }
    
    return shareRateLabel;
}

-(UIButton *)shareShowFAQButton
{
    if (!shareShowFAQButton) {
        
        CGRect frame = CGRectMake(m_buttonMargin*4 + SHAREMORE_ITEMS_WIDTH*3,
                                  SHAREMORE_ITEMS_TOP_MARGIN,
                                  SHAREMORE_ITEMS_WIDTH,
                                  SHAREMORE_ITEMS_HEIGHT);
        
        shareShowFAQButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [shareShowFAQButton setFrame:frame];
        [shareShowFAQButton setBackgroundImage:[UIImage imageNamed:@"sharemore_wxtalk_ios7" inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
        
        //
        shareShowFAQButton.layer.cornerRadius = 5.0;
        shareShowFAQButton.layer.masksToBounds = YES;
        shareShowFAQButton.layer.borderColor = [UIColor colorWithWhite:0.0 alpha:0.2].CGColor;
        shareShowFAQButton.layer.borderWidth = 0.5;
        
        [shareShowFAQButton addTarget:self action:@selector(shareShowFAQButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    return shareShowFAQButton;
}

-(UILabel *)shareShowFAQLabel
{
    if (!shareShowFAQLabel) {
        
        CGRect frame = CGRectMake(m_buttonMargin*4 + SHAREMORE_ITEMS_WIDTH*3 + 13.0f,
                                  SHAREMORE_ITEMS_TOP_MARGIN + SHAREMORE_ITEMS_HEIGHT + SHAREMORE_ITEM_LABEL_TOP_MARGIN,
                                  SHAREMORE_ITEM_LABEL_WIDTH,
                                  SHAREMORE_ITEM_LABEL_HEIGHT);
        
        shareShowFAQLabel = [[UILabel alloc] initWithFrame:frame];
        [shareShowFAQLabel setTextColor:[UIColor blackColor]];
        [shareShowFAQLabel setFont:[UIFont systemFontOfSize:SHAREMORE_ITEM_LABEL_FONTSIZE]];
        [shareShowFAQLabel setText:@"红包"];
        [shareShowFAQLabel setBackgroundColor:[UIColor clearColor]];
    }
    
    return shareShowFAQLabel;
}

-(UIButton *)shareFilebButton
{
    if (!shareFilebButton) {
        
        CGRect frame = CGRectMake(m_buttonMargin,
                                  SHAREMORE_ITEMS_TOP_MARGIN*3 + SHAREMORE_ITEMS_WIDTH + SHAREMORE_ITEM_LABEL_TOP_MARGIN*2,
                                  SHAREMORE_ITEMS_WIDTH,
                                  SHAREMORE_ITEMS_HEIGHT);
        
        shareFilebButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [shareFilebButton setFrame:frame];
        [shareFilebButton setBackgroundImage:[UIImage imageNamed:@"sharemore_pic_ios7" inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
        //
        shareFilebButton.layer.cornerRadius = 5.0;
        shareFilebButton.layer.masksToBounds = YES;
        shareFilebButton.layer.borderColor = [UIColor colorWithWhite:0.0 alpha:0.2].CGColor;
        shareFilebButton.layer.borderWidth = 0.5;
        
        [shareFilebButton addTarget:self action:@selector(shareFileButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return shareFilebButton;
}

-(UILabel *)shareFileLabel
{
    if (!shareFileLabel) {
        
        CGRect frame = CGRectMake(m_buttonMargin + 12.0f,
                                  SHAREMORE_ITEMS_TOP_MARGIN*3 + SHAREMORE_ITEMS_HEIGHT*2 + SHAREMORE_ITEM_LABEL_TOP_MARGIN*2,
                                  SHAREMORE_ITEM_LABEL_WIDTH,
                                  SHAREMORE_ITEM_LABEL_HEIGHT);
        
        shareFileLabel = [[UILabel alloc] initWithFrame:frame];
        [shareFileLabel setTextColor:[UIColor blackColor]];
        [shareFileLabel setFont:[UIFont systemFontOfSize:SHAREMORE_ITEM_LABEL_FONTSIZE]];
        [shareFileLabel setText:@"文件"];
        [shareFileLabel setBackgroundColor:[UIColor clearColor]];
    }
    
    return shareFileLabel;
}

-(UIButton *)shareDestroyAfterReadingButton
{
    if (!shareDestroyAfterReadingButton) {
        
        CGRect frame = CGRectMake(m_buttonMargin*2 + SHAREMORE_ITEMS_WIDTH,
                                  SHAREMORE_ITEMS_TOP_MARGIN*3 + SHAREMORE_ITEMS_WIDTH + SHAREMORE_ITEM_LABEL_TOP_MARGIN*2,
                                  SHAREMORE_ITEMS_WIDTH,
                                  SHAREMORE_ITEMS_HEIGHT);
        
        shareDestroyAfterReadingButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [shareDestroyAfterReadingButton setFrame:frame];
        [shareDestroyAfterReadingButton setBackgroundImage:[UIImage imageNamed:@"sharemore_pic_ios7" inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
        //
        shareDestroyAfterReadingButton.layer.cornerRadius = 5.0;
        shareDestroyAfterReadingButton.layer.masksToBounds = YES;
        shareDestroyAfterReadingButton.layer.borderColor = [UIColor colorWithWhite:0.0 alpha:0.2].CGColor;
        shareDestroyAfterReadingButton.layer.borderWidth = 0.5;
        
        [shareDestroyAfterReadingButton addTarget:self action:@selector(shareDestroyAfterReadingButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return shareDestroyAfterReadingButton;
}

-(UILabel *)shareDestroyAfterReadingLabel
{
    if (!shareDestroyAfterReadingLabel) {
        
        CGRect frame = CGRectMake(m_buttonMargin*2 + SHAREMORE_ITEMS_WIDTH,
                                  SHAREMORE_ITEMS_TOP_MARGIN*3 + SHAREMORE_ITEMS_HEIGHT*2 + SHAREMORE_ITEM_LABEL_TOP_MARGIN*2,
                                  SHAREMORE_ITEM_LABEL_WIDTH*1.5,
                                  SHAREMORE_ITEM_LABEL_HEIGHT);
        
        shareDestroyAfterReadingLabel = [[UILabel alloc] initWithFrame:frame];
        [shareDestroyAfterReadingLabel setTextColor:[UIColor blackColor]];
        [shareDestroyAfterReadingLabel setFont:[UIFont systemFontOfSize:SHAREMORE_ITEM_LABEL_FONTSIZE]];
        [shareDestroyAfterReadingLabel setText:@"阅后即焚"];
        [shareDestroyAfterReadingLabel setBackgroundColor:[UIColor clearColor]];
    }
    
    return shareDestroyAfterReadingLabel;
}

#pragma mark - Delegate

-(void)sharePickPhotoButtonPressed:(id)sender
{
    if (delegate && [delegate respondsToSelector:@selector(sharePickPhotoButtonPressed:)]) {
        [delegate performSelector:@selector(sharePickPhotoButtonPressed:) withObject:nil];
    }
}

-(void)shareTakePhotoButtonPressed:(id)sender
{
    if (delegate && [delegate respondsToSelector:@selector(shareTakePhotoButtonPressed:)]) {
        [delegate performSelector:@selector(shareTakePhotoButtonPressed:) withObject:nil];
    }
}

-(void)shareShowFAQButtonPressed:(id)sender
{
    if (delegate && [delegate respondsToSelector:@selector(shareShowFAQButtonPressed:)]) {
        [delegate performSelector:@selector(shareShowFAQButtonPressed:) withObject:nil];
    }
}

-(void)shareRateButtonPressed:(id)sender
{
    if (delegate && [delegate respondsToSelector:@selector(shareRateButtonPressed:)]) {
        [delegate performSelector:@selector(shareRateButtonPressed:) withObject:nil];
    }
}

-(void)shareFileButtonPressed:(id)sender {
    if (delegate && [delegate respondsToSelector:@selector(shareFileButtonPressed:)]) {
        [delegate performSelector:@selector(shareFileButtonPressed:) withObject:nil];
    }
}

-(void)shareDestroyAfterReadingButtonPressed:(id)sender {
    if (delegate && [delegate respondsToSelector:@selector(shareDestroyAfterReadingButtonPressed:)]) {
        [delegate performSelector:@selector(shareDestroyAfterReadingButtonPressed:) withObject:nil];
    }
}


#pragma mark - HIDE

- (void)hideRateButton {
    
    [shareRateLabel setHidden:true];
    [shareRateButton setHidden:true];
}

- (void)hideFAQButton {
    
    [shareShowFAQLabel setHidden:true];
    [shareShowFAQButton setHidden:true];
}







@end












