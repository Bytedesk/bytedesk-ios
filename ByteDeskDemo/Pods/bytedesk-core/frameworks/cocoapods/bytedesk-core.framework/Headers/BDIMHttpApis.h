//
//  BDIMHttpApis.h
//  bytedesk-core
//
//  Created by 萝卜丝 on 2019/1/14.
//  Copyright © 2019 KeFuDaShi. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^SuccessCallbackBlock)(NSDictionary *dict);
typedef void (^FailedCallbackBlock)(NSError *error);

@interface BDIMHttpApis : NSObject

+ (BDIMHttpApis *)sharedInstance;

// TODO: 分拆IM相关接口到此文件
- (void) getProto:(NSString *)cmd
    resultSuccess:(SuccessCallbackBlock)success
     resultFailed:(FailedCallbackBlock)failed;

- (void) getProto2:(NSString *)cmd
    resultSuccess:(SuccessCallbackBlock)success
     resultFailed:(FailedCallbackBlock)failed;

- (void) postProto:(NSString *)cmd
     resultSuccess:(SuccessCallbackBlock)success
      resultFailed:(FailedCallbackBlock)failed;;



@end

NS_ASSUME_NONNULL_END
