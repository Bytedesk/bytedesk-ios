//
//  KFStarView.h
//  AppKeFuLib
//
//  Created by jack on 15/9/9.
//  Copyright (c) 2015年 appkefu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KFStarView : UIView

@property (nonatomic,assign) NSInteger starNumber;

/*
 *调整底部视图的颜色
 */
@property (nonatomic,strong) UIColor *viewColor;

/*
 *是否允许可触摸
 */
@property (nonatomic,assign) BOOL enable;

@end
