//
//  FBPhoneViewCell.m
//  feedback
//
//  Created by 萝卜丝 on 2017/2/18.
//  Copyright © 2017年 萝卜丝. All rights reserved.
//

#import "BDFormEmailViewCell.h"

#define LBScreen [UIScreen mainScreen].bounds.size

@interface BDFormEmailViewCell ()<UITextFieldDelegate>

@end

@implementation BDFormEmailViewCell

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
    
    QMUITextField *emailTextField = [[QMUITextField alloc] initWithFrame:CGRectMake(5, 0, LBScreen.width-10, 44)];
    emailTextField.placeholder = @"邮箱";
    emailTextField.font = [UIFont systemFontOfSize:13.0f];
    emailTextField.clearButtonMode = UITextFieldViewModeAlways;
//    emailTextField.layer.cornerRadius = 2;
//    emailTextField.layer.borderColor = UIColorSeparator.CGColor;
//    emailTextField.layer.borderWidth = PixelOne;
//    emailTextField.textInsets = UIEdgeInsetsMake(0, 10, 0, 10);
    [self.contentView addSubview:emailTextField];
    
    // Add a "textFieldDidChange" notification method to the text field control.
    [emailTextField addTarget:self action:@selector(textFieldDidChange:)
             forControlEvents:UIControlEventEditingChanged];
    
}


#pragma mark - UITextFieldDelegate

-(void)textFieldDidChange:(UITextField *)textField {
    DDLogInfo(@"%s", __PRETTY_FUNCTION__);
    
    if (_delegate && [_delegate respondsToSelector:@selector(emailTextField:)]) {
        [_delegate emailTextField:textField.text];
    }
}


@end





