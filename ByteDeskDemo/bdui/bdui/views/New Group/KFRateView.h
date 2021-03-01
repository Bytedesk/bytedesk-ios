//
//  KFRateView.h
//  AppKeFuLib
//
//  Created by jack on 15/9/9.
//  Copyright (c) 2015年 appkefu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KFRateViewDelegate <NSObject>

-(void)submitRateWithRate:(NSString *)rate withComment:(NSString *)comment;
-(void)cancelRate;

@end



@interface KFRateView : UIView

@property (nonatomic, weak) id<KFRateViewDelegate> delegate;

- (instancetype)initWithParentView:(UIView *)parentView;

- (void)show;

@end
