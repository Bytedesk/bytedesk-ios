//
//  KFDSEmotionView.m
//  feedback
//
//  Created by 宁金鹏 on 2017/2/22.
//  Copyright © 2017年 宁金鹏. All rights reserved.
//

#import "KFDSEmotionView.h"
//#import "KFDSMacros.h"
#import "KFDSUConstants.h"

//define this constant if you want to enable auto-boxing for default syntax
#define MAS_SHORTHAND_GLOBALS
#import <Masonry/Masonry.h>

#define SCROLLVIEW_HEIGHT  150.0f
//#define SCROLLVIEW_WIDTH   320.0f

#define PAGESCROLL_HEIGHT   66.0f
#define PAGESCROLL_WIDTH    80.0f

#define EMOTION_LEFT_MARGIN 13.5f
#define EMOTION_TOP_MARGIN  19.0f

#define EMOTION_FACE_WIDTH  30.0f
#define EMOTION_FACE_HEIGHT 30.0f

#define SENDBUTTON_WIDTH    80.0f
#define SENDBUTTON_HEIGHT   40.0f
#define SENDBUTTON_RIGHT_MARGIN 15.0f


#define kColumnCountMax 14
#define kColumnCountMin 7


static NSString *CellIdentifier = @"EmotionCollectionViewCell";


@interface KFDSEmotionView ()<UIScrollViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UIView            *topLineView;
@property (nonatomic, strong) UIScrollView      *scrollView;
@property (nonatomic, strong) UIPageControl     *pageControl;
@property (nonatomic, strong) UIButton          *sendButton;

@property (nonatomic, strong) UICollectionView  *emotionCollectionView;
@property (nonatomic, strong) NSDictionary      *emotionToTextDictionary;

@property (nonatomic, assign) NSInteger         mScrollViewWidth;


@end


@implementation KFDSEmotionView


@synthesize topLineView,
scrollView,
pageControl,
sendButton,

emotionCollectionView,
emotionToTextDictionary,

delegate,
mScrollViewWidth;


-(id) init {
    self = [super init];
    if (self) {
        //Masonry will also call view1.translatesAutoresizingMaskIntoConstraints = NO; for you.
        //https://github.com/SnapKit/Masonry
        //self.translatesAutoresizingMaskIntoConstraints = NO;
        
        self.backgroundColor = UIColorFromRGB(0XEBEBEB);
        mScrollViewWidth = [[UIScreen mainScreen] bounds].size.width;
        emotionToTextDictionary = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle bundleForClass:self.class] pathForResource:@"EmotionToText" ofType:@"plist"]];
        //        NSString *path = [[NSBundle bundleForClass:self.class] bundlePath];
        //        NSString *finalPath = [path stringByAppendingPathComponent:@"EmotionToText.plist"];
        //        emotionToTextDictionary = [NSDictionary dictionaryWithContentsOfFile:finalPath];
        
        [self addSubview:[self topLineView]];
        [self addSubview:[self scrollView]];
        [self addSubview:[self pageControl]];
        [self addSubview:[self sendButton]];
        
        [self initViewConstraints];
    }
    return self;
}


-(UIView *)topLineView
{
    if (!topLineView) {
        
        topLineView = [UIView new];
        topLineView.backgroundColor = UIColorFromRGB(0X939698);
    }
    
    return topLineView;
}

-(UIScrollView *)scrollView
{
    if (!scrollView) {
        
        scrollView = [UIScrollView new];
        scrollView.pagingEnabled = YES;
        scrollView.contentSize = CGSizeMake(mScrollViewWidth * 5, SCROLLVIEW_HEIGHT);
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.delegate = self;
        
        [scrollView addSubview:[self emotionCollectionView]];
    }
    
    return scrollView;
}

-(UICollectionView *)emotionCollectionView {
    
    if (!emotionCollectionView) {
        
        UICollectionViewFlowLayout *collectionLayout = [[UICollectionViewFlowLayout alloc] init];
        //        collectionLayout.minimumLineSpacing = 2.0;
        //        collectionLayout.minimumInteritemSpacing = 2;
        //        collectionLayout.itemSize = CGSizeMake(EMOTION_FACE_WIDTH, EMOTION_FACE_HEIGHT);
        collectionLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        emotionCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:collectionLayout];
        emotionCollectionView.delegate = self;
        emotionCollectionView.dataSource = self;
        emotionCollectionView.backgroundColor = UIColorFromRGB(0XEBEBEB);
        emotionCollectionView.bounces = NO;
        emotionCollectionView.showsVerticalScrollIndicator = NO;
        emotionCollectionView.showsHorizontalScrollIndicator = NO;
        
        CGFloat inset = collectionLayout.minimumLineSpacing*1.5;
        emotionCollectionView.contentInset = UIEdgeInsetsMake(inset, 0.0, inset, 0.0);
        emotionCollectionView.scrollIndicatorInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
        [emotionCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:CellIdentifier];
    }
    
    return emotionCollectionView;
}


