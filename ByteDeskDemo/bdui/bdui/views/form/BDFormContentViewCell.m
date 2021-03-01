//
//  FBContentViewCell.m
//  feedback
//
//  Created by 萝卜丝 on 2017/2/18.
//  Copyright © 2017年 萝卜丝. All rights reserved.
//

#import "BDFormContentViewCell.h"
#import "UIView+FeedBack.h"

#define LBScreen [UIScreen mainScreen].bounds.size

@interface BDFormContentViewCell ()<QMUITextViewDelegate>

@property(nonatomic, strong) QMUITextView *contentTextView;
@property(nonatomic, strong) UILabel *countTipLabel;

@end


@implementation BDFormContentViewCell

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
    
    self.contentTextView = [[QMUITextView alloc] initWithFrame:CGRectMake(0, 0, LBScreen.width, 100)];
    self.contentTextView.delegate = self;
    self.contentTextView.font = [UIFont systemFontOfSize:13.0f];
    self.contentTextView.placeholder = @"请简要描述你的问题和意见";
//    contentTextView.placeholderLabel.font = [UIFont systemFontOfSize:13.0f];
    [self.contentView addSubview:self.contentTextView];
    
    //
    self.countTipLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.countTipLabel.text = @"0/200";
    self.countTipLabel.font = [UIFont systemFontOfSize:13.0f];
    self.countTipLabel.textColor = [UIColor grayColor];
    self.countTipLabel.fb_bottom = 70;
    self.countTipLabel.fb_right = LBScreen.width - 60;
    [self.contentView addSubview:self.countTipLabel];
    [self.countTipLabel sizeToFit];
    
    //
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView {
//    DDLogInfo(@"%s", __PRETTY_FUNCTION__);
    NSUInteger length = [textView.text length];
    self.countTipLabel.text = [NSString stringWithFormat:@"%lu/200", (unsigned long)length];
    
    if (_delegate && [_delegate respondsToSelector:@selector(contentTextView:)]) {
        [_delegate contentTextView:textView.text];
    }
}

@end
