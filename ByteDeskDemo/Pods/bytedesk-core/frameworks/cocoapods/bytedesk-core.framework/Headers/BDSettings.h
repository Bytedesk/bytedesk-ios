//
//  KFDSCSettings.h
//  bdcore
//
//  Created by 萝卜丝 on 2018/11/23.
//  Copyright © 2018年 Bytedesk.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#define BD_USERNAME               @"bd_username"
#define BD_UID                    @"bd_uid"
#define BD_NICKNAME               @"bd_nickname"
#define BD_AVATAR                 @"bd_avatar"
#define BD_ROLE                   @"bd_role"
#define BD_APPKEY                 @"bd_appkey"
#define BD_SUBDOMAIN              @"bd_subdomain"

#define BD_PASSPORT_ACCESS_TOKEN  @"bd_access_token"
#define BD_PASSPORT_EXPIRES_IN    @"bd_expires_in"
#define BD_PASSPORT_REFRESH_TOKEN @"bd_refresh_token"
#define BD_PASSPORT_TOKEN_TYPE    @"bd_token_type"


@interface BDSettings : NSObject

+ (BOOL)isVisitor;

+ (NSString *)getClient;

+ (NSString *)getUsername;

+ (void)setUsername:(NSString *)username;

+ (NSString *)getUid;

+ (void)setUid:(NSString *)uid;

+ (NSString *)getNickname;

+ (void)setNickname:(NSString *)nickname;

+ (NSString *)getAvatar;

+ (void)setAvatar:(NSString *)avatar;

+ (NSString *)getRole;

+ (void)setRole:(NSString *)role;

+ (NSString *)getAppkey;

+ (void)setAppkey:(NSString *)appkey;

+ (NSString *)getSubdomain;

+ (void)setSubdomain:(NSString *)subdomain;

+ (NSString *)getPassportAccessToken;

+ (void)setPassportAccessToken:(NSString *)accessToken;

+ (NSString *)getPassportExpiresIn;

+ (void)setPassportExpiresIn:(NSString *)expiresIn;

+ (NSString *)getPassportRefreshToken;

+ (void)setPassportRefreshToken:(NSString *)refreshToken;

+ (NSString *)getPassportTokenType;

+ (void)setPassportTokenType:(NSString *)tokenType;

@end





