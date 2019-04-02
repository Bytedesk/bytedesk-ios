//
//  KFPlusView.h
//  ChatViewController
//
//  Created by jack on 14-5-4.
//  Copyright (c) 2014年 appkefu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KFPlusViewDelegate <NSObject>

-(void)sharePickPhotoButtonPressed:(id)sender;
-(void)shareTakePhotoButtonPressed:(id)sender;
-(void)shareShowFAQButtonPressed:(id)sender;
-(void)shareRateButtonPressed:(id)sender;

-(void)shareFileButtonPressed:(id)sender;
-(void)shareDestroyAfterReadingButtonPressed:(id)sender;

@end

@interface KFPlusView : UIView

@property (nonatomic, weak) id<KFPlusViewDelegate> delegate;

- (void)hideRateButton;

- (void)hideFAQButton;

@end
