//
//  KFDSMsgTextContentView.h
//  feedback
//
//  Created by 萝卜丝 · bytedesk.com on 2018/2/18.
//  Copyright © 2018年 萝卜丝 · bytedesk.com. All rights reserved.
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
