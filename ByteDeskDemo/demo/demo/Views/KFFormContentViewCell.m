//
//  FBContentViewCell.m
//  feedback
//
//  Created by 萝卜丝 on 2017/2/18.
//  Copyright © 2017年 萝卜丝. All rights reserved.
//

#import "KFFormContentViewCell.h"
#import "UIView+FeedBack.h"

#define LBScreen [UIScreen mainScreen].bounds.size

@interface KFFormContentViewCell ()<UITextViewDelegate>

@end


@implementation KFFormContentViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self setupSubviews];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setupSubviews {
    
    QMUITextView *contentTextView = [[QMUITextView alloc] initWithFrame:CGRectMake(0, 0, LBScreen.width, 100)];
//    contentTextView.delegate = self;
    contentTextView.font = [UIFont systemFontOfSize:13.0f];
    contentTextView.placeholder = @"请简要描述你的问题和意见";
//    contentTextView.placeholderLabel.font = [UIFont systemFontOfSize:13.0f];
    [self.contentView addSubview:contentTextView];
    
    
    UILabel *countTipLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    countTipLabel.text = @"0/200";
    countTipLabel.font = [UIFont systemFontOfSize:13.0f];
    countTipLabel.textColor = [UIColor grayColor];
    countTipLabel.fb_bottom = 70;
    countTipLabel.fb_right = LBScreen.width - 45;
    [self.contentView addSubview:countTipLabel];
    [countTipLabel sizeToFit];
    
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView {
    //    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    if (_delegate && [_delegate respondsToSelector:@selector(contentTextView:)]) {
        [_delegate contentTextView:textView.text];
    }
}

@end
