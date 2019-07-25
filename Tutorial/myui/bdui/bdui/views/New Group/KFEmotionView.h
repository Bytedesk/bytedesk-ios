//
//  KFEmotionView.h
//  ChatViewController
//
//  Created by jack on 14-5-4.
//  Copyright (c) 2014年 appkefu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KFEmotionFaceViewDelegate <NSObject>

-(void)emotionFaceButtonPressed:(id)sender;

@end

//
@interface KFEmotionFaceView : UIView

@property (nonatomic, weak) id<KFEmotionFaceViewDelegate> delegate;

@end


@protocol KFEmotionViewDelegate <NSObject>

-(void)emotionFaceButtonPressed:(id)sender;
-(void)emotionViewSendButtonPressed:(id)sender;

@end


//
@interface KFEmotionView : UIView

@property (nonatomic, weak) id<KFEmotionViewDelegate> delegate;

@end
