//
//  FBSubmitViewCell.h
//  feedback
//
//  Created by 萝卜丝 on 2017/2/18.
//  Copyright © 2017年 萝卜丝. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <QMUIKit/QMUIKit.h>

@protocol KFFormSubmitViewCellDelegate <NSObject>

@end


@interface KFFormSubmitViewCell : UITableViewCell

@property(nonatomic, weak) id<KFFormSubmitViewCellDelegate> delegate;

@end
