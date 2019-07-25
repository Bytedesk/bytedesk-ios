//
//  FBPhoneViewCell.m
//  feedback
//
//  Created by 萝卜丝 on 2017/2/18.
//  Copyright © 2017年 萝卜丝. All rights reserved.
//

#import "BDFormPhoneViewCell.h"

#define LBScreen [UIScreen mainScreen].bounds.size

@interface BDFormPhoneViewCell ()<UITextFieldDelegate>

@end

@implementation BDFormPhoneViewCell

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
    
    QMUITextField *phoneTextField = [[QMUITextField alloc] initWithFrame:CGRectMake(5, 0, LBScreen.width-10, 44)];
    phoneTextField.placeholder = @"手机号";
    phoneTextField.font = [UIFont systemFontOfSize:13.0f];
    phoneTextField.keyboardType = UIKeyboardTypePhonePad;
    phoneTextField.clearButtonMode = UITextFieldViewModeAlways;
//    phoneTextField.layer.cornerRadius = 2;
//    phoneTextField.layer.borderColor = UIColorSeparator.CGColor;
//    phoneTextField.layer.borderWidth = PixelOne;
//    phoneTextField.textInsets = UIEdgeInsetsMake(0, 10, 0, 10);
    [self.contentView addSubview:phoneTextField];
    
    // Add a "textFieldDidChange" notification method to the text field control.
    [phoneTextField addTarget:self action:@selector(textFieldDidChange:)
             forControlEvents:UIControlEventEditingChanged];
}

#pragma mark - UITextFieldDelegate

-(void)textFieldDidChange:(UITextField *)textField {
    DDLogInfo(@"%s", __PRETTY_FUNCTION__);
    
    if (_delegate && [_delegate respondsToSelector:@selector(phoneTextField:)]) {
        [_delegate phoneTextField:textField.text];
    }
}


@end





