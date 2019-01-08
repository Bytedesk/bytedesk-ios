//
//  FBPhoneViewCell.h
//  feedback
//
//  Created by 宁金鹏 on 2017/2/18.
//  Copyright © 2017年 宁金鹏. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <QMUIKit/QMUIKit.h>

@protocol KFFormPhoneViewCellDelegate <NSObject>

-(void)phoneTextField:(NSString *)phone;

@end

@interface KFFormPhoneViewCell : UITableViewCell

@property(nonatomic, weak) id<KFFormPhoneViewCellDelegate> delegate;

@end
