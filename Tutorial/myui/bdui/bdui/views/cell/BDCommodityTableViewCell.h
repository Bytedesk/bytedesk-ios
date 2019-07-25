//
//  BDCommodityTableViewCell.h
//  bytedesk-ui
//
//  Created by 萝卜丝 on 2019/3/15.
//  Copyright © 2019 KeFuDaShi. All rights reserved.
//

#import <QMUIKit/QMUIKit.h>
#import <bytedesk-core/bdcore.h>

NS_ASSUME_NONNULL_BEGIN

@protocol BDCommodityTableViewCellDelegate <NSObject>

- (void)sendCommodityButtonClicked:(BDMessageModel *)messageModel;
- (void)commodityBackgroundClicked:(BDMessageModel *)messageModel;

@end

@interface BDCommodityTableViewCell : QMUITableViewCell

@property(nonatomic, strong) QMUILabel                  *timestampLabel;

@property(nonatomic, strong) UIImageView                *commodityImageView;
@property(nonatomic, strong) QMUILabel                  *titleLabel;
@property(nonatomic, strong) QMUILabel                  *priceLabel;

@property(nonatomic, strong) QMUILabel                  *contentLabel;
@property(nonatomic, strong) BDMessageModel             *messageModel;

@property(nonatomic, strong) QMUIButton                 *sendButton;

- (void)initWithMessageModel:(BDMessageModel *)messageModel;

@end

NS_ASSUME_NONNULL_END
