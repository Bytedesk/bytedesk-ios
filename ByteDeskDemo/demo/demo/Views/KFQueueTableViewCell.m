//
//  KFQueueTableViewCell.m
//  kefu
//
//  Created by 萝卜丝 on 2018/11/28.
//  Copyright © 2018年 Bytedesk.com. All rights reserved.
//

#import "KFQueueTableViewCell.h"
//#import "KFUtils.h"

#import <AFNetworking/UIImageView+AFNetworking.h>

#define AVATAR_HEIGHT_WIDTH   30
#define TIMESTAMP_LABEL_WIDTH 100
#define MARGIN                15
#define CONTENT_LABEL_HEIGHT  20
#define UNREAD_LABEL_HEIGHT   16


@interface KFQueueTableViewCell()

@property(nonatomic, assign)  NSInteger     mScreenWidth;
@property (nonatomic, strong) UIImageView   *mAvatarImageView;
//@property (nonatomic, strong) UILabel       *mUnReadLabel;
@property (nonatomic, strong) UILabel       *mTitleLabel;;
//@property (nonatomic, strong) UILabel       *mContentLabel;
@property (nonatomic, strong) UILabel       *mTimestampLabel;

@end


@implementation KFQueueTableViewCell

@synthesize mScreenWidth,
            mAvatarImageView,
//            mUnReadLabel,
//            mContentLabel,
            mTimestampLabel,
            mTitleLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        mScreenWidth = [UIScreen mainScreen].bounds.size.width;
        
        [self.contentView addSubview:[self mAvatarImageView]];
//        [self.contentView addSubview:[self mUnReadLabel]];
        [self.contentView addSubview:[self mTitleLabel]];
//        [self.contentView addSubview:[self mContentLabel]];
        [self.contentView addSubview:[self mTimestampLabel]];
        
        [self initViewConstraints];
    }
    return self;
}

- (void)initWithQueueModel:(BDQueueModel *)queueModel {
    //
    mTitleLabel.text = queueModel.nickname;
    // TODO: 根据来源不同显示不同的placeholder image
//    DDLogInfo(@"%s avatar:%@", __PRETTY_FUNCTION__, queueModel.avatar);
    [mAvatarImageView setImageWithURL:[NSURL URLWithString:queueModel.avatar] placeholderImage:[UIImage imageNamed:@"android_default_avatar"]];
    mTimestampLabel.text = @"";//[KFUtils getOptimizedTimestamp:queueModel.joined_at];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(UIImageView *)mAvatarImageView {
    if (!mAvatarImageView) {
        
        mAvatarImageView = [UIImageView new];
        mAvatarImageView.backgroundColor = [UIColor clearColor];
        mAvatarImageView.contentMode = UIViewContentModeScaleAspectFit;
        mAvatarImageView.layer.cornerRadius = 5;
        mAvatarImageView.layer.masksToBounds = YES;
    }
    return mAvatarImageView;
}

//-(UILabel *)mUnReadLabel {
//    if (!mUnReadLabel) {
//
//        mUnReadLabel = [UILabel new];
//        mUnReadLabel.font = [UIFont systemFontOfSize:12.0f];
//        mUnReadLabel.backgroundColor = [UIColor redColor];
//        mUnReadLabel.textAlignment = NSTextAlignmentCenter;
//        mUnReadLabel.layer.cornerRadius = UNREAD_LABEL_HEIGHT/2;
//        mUnReadLabel.layer.masksToBounds = YES;
//        mUnReadLabel.textColor = [UIColor whiteColor];
//    }
//    return mUnReadLabel;
//}

-(UILabel *)mTitleLabel {
    if (!mTitleLabel) {
        
        mTitleLabel = [UILabel new];
        mTitleLabel.font = [UIFont systemFontOfSize:13.0f];
    }
    return mTitleLabel;
}

//-(UILabel *)mContentLabel {
//    if (!mContentLabel) {
//
//        mContentLabel = [UILabel new];
//        mContentLabel.textColor = [UIColor grayColor];
//        mContentLabel.font = [UIFont systemFontOfSize:12.0f];
//    }
//    return mContentLabel;
//}

-(UILabel *)mTimestampLabel {
    if (!mTimestampLabel) {
        
        mTimestampLabel = [UILabel new];
        mTimestampLabel.font = [UIFont systemFontOfSize:11.0f];
        mTimestampLabel.textAlignment = NSTextAlignmentRight;
        mTimestampLabel.textColor = [UIColor grayColor];
    }
    return mTimestampLabel;
}

#pragma mark - Section

- (void)initViewConstraints {
    //    DDLogInfo(@"height:%f", self.frame.size.height); // 默认行高：44
    
    mAvatarImageView.qmui_left = MARGIN;
    mAvatarImageView.qmui_top = MARGIN;
    mAvatarImageView.qmui_height = AVATAR_HEIGHT_WIDTH;
    mAvatarImageView.qmui_width = AVATAR_HEIGHT_WIDTH;
    
    mTitleLabel.qmui_left = mAvatarImageView.qmui_right + MARGIN;
    mTitleLabel.qmui_top = MARGIN;
    mTitleLabel.qmui_height = CONTENT_LABEL_HEIGHT;
    mTitleLabel.qmui_width = mScreenWidth - AVATAR_HEIGHT_WIDTH - MARGIN * 2 - TIMESTAMP_LABEL_WIDTH;
    
//    mContentLabel.qmui_left = mAvatarImageView.qmui_right + MARGIN;
//    mContentLabel.qmui_top = mTitleLabel.qmui_bottom;
//    mContentLabel.qmui_height = CONTENT_LABEL_HEIGHT;
//    mContentLabel.qmui_width = TIMESTAMP_LABEL_WIDTH;
    
    mTimestampLabel.qmui_right = mScreenWidth - MARGIN - TIMESTAMP_LABEL_WIDTH;
    mTimestampLabel.qmui_top = MARGIN + 5;
    mTimestampLabel.qmui_height = CONTENT_LABEL_HEIGHT;
    mTimestampLabel.qmui_width = TIMESTAMP_LABEL_WIDTH;
    
//    mUnReadLabel.qmui_right = mScreenWidth - MARGIN * 2;
//    mUnReadLabel.qmui_top = mTimestampLabel.qmui_bottom;
//    mUnReadLabel.qmui_height = UNREAD_LABEL_HEIGHT;
//    mUnReadLabel.qmui_width = UNREAD_LABEL_HEIGHT;
}


@end





