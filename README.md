# 萝卜丝·云客服

- 致力于提供强大、稳定、灵活、可扩展、定制化的客户服务一站式平台
- [官方网站](https://www.bytedesk.com)
- [开发文档](https://www.bytedesk.com/support/article?uid=201808221551193&aid=201808252118461)

## 准备工作

- [注册账号](https://www.bytedesk.com/admin#/register)
- [登录后台](https://www.bytedesk.com/admin#/login)
- 分配应用：登录后台->所有设置->应用管理->APP

## 集成SDK

萝卜丝·云客服在经典版[微客服](http://www.weikefu.net)基础上面做了重构，将原先一个SDK一分为二为两个sdk：

- 核心库：
- 界面库，完全开源(Demo中的bdui项目)，方便开发者自定义界面：

开发环境：

- Xcode Version 9.3 (9E145)
- CocoaPods 1.5.0

萝卜丝·云客服提供三种集成方法：

- 完全基于pod的方式(推荐，参考：ByteDeskDemo)
- 半依赖pod集成方式，添加开源bdui项目，方便自定义ui（参考：ByteDeskDemo）
- 项目中添加framework的方式

> 第一种方式：完全依赖pod集成，在Podfile中添加如下：

```c++
pod 'FMDB'
pod 'MQTTClient'
pod 'AFNetworking'
pod 'QMUIKit'
pod 'M80AttributedLabel'
pod 'HCSStarRatingView'

pod 'bytedesk-ui'
pod 'bytedesk-core'
```

> 第二种方式：支持自定义界面。首先添加bdui到自己项目中，然后将其添加为项目的依赖，在Podfile中添加如下：

```c++
pod 'FMDB'
pod 'MQTTClient'
pod 'AFNetworking'
pod 'QMUIKit'
pod 'M80AttributedLabel'
pod 'HCSStarRatingView'

pod 'bytedesk-core'
```

> 第三种方式：分别添加bytedesk-core.framework，bytedesk-ui.framework到自己项目中，然后在项目Build Settings中搜索Framework Search Paths, 并将上述两个framework所在路径的文件夹添加进去，如UseLocalFrameworkDemo中：$(PROJECT_DIR)/demo/frameworks，在Podfile中添加如下：

```c++
pod 'FMDB'
pod 'MQTTClient'
pod 'AFNetworking'
pod 'QMUIKit'
pod 'M80AttributedLabel'
pod 'HCSStarRatingView'
```

## 登录接口

`获取Appkey和Subdomain：登录后台->所有设置->应用管理->APP`

> 首先引入头文件：
> 接口一：默认用户名登录，系统自动生成一串数字作为用户名

```c++
// 访客登录
[BDCoreApis visitorLoginWithAppkey:DEFAULT_TEST_APPKEY withSubdomain:DEFAULT_TEST_SUBDOMAIN resultSuccess:^(NSDictionary *dict) {
        // 登录成功
        NSLog(@"%s, %@", __PRETTY_FUNCTION__, dict);
    } resultFailed:^(NSError *error) {
        // 登录失败
        NSLog(@"%s, %@", __PRETTY_FUNCTION__, error);
    }];
```

## 用户信息接口

总共有三个相关接口：

- 获取用户信息接口：获取用户昵称，以及key/value信息对
- 设置用户昵称接口：设置用户昵称，可在客服端显示
- 设置用户任意信息接口：自定义key/value设置用户信息，可在客服端显示查看

> 获取用户信息

```c++
[WXCoreApis visitorGetUserinfoSuccess:^(NSDictionary *dict) {
    NSLog(@"%s, %@, %@", __PRETTY_FUNCTION__, dict, dict[@"data"][@"nickname"]);
    self.mNickname = dict[@"data"][@"nickname"];
    NSMutableArray *tags = dict[@"data"][@"tags"];
    for (NSDictionary *tag in tags) {
        NSLog(@"%@ %@", tag[@"key"], tag[@"value"]);
        if ([tag[@"key"] isEqualToString:self.mTagkey]) {
            // self.mTagvalue = tag[@"value"];
        }
    }
} resultFailed:^(NSError *error) {
    NSLog(@"%@", error);
}];
```

> 设置用户昵称接口

```c++
[WXCoreApis visitorSetNickname:self.mNickname resultSuccess:^(NSDictionary *dict) {
    //
} resultFailed:^(NSError *error) {
    NSLog(@"%s %@", __PRETTY_FUNCTION__, error);
}];
```

> 设置用户任意信息接口

```c++
[WXCoreApis visitorSetUserinfo:self.mTagkey withValue:self.mTagvalue resultSuccess:^(NSDictionary *dict) {
    //
} resultFailed:^(NSError *error) {
    NSLog(@"%s %@", __PRETTY_FUNCTION__, error);
}];
```

## 在线状态接口

提供两个接口：

- 查询某个客服账号的在线状态
- 查询某个工作组id的在线状态

> 获取某个客服账号的在线状态：online代表在线，offline代表离线

```c++
// 查询工作组在线状态
[WXCoreApis visitorGetWorkgroupStatus:self.mDefaultWorkgroupId resultSuccess:^(NSDictionary *dict) {
    NSString *workgroupId = dict[@"data"][@"workgroup_id"];
    // 注：online代表在线，offline代表离线
    NSString *status = dict[@"data"][@"status"];
    NSLog(@"id: %@, status:%@", workgroupId, status);
    self.mWorkgroupStatus = status;
} resultFailed:^(NSError *error) {
    NSLog(@"%@", error);
}];
```

> 获取某个工作组的在线状态：online代表在线，offline代表离线

```c++
// 查询客服账号在线状态
[WXCoreApis visitorGetAgentStatus:self.mDefaultAgentname resultSuccess:^(NSDictionary *dict) {
    NSString *agentname = dict[@"data"][@"agent"];
    // 注：online代表在线，offline代表离线
    NSString *status = dict[@"data"][@"status"];
    NSLog(@"agent:%@, status:%@", agentname, status);
} resultFailed:^(NSError *error) {
    NSLog(@"%@", error);
}];
```

## 历史会话接口

支持获取用户的所有历史会话

```c++
[WXCoreApis visitorGetThreadsSuccess:^(NSDictionary *dict) {
//  NSLog(@"%s, %@", __PRETTY_FUNCTION__, dict);
} resultFailed:^(NSError *error) {
    NSLog(@"%s, %@", __PRETTY_FUNCTION__, error);
}];
```
