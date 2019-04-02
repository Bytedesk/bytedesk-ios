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
#define BD_REALNAME               @"bd_realname"
#define BD_PASSWORD               @"bd_password"
#define BD_AVATAR                 @"bd_avatar"
#define BD_ROLE                   @"bd_role"
#define BD_APPKEY                 @"bd_appkey"
#define BD_SUBDOMAIN              @"bd_subdomain"
#define BD_DESCRIPTION            @"bd_description"
#define BD_ACCEPTSTATUS           @"bd_acceptstatus"
#define BD_AUTOREPLYCONTENT       @"bd_autoreplycontent"
#define BD_STATUS                 @"bd_status"
#define BD_CURRENT_TID            @"bd_current_tid"
#define BD_DEVICE_TOKEN           @"bd_device_token"

#define BD_IS_ALREADY_LOGIN       @"bd_is_already_login"

#define BD_PASSPORT_ACCESS_TOKEN  @"bd_access_token"
#define BD_PASSPORT_EXPIRES_IN    @"bd_expires_in"
#define BD_PASSPORT_REFRESH_TOKEN @"bd_refresh_token"
#define BD_PASSPORT_TOKEN_TYPE    @"bd_token_type"


@interface BDSettings : NSObject

+ (BOOL)loginAsVisitor;

/**
 @deprecated 请使用 isAlreadyLogin
 @return boolean
 */
+ (BOOL)getIsAlreadyLogin DEPRECATED_ATTRIBUTE;

+ (BOOL)isAlreadyLogin;

+ (NSString *)getClient;

+ (NSString *)getSubdomain;

+ (void)setSubdomain:(NSString *)subdomain;

+ (NSString *)getUsername;

+ (void)setUsername:(NSString *)username;

+ (NSString *)getUid;

+ (void)setUid:(NSString *)uid;

+ (NSString *)getNickname;

+ (void)setNickname:(NSString *)nickname;

+ (NSString *)getRealname;

+ (void)setRealname:(NSString *)realname;

+ (NSString *)getPassword;

+ (void)setPassword:(NSString *)password;

+ (NSString *)getAvatar;

+ (void)setAvatar:(NSString *)avatar;

+ (NSString *)getRole;

+ (void)setRole:(NSString *)role;

+ (NSString *)getAppkey;

+ (void)setAppkey:(NSString *)appkey;

+ (NSString *)getDescription;

+ (void)setDescription:(NSString *)description;

+ (NSString *)getAcceptStatus;

+ (void)setAcceptStatus:(NSString *)acceptStatus;

+ (NSString *)getAutoReplyContent;

+ (void)setAutoReplyContent:(NSString *)autoreply;

+ (NSString *)getStatus;

+ (void)setStatus:(NSString *)status;

+ (NSString *)getCurrentTid;

+ (void)setCurrentTid:(NSString *)tid;

+ (NSString *)getPassportAccessToken;

+ (void)setPassportAccessToken:(NSString *)accessToken;

+ (NSString *)getPassportExpiresIn;

+ (void)setPassportExpiresIn:(NSString *)expiresIn;

+ (NSString *)getPassportRefreshToken;

+ (void)setPassportRefreshToken:(NSString *)refreshToken;

+ (NSString *)getPassportTokenType;

+ (void)setPassportTokenType:(NSString *)tokenType;

+ (NSString *)getDeviceToken;

+ (void)setDeviceToken:(NSString *)deviceToken;

+ (void)clear;

//////////////////////////////////////

+ (BOOL)getDestroyAfterReading:(NSString *)tidOrUidOrGid sessionType:(NSString *)sessionType;

+ (void)setDestroyAfterReading:(NSString *)tidOrUidOrGid sessionType:(NSString *)sessionType flag:(BOOL)flag;

+ (NSInteger)getDestroyAfterLength:(NSString *)tidOrUidOrGid sessionType:(NSString *)sessionType;

+ (void)setDestroyAfterLength:(NSString *)tidOrUidOrGid sessionType:(NSString *)sessionType length:(NSInteger)length;




@end