-(UIPageControl *)pageControl
{
    if (!pageControl) {
        
        pageControl = [[UIPageControl alloc] init];
        pageControl.numberOfPages = 5;
        pageControl.currentPage = 0;
        [pageControl setCurrentPageIndicatorTintColor:UIColorFromRGB(0X8B8B8B)];
        [pageControl setPageIndicatorTintColor:UIColorFromRGB(0XBBBBBB)];
        [pageControl addTarget:self action:@selector(pageControlIndicatorPressed:) forControlEvents:UIControlEventValueChanged];
    }
    
    return pageControl;
}

-(UIButton *)sendButton
{
    if (!sendButton) {
        
        sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [sendButton setBackgroundImage:[UIImage imageNamed:@"EmotionsSendBtnGrey_ios7" inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
        [sendButton setBackgroundImage:[UIImage imageNamed:@"EmotionsSendBtnBlue" inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil] forState:UIControlStateHighlighted];
        
        [[sendButton titleLabel] setFont:[UIFont systemFontOfSize:15.0f]];
        [sendButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [sendButton setTitle:NSLocalizedString(@"Send", nil) forState:UIControlStateNormal];
        
        [sendButton addTarget:self action:@selector(emotionFaceSend:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return sendButton;
}


#pragma mark - Constrains

-(void)initViewConstraints {
    
    //    UIView *superView = self;
    __weak typeof(self) weakSelf = self;
    [topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.and.right.equalTo(weakSelf);
        make.height.equalTo(@0.5);
    }];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topLineView.mas_bottom);
        make.left.and.right.equalTo(weakSelf);
        make.height.equalTo(@(SCROLLVIEW_HEIGHT));
    }];
    //    [emotionFaceView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.left.and.top.equalTo(scrollView);
    //        make.width.equalTo(@(mScrollViewWidth*5));
    //        make.height.equalTo(@(SCROLLVIEW_HEIGHT));
    //    }];
    [emotionCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.equalTo(scrollView);
        make.width.equalTo(@(mScrollViewWidth*5));
        make.height.equalTo(@(SCROLLVIEW_HEIGHT));
    }];
    [pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(scrollView.mas_bottom);
        make.centerX.equalTo(weakSelf.mas_centerX);
        make.width.equalTo(@(PAGESCROLL_WIDTH));
        make.height.equalTo(@(PAGESCROLL_HEIGHT));
    }];
    [sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.mas_right);
        make.bottom.equalTo(weakSelf.mas_bottom);
        make.height.equalTo(@(SENDBUTTON_HEIGHT));
        make.width.equalTo(@(SENDBUTTON_WIDTH));
    }];
}


- (NSInteger)columnCount {
    return UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation) ? kColumnCountMax : kColumnCountMin;
}


#pragma mark - SendButtonClick

-(void)emotionFaceSend:(id)sender {
    
    if (delegate && [delegate respondsToSelector:@selector(emotionFaceSend)]) {
        [delegate performSelector:@selector(emotionFaceSend)];
    }
}

//FIXME: 123

#pragma mark - UIScrollViewDelegate

-(void)scrollViewDidEndDecelerating:(UIScrollView *)lscrollView
{
    [pageControl setCurrentPage:lscrollView.contentOffset.x/mScrollViewWidth];
    [pageControl updateCurrentPageDisplay];
}

-(void)pageControlIndicatorPressed:(id)sender
{
    NSInteger currentIndex = pageControl.currentPage;
    [scrollView scrollRectToVisible:CGRectMake(mScrollViewWidth*currentIndex, 0, mScrollViewWidth, SCROLLVIEW_HEIGHT) animated:YES];
}


#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    //    NSLog(@"clicked section:%d, row:%d", indexPath.section, indexPath.row);
    
    NSUInteger index = indexPath.section * 21 + indexPath.row + 1;
    NSString *key = [NSString stringWithFormat:@"Expression_%lu",index];
    NSString *emotionText = [emotionToTextDictionary objectForKey:key];
    
    //取余为0，即整除
    if (index%21 == 0) {
        if (delegate && [delegate respondsToSelector:@selector(emotionFaceDelete)]) {
            [delegate performSelector:@selector(emotionFaceDelete)];
        }
    }
    else {
        if (delegate && [delegate respondsToSelector:@selector(emotionFaceContent:)]) {
            [delegate performSelector:@selector(emotionFaceContent:) withObject:emotionText];
        }
    }
}

//定义每个face的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(EMOTION_FACE_WIDTH, EMOTION_FACE_HEIGHT);
}

//列间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    return (mScrollViewWidth - EMOTION_FACE_WIDTH * 7)/8;
}

//行间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 10;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    CGFloat left = (mScrollViewWidth - EMOTION_FACE_WIDTH * 7)/8;
    return UIEdgeInsetsMake(5, left, 5, left);
}


#pragma mark UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 5;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 21;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.selectedBackgroundView = [UIView new];
    cell.selectedBackgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.25];
    //
    UIImageView *emoFaceImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, EMOTION_FACE_WIDTH, EMOTION_FACE_HEIGHT)];
    
    NSUInteger index = indexPath.section * 21 + indexPath.row + 1;
    if (index%21 == 0) {
        [emoFaceImageView setImage:[UIImage imageNamed:@"DeleteEmoticonBtn_ios7" inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil]];
    }
    else {
        [emoFaceImageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"Expression_%lu", index] inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil]];
    }
    //
    [cell.contentView addSubview:emoFaceImageView];
    
    return cell;
}



@end
