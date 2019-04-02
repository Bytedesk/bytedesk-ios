//
//  KFRosterTableViewCell.m
//  kefu
//
//  Created by 萝卜丝 on 2018/11/28.
//  Copyright © 2018年 Bytedesk.com. All rights reserved.
//

#import "KFContactTableViewCell.h"
//#import "KFUtils.h"

#import <AFNetworking/UIImageView+AFNetworking.h>

#define AVATAR_HEIGHT_WIDTH   30
#define TIMESTAMP_LABEL_WIDTH 100
#define MARGIN                15
#define CONTENT_LABEL_HEIGHT  20
#define UNREAD_LABEL_HEIGHT   16

@interface KFContactTableViewCell()

@property(nonatomic, assign) NSInteger     mScreenWidth;
@property(nonatomic, strong) UIImageView   *mAvatarImageView;
@property(nonatomic, strong) UILabel       *mTitleLabel;
@property(nonatomic, strong) UILabel       *mDescriptionLabel;
@property(nonatomic, strong) NSString      *mType;

@end


@implementation KFContactTableViewCell

@synthesize mScreenWidth,
            mAvatarImageView,
            mTitleLabel, mDescriptionLabel, mType;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        mScreenWidth = [UIScreen mainScreen].bounds.size.width;
        
        [self.contentView addSubview:[self mAvatarImageView]];
        [self.contentView addSubview:[self mTitleLabel]];
        [self.contentView addSubview:[self mDescriptionLabel]];
        
        [self initViewConstraints];
    }
    return self;
}


- (void)initWithGroupModel:(BDGroupModel *)groupModel {
    //
    mTitleLabel.text = groupModel.nickname;
    mType = @"group";
    // TODO: 根据来源不同显示不同的placeholder image
    [mAvatarImageView setImageWithURL:[NSURL URLWithString:groupModel.avatar] placeholderImage:[UIImage imageNamed:@"android_default_avatar"]];
}

- (void)initWithContactModel:(BDContactModel *)contactModel {
    //
    mTitleLabel.text = contactModel.nickname;
    mDescriptionLabel.text = contactModel.mdescription;
    mType = @"contact";
    // TODO: 根据来源不同显示不同的placeholder image
    [mAvatarImageView setImageWithURL:[NSURL URLWithString:contactModel.avatar] placeholderImage:[UIImage imageNamed:@"android_default_avatar"]];
}

- (void)initWithRelationModel:(BDContactModel *)contactModel {
    //
    mTitleLabel.text = contactModel.nickname;
    mDescriptionLabel.text = contactModel.mdescription;
    // TODO: 根据来源不同显示不同的placeholder image
    [mAvatarImageView setImageWithURL:[NSURL URLWithString:contactModel.avatar] placeholderImage:[UIImage imageNamed:@"android_default_avatar"]];
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

-(UILabel *)mTitleLabel {
    if (!mTitleLabel) {
        
        mTitleLabel = [UILabel new];
        mTitleLabel.font = [UIFont systemFontOfSize:13.0f];
    }
    return mTitleLabel;
}

-(UILabel *)mDescriptionLabel {
    if (!mDescriptionLabel) {
        
        mDescriptionLabel = [UILabel new];
        mDescriptionLabel.font = [UIFont systemFontOfSize:10.0f];
    }
    return mDescriptionLabel;
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
   
    mDescriptionLabel.qmui_left = mAvatarImageView.qmui_right + MARGIN;
    mDescriptionLabel.qmui_top = MARGIN + CONTENT_LABEL_HEIGHT;
    mDescriptionLabel.qmui_height = CONTENT_LABEL_HEIGHT;
    mDescriptionLabel.qmui_width = mScreenWidth - AVATAR_HEIGHT_WIDTH - MARGIN * 2 - TIMESTAMP_LABEL_WIDTH;
}


@end



