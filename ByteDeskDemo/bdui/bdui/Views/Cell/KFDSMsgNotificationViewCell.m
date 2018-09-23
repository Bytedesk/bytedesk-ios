//
//  KFDSNotificationViewCell.m
//  feedback
//
//  Created by 萝卜丝·Bytedesk.com on 2017/2/21.
//  Copyright © 2017年 萝卜丝·Bytedesk.com. All rights reserved.
//

#import "KFDSMsgNotificationViewCell.h"


@interface KFDSMsgNotificationViewCell()

@end


@implementation KFDSMsgNotificationViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        self.selectionStyle = UITableViewCellSelectionStyleNone;
//        [self setQmui_shouldShowDebugColor:YES];
    }
    return self;
}

//- (void)awakeFromNib {
//    [super awakeFromNib];
//    // Initialization code
//}
//
//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//    // Configure the view for the selected state
//}

- (void)initWithMessageModel:(BDMessageModel *)messageModel {
    //
    _messageModel = messageModel;
    //
    [self addSubviews];
    //
    [self setNeedsLayout];
}


- (void)addSubviews {
    
    if (_timestampLabel) {
        [_timestampLabel removeFromSuperview];
        _timestampLabel = nil;
    }

    if (_contentLabel) {
        [_contentLabel removeFromSuperview];
        _contentLabel = nil;
    }
    
    [self.contentView addSubview:self.timestampLabel];
    [self.contentView addSubview:self.contentLabel];
}


- (QMUILabel *)timestampLabel {
    //
    if (!_timestampLabel) {
        _timestampLabel = [[QMUILabel alloc] init];
        _timestampLabel.textColor = [UIColor grayColor];
        _timestampLabel.font = [UIFont systemFontOfSize:11.0f];
        _timestampLabel.canPerformCopyAction = YES;
        [_timestampLabel sizeToFit];
    }
    return _timestampLabel;
}

- (QMUILabel *)contentLabel {
    //
    if (!_contentLabel) {
        _contentLabel = [[QMUILabel alloc] init];
        _contentLabel.textColor = [UIColor grayColor];
        _contentLabel.font = [UIFont systemFontOfSize:11.0f];
        _contentLabel.canPerformCopyAction = YES;
        [_contentLabel sizeToFit];
    }
    return _contentLabel;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self layoutTimestampLabel];
    [self layoutContentLabel];
}


- (void)layoutTimestampLabel {
    //
    NSString *timestampString = [BDUtils getOptimizedTimestamp:_messageModel.createdAt];
    CGSize timestampSize = [timestampString sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11.0f]}];
    _timestampLabel.frame = CGRectMake((self.bounds.size.width - timestampSize.width - 10)/2, 0.5f, timestampSize.width + 10.0f, timestampSize.height+1);
    [_timestampLabel setText:timestampString];
}


- (void)layoutContentLabel {
    //
    CGSize contentSize = [_messageModel.content sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11.0f]}];
    _contentLabel.frame = CGRectMake((self.bounds.size.width - contentSize.width - 10)/2, 20.5f, contentSize.width, contentSize.height);
    [_contentLabel setText:_messageModel.content];
}




@end










