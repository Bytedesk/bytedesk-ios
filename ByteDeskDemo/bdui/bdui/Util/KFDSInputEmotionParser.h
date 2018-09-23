//
//  KFDSInputEmotionParser.h
//  feedback
//
//  Created by 宁金鹏 on 2017/2/22.
//  Copyright © 2017年 宁金鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger
{
    KFDSInputTokenTypeText,
    KFDSInputTokenTypeEmoticon,
    
} KFDSInputTokenType;

@interface KFDSInputTextToken : NSObject

@property (nonatomic,copy)      NSString    *text;

@property (nonatomic,assign)    KFDSInputTokenType   type;

@end


@interface KFDSInputEmotionParser : NSObject

+ (instancetype)currentParser;

- (NSArray *)tokens:(NSString *)text;

@end
