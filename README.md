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

- 核心库：[![bytedesk-core](https://img.shields.io/badge/bytedesk--core-1.0.5-brightgreen.svg)](https://cocoapods.org/pods/bytedesk-core)
- 界面库，完全开源(Demo中的bdui项目)，方便开发者自定义界面：[![bytedesk--ui](https://img.shields.io/badge/bytedesk--ui-1.0.6-brightgreen.svg)](https://cocoapods.org/pods/bytedesk-ui#bytedesk-ui-pod)

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

## 引入头文件

- #import <bytedesk-core/bdcore.h>
- #import <bytedesk-ui/bdui.h>

## AppDelegate.m 中调用登录接口

- 获取appkey：登录后台->所有设置->应用管理->APP->appkey列
- 获取subDomain，也即企业号：登录后台->所有设置->客服账号->企业号

> 登录接口，默认用户名登录，系统自动生成一串数字作为用户名，其中appkey和企业号需要替换为真实值

```c++
// 访客登录
[BDCoreApis visitorLoginWithAppkey:@"appkey" withSubdomain:@"企业号" resultSuccess:^(NSDictionary *dict) {
        // 登录成功
        NSLog(@"%s, %@", __PRETTY_FUNCTION__, dict);
    } resultFailed:^(NSError *error) {
        // 登录失败
        NSLog(@"%s, %@", __PRETTY_FUNCTION__, error);
    }];
```

## 开始会话

- 获取uId: 登录后台->所有设置->客服账号->超级管理员用户的：唯一ID(uId)
- 获取wId: 登录后台->所有设置->工作组->超级管理员用户的：唯一ID(wId)

两种打开窗口方式，

- push方式
- present方式

> push方式打开会话窗口，参数：uId代表管理员uId, wId代表工作组wId，会话窗口导航继承自第一个参数

```c++
[BDUIApis visitorPushChat:self.navigationController uId:@"" wId:@"" withTitle:@"默认标题"];
```

> present方式打开会话窗口，参数：uId代表管理员uId, wId代表工作组wId，会话窗口导航继承自第一个参数

```c++
[BDUIApis visitorPresentChat:self.navigationController uId:@"" wId:@"" withTitle:@"默认标题"];
```

## 用户信息接口 (可选)

总共有三个相关接口：

- 获取用户信息接口：获取用户昵称，以及key/value信息对
- 设置用户昵称接口：设置用户昵称，可在客服端显示
- 设置用户任意信息接口：自定义key/value设置用户信息，可在客服端显示查看

> 获取用户信息

```c++
[BDCoreApis visitorGetUserinfoWithUid:[BDSettings getUid] resultSuccess:^(NSDictionary *dict) {
    NSLog(@"%s, %@, %@", __PRETTY_FUNCTION__, dict, dict[@"data"][@"nickname"]);
    NSString *nickname = dict[@"data"][@"nickname"];
    NSMutableArray *fingerPrints = dict[@"data"][@"fingerPrints"];
    for (NSDictionary *fingerPrint in fingerPrints) {
        // NSLog(@"%@ %@", fingerPrint[@"key"], fingerPrint[@"value"]);
        if ([fingerPrint[@"key"] isEqualToString:self.mTagkey]) {
            self.mTagvalue = fingerPrint[@"value"];
        }
    }
} resultFailed:^(NSError *error) {
    NSLog(@"%@", error);
}];
```

> 设置用户昵称接口 (可选)

```c++
[BDCoreApis visitorSetNickname:self.mNickname resultSuccess:^(NSDictionary *dict) {
    //
} resultFailed:^(NSError *error) {
    NSLog(@"%s %@", __PRETTY_FUNCTION__, error);
}];
```

> 设置用户任意信息接口 (可选)

```c++
[BDCoreApis visitorSetUserinfo:@"自定义标签" withKey:self.mTagkey withValue:self.mTagvalue resultSuccess:^(NSDictionary *dict) {
    //
} resultFailed:^(NSError *error) {
    NSLog(@"%s %@", __PRETTY_FUNCTION__, error);
}];
```

## 在线状态接口 (可选)

提供两个接口：

- 查询某个工作组id的在线状态
- 查询某个客服uId的在线状态（获取uId: 登录后台->所有设置->客服账号->客服：唯一ID(uId)）

> 获取某个工作组的在线状态：1代表在线，注意需要替换真实参数

```c++
// 查询工作组在线状态
[BDCoreApis visitorGetWorkGroupStatus:@"201807171659201" resultSuccess:^(NSDictionary *dict) { 
    NSString *wId = dict[@"data"][@"wid"];
    NSString *status = dict[@"data"][@"status"];
    NSLog(@"wid: %@, status:%@", wId, status);
    // self.mWorkgroupStatus = status;
    //
} resultFailed:^(NSError *error) {
    NSLog(@"%@", error);
}];
```

> 获取某个客服uId的在线状态：注意需要替换真实参数

```c++
// 查询客服账号在线状态
[BDCoreApis visitorGetAgentStatus:@"201808221551193" resultSuccess:^(NSDictionary *dict) {
    //
    NSString *uId = dict[@"data"][@"uid"];
    NSString *status = dict[@"data"][@"status"];
    NSLog(@"uid: %@, status:%@", uId, status);
    // self.mAgentStatus = status;
    //
} resultFailed:^(NSError *error) {
    NSLog(@"%@", error);
}];
```

## 历史会话接口 (可选)

> 支持获取用户的所有历史会话

```c++
[BDCoreApis visitorGetThreadsPage:0 resultSuccess:^(NSDictionary *dict) {
    //
} resultFailed:^(NSError *error) {
    NSLog(@"%s, %@", __PRETTY_FUNCTION__, error);
}];
```

## 更新日志

> 2018-11-07

- 优化在线状态接口

> 2018-10-24

- 优化消息体

> 2018-10-11

- 优化bytedesk-ui库

> 2018-10-06

- 更新wap参数

> 2018-10-02

- 增加APP内嵌入wap演示

> 2018-09-23

- 新平台上线
