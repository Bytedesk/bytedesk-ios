//
//  KFDSPlusView.m
//  feedback
//
//  Created by 宁金鹏 on 2017/2/22.
//  Copyright © 2017年 宁金鹏. All rights reserved.
//

#import "KFDSPlusView.h"
#import "KFDSUConstants.h"

//define this constant if you want to enable auto-boxing for default syntax
#define MAS_SHORTHAND_GLOBALS
#import <Masonry/Masonry.h>

#define SHAREMORE_ITEM_LEAD_TAIL_MARGIN  50.0f
#define SHAREMORE_ITEM_TOP_MARGIN        50.0f
#define SHAREMORE_ITEM_LABEL_FONTSIZE    13.0f
#define SHAREMORE_ITEM_HEIGHT_WIDTH      53.0f

#define SHAREMORE_ITEM_LABEL_TOP_MARGIN  2.0f
#define SHAREMORE_ITEM_LABEL_WIDTH       50.0f
#define SHAREMORE_ITEM_LABEL_HEIGHT      30.0f

@interface KFDSPlusView ()

@property (nonatomic, strong) UIView    *topLineView;

@property (nonatomic, strong) UIButton  *sharePickPhotoButton;
@property (nonatomic, strong) UILabel   *sharePickPhotoLabel;

@property (nonatomic, strong) UIButton  *shareTakePhotoButton;
@property (nonatomic, strong) UILabel   *shareTakePhotoLabel;

@property (nonatomic, strong) UIButton  *shareRateButton;
@property (nonatomic, strong) UILabel   *shareRateLabel;


@end

@implementation KFDSPlusView

@synthesize delegate,
topLineView,
sharePickPhotoButton, sharePickPhotoLabel,
shareTakePhotoButton, shareTakePhotoLabel,
shareRateButton, shareRateLabel;

-(id) init {
    self = [super init];
    if (self) {
        //Masonry will also call view1.translatesAutoresizingMaskIntoConstraints = NO; for you.
        //https://github.com/SnapKit/Masonry
        //        self.translatesAutoresizingMaskIntoConstraints = NO;
        
        self.backgroundColor = UIColorFromRGB(0XEBEBEB);
        
        [self addSubview:[self topLineView]];
        [self addSubview:[self sharePickPhotoButton]];
        [self addSubview:[self sharePickPhotoLabel]];
        [self addSubview:[self shareTakePhotoButton]];
        [self addSubview:[self shareTakePhotoLabel]];
        [self addSubview:[self shareRateButton]];
        [self addSubview:[self shareRateLabel]];
        
        [self initViewConstraints];
        
    }
    return self;
}


#pragma mark Init SubViews
-(UIView *)topLineView
{
    if (!topLineView) {
        
        topLineView = [UIView new];
        topLineView.backgroundColor = UIColorFromRGB(0X939698);
    }
    
    return topLineView;
}

-(UIButton *)sharePickPhotoButton
{
    if (!sharePickPhotoButton) {
        
        sharePickPhotoButton = [UIButton buttonWithType:UIButtonTypeCustom];
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
        
        sharePickPhotoLabel = [UILabel new];
        [sharePickPhotoLabel setTextColor:[UIColor blackColor]];
        [sharePickPhotoLabel setFont:[UIFont systemFontOfSize:SHAREMORE_ITEM_LABEL_FONTSIZE]];
        [sharePickPhotoLabel setText:NSLocalizedString(@"Photo", nil)];
        [sharePickPhotoLabel setBackgroundColor:[UIColor clearColor]];
    }
    
    return sharePickPhotoLabel;
}



-(UIButton *)shareTakePhotoButton
{
    if (!shareTakePhotoButton) {
        
        shareTakePhotoButton = [UIButton buttonWithType:UIButtonTypeCustom];
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
        
        shareTakePhotoLabel = [UILabel new];
        [shareTakePhotoLabel setTextColor:[UIColor blackColor]];
        [shareTakePhotoLabel setFont:[UIFont systemFontOfSize:SHAREMORE_ITEM_LABEL_FONTSIZE]];
        [shareTakePhotoLabel setText:NSLocalizedString(@"Camera", nil)];
        [shareTakePhotoLabel setBackgroundColor:[UIColor clearColor]];
        
    }
    
    return shareTakePhotoLabel;
}

-(UIButton *)shareRateButton
{
    if (!shareRateButton) {
        
        shareRateButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [shareRateButton setBackgroundImage:[UIImage imageNamed:@"sharemore_friendcard_ios7" inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
        //
        shareRateButton.layer.cornerRadius = 5.0;
        shareRateButton.layer.masksToBounds = YES;
        shareRateButton.layer.borderColor = [UIColor colorWithWhite:0.0 alpha:0.2].CGColor;
        shareRateButton.layer.borderWidth = 0.5;
        
        [shareRateButton addTarget:self action:@selector(shareRateButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        [shareRateButton setHidden:true];
    }
    
    return shareRateButton;
}

-(UILabel *)shareRateLabel
{
    if (!shareRateLabel) {
        
        shareRateLabel = [UILabel new];
        [shareRateLabel setTextColor:[UIColor blackColor]];
        [shareRateLabel setFont:[UIFont systemFontOfSize:SHAREMORE_ITEM_LABEL_FONTSIZE]];
        [shareRateLabel setText:NSLocalizedString(@"Rate", nil)];
        [shareRateLabel setBackgroundColor:[UIColor clearColor]];
        
        [shareRateLabel setHidden:true];
    }
    
    return shareRateLabel;
}

#pragma mark Constrains

-(void)initViewConstraints {
    
    //    UIView *superView = self;
    __weak typeof(self) weakSelf = self;
    
    [topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.and.right.equalTo(weakSelf);
        make.height.equalTo(@0.5);
    }];
    
    NSMutableArray *btnArray = @[].mutableCopy;
    [btnArray addObject:sharePickPhotoButton];
    [btnArray addObject:shareTakePhotoButton];
    [btnArray addObject:shareRateButton];
    [btnArray mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:SHAREMORE_ITEM_HEIGHT_WIDTH leadSpacing:SHAREMORE_ITEM_LEAD_TAIL_MARGIN tailSpacing:SHAREMORE_ITEM_LEAD_TAIL_MARGIN];
    [btnArray mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(SHAREMORE_ITEM_TOP_MARGIN));
        make.height.equalTo(@(SHAREMORE_ITEM_HEIGHT_WIDTH));
    }];
    
    //
    [sharePickPhotoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(sharePickPhotoButton);
        make.top.equalTo(sharePickPhotoButton.mas_bottom).offset(2);
    }];
    [shareTakePhotoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(shareTakePhotoButton);
        make.top.equalTo(shareTakePhotoButton.mas_bottom).offset(2);
    }];
    [shareRateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(shareRateButton);
        make.top.equalTo(shareRateButton.mas_bottom).offset(2);
    }];
}



#pragma mark CSPlusViewDelegate


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

-(void)shareRateButtonPressed:(id)sender
{
    if (delegate && [delegate respondsToSelector:@selector(shareRateButtonPressed:)]) {
        [delegate performSelector:@selector(shareRateButtonPressed:) withObject:nil];
    }
}

#pragma mark

-(void)hideRate {
    
    if (shareRateButton) {
        [shareRateButton setHidden:TRUE];
        [shareRateLabel setHidden:TRUE];
    }
}

-(void)showRate {
    
    if (shareRateButton) {
        [shareRateButton setHidden:FALSE];
        [shareRateLabel setHidden:FALSE];
    }
}


@end






