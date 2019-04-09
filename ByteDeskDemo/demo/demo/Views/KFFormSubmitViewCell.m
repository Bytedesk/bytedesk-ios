//
//  FBSubmitViewCell.m
//  feedback
//
//  Created by 萝卜丝 on 2017/2/18.
//  Copyright © 2017年 萝卜丝. All rights reserved.
//

#import "KFFormSubmitViewCell.h"

#define LBScreen [UIScreen mainScreen].bounds.size

@implementation KFFormSubmitViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
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
    
    UIButton *submitBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 0, LBScreen.width-40, 40)];
    [submitBtn setTitle:NSLocalizedString(@"提交", nil) forState:UIControlStateNormal];
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submitBtn setBackgroundColor:[UIColor colorWithRed:255/255.0f green:104/255.0f blue:0/255.0f alpha:1]];
    [submitBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    submitBtn.layer.cornerRadius = 5.0;
    submitBtn.layer.masksToBounds = YES;
    [submitBtn addTarget:self action:@selector(submitButtonClicked:) forControlEvents:UIControlEventTouchUpInside];

    [self.contentView addSubview:submitBtn];
}

- (void)submitButtonClicked:(UIButton *)btn {
    NSLog(@"submit");
    
}

@end







