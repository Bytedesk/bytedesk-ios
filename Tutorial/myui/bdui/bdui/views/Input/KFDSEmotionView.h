//
//  KFDSEmotionView.h
//  feedback
//
//  Created by 宁金鹏 on 2017/2/22.
//  Copyright © 2017年 宁金鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KFDSEmotionViewDelegate <NSObject>

-(void)emotionFaceContent:(NSString *)faceText;
-(void)emotionFaceDelete;
-(void)emotionFaceSend;

@end



@interface KFDSEmotionView : UIView

@property (nonatomic, weak) id<KFDSEmotionViewDelegate> delegate;

@end
