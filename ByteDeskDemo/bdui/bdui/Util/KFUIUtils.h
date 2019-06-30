//
//  KFUIUtils.h
//  bytedesk-ui
//
//  Created by 宁金鹏 on 2019/4/11.
//  Copyright © 2019 KeFuDaShi. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KFUIUtils : NSObject

+ (NSArray *)documentTypes;

+ (CGSize)sizeOfRobotContent:(NSString *)msgContent;

@end

NS_ASSUME_NONNULL_END
