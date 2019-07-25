//
//  KFDSPlusView.h
//  feedback
//
//  Created by 宁金鹏 on 2017/2/22.
//  Copyright © 2017年 宁金鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KFDSPlusViewDelegate <NSObject>

-(void)sharePickPhotoButtonPressed:(id)sender;
-(void)shareTakePhotoButtonPressed:(id)sender;
-(void)shareRateButtonPressed:(id)sender;

@end


@interface KFDSPlusView : UIView

@property (nonatomic, weak) id<KFDSPlusViewDelegate> delegate;

- (void) hideRate;
- (void) showRate;

@end

