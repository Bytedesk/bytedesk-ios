//
//  KFDSInputEmotionParser.m
//  feedback
//
//  Created by 萝卜丝 on 2018/2/22.
//  Copyright © 2018年 萝卜丝. All rights reserved.
//

#import "KFDSInputEmotionParser.h"
#import "KFDSInputEmotionManager.h"

@implementation KFDSInputTextToken
@end

@interface KFDSInputEmotionParser ()

@property (nonatomic,strong)    NSCache *tokens;

@end


@implementation KFDSInputEmotionParser

+ (instancetype)currentParser
{
    static KFDSInputEmotionParser *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[KFDSInputEmotionParser alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    if (self = [super init])
    {
        _tokens = [[NSCache alloc] init];
    }
    return self;
}

- (NSArray *)tokens:(NSString *)text
{
    NSArray *tokens = nil;
    if ([text length])
    {
        tokens = [_tokens objectForKey:text];
        if (tokens == nil)
        {
            tokens = [self parseToken:text];
            [_tokens setObject:tokens
                        forKey:text];
        }
    }
    return tokens;
}

- (NSArray *)parseToken:(NSString *)text
{
    NSMutableArray *tokens = [NSMutableArray array];
    
    NSRegularExpression *exp = [NSRegularExpression regularExpressionWithPattern:@"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]"
                                                                         options:NSRegularExpressionCaseInsensitive
                                                                           error:nil];
    __block NSInteger index = 0;
    [exp enumerateMatchesInString:text
                          options:0
                            range:NSMakeRange(0, [text length])
                       usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
                           NSString *rangeText = [text substringWithRange:result.range];
                           if ([[KFDSInputEmotionManager sharedManager] emotionByText:rangeText])
                           {
                               if (result.range.location > index)
                               {
                                   NSString *rawText = [text substringWithRange:NSMakeRange(index, result.range.location - index)];
                                   KFDSInputTextToken *token = [[KFDSInputTextToken alloc] init];
                                   token.type = KFDSInputTokenTypeText;
                                   token.text = rawText;
                                   [tokens addObject:token];
                               }
                               KFDSInputTextToken *token = [[KFDSInputTextToken alloc] init];
                               token.type = KFDSInputTokenTypeEmoticon;
                               token.text = rangeText;
                               [tokens addObject:token];
                               
                               index = result.range.location + result.range.length;
                           }
                       }];
    
    if (index < [text length])
    {
        NSString *rawText = [text substringWithRange:NSMakeRange(index, [text length] - index)];
        KFDSInputTextToken *token = [[KFDSInputTextToken alloc] init];
        token.type = KFDSInputTokenTypeText;
        token.text = rawText;
        [tokens addObject:token];
    }
    
    return tokens;
}


@end
