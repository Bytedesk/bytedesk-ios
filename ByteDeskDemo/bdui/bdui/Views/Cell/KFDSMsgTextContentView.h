//
//  KFDSMsgTextContentView.h
//  feedback
//
//  Created by 宁金鹏 on 2017/2/18.
//  Copyright © 2017年 宁金鹏. All rights reserved.
//

//#import <UIKit/UIKit.h>
#import "KFDSMsgBaseContentView.h"
@class M80AttributedLabel;


//@protocol KFDSMsgTextContentViewDelegate <NSObject>
//
//@end


@interface KFDSMsgTextContentView : KFDSMsgBaseContentView

@property (nonatomic, strong) M80AttributedLabel *textLabel;

//@property(nonatomic, assign) id<KFDSMsgTextContentViewDelegate>  subdelegate;

@end
