//
//  KFDSMsgTextContentView.h
//  feedback
//
//  Created by 萝卜丝 on 2018/2/18.
//  Copyright © 2018年 萝卜丝. All rights reserved.
//

//#import <UIKit/UIKit.h>
#import "BDMsgBaseContentView.h"

@class M80AttributedLabel;

//@protocol KFDSMsgTextContentViewDelegate <NSObject>
//
//@end

@interface BDMsgTextContentView : BDMsgBaseContentView

@property (nonatomic, strong) M80AttributedLabel *textLabel;

//@property(nonatomic, assign) id<KFDSMsgTextContentViewDelegate>  subdelegate;

@end
