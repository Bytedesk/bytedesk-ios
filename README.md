# 萝卜丝·云客服

- 致力于提供稳定、可扩展、定制化的客户服务一站式平台
- [官方网站](https://www.bytedesk.com)
- [开发文档](https://www.bytedesk.com/support/article?uid=201808221551193&aid=201808252118461)

## 准备工作

- [注册账号](https://www.bytedesk.com/admin#/register)
- [登录后台](https://www.bytedesk.com/admin#/login)
- 分配应用：登录后台->所有设置->应用管理->APP

## 集成SDK

萝卜丝·云客服在经典版[微客服](http://www.weikefu.net)基础上面做了重构，将原先一个SDK一分为二为两个sdk：

- 核心库：[![bytedesk-core](https://img.shields.io/badge/bytedesk--core-1.1.1-brightgreen.svg)](https://cocoapods.org/pods/bytedesk-core)
- 界面库，完全开源(Demo中的bdui项目)，方便开发者自定义界面：[![bytedesk--ui](https://img.shields.io/badge/bytedesk--ui-1.1.4-brightgreen.svg)](https://cocoapods.org/pods/bytedesk-ui#bytedesk-ui-pod)

开发环境：

- Xcode Version 9.3 (9E145)
- CocoaPods 1.5.0

萝卜丝·云客服提供四种集成方法：

- 完全基于pod的方式(推荐，参考：ByteDeskDemo)
- 半依赖pod集成方式，添加开源bdui项目，方便自定义ui（参考：ByteDeskDemo）
- 项目中添加framework的方式
- 不依赖于cocoapod方式

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

> 第四种方式：不依赖于cocoapods, 具体也可参考：示例 ByteDeskDemoFramework，注：默认demo可以运行在模拟器，如果要在真机运行，请在ByteDeskDemoFramework/vendors-device文件夹下复制相关frameworks替换到ByteDeskDemoFramework/frameworks/vendors; 如果要在模拟器运行，请复制ByteDeskDemoFramework/vendors-simulator文件夹下复制相关frameworks到替换到ByteDeskDemoFramework/frameworks/vendors

## 开发文档

- [IM开发文档](https://github.com/pengjinning/bytedesk-ios/wiki/IM%E5%BC%80%E5%8F%91%E6%96%87%E6%A1%A3)
- [在线客服开发文档](https://github.com/pengjinning/bytedesk-ios/wiki/%E5%9C%A8%E7%BA%BF%E5%AE%A2%E6%9C%8D%E5%BC%80%E5%8F%91%E6%96%87%E6%A1%A3)

## 更新日志

> 2018-12-05

- 支持bitcode

> 2018-12-04

- 增加客服端接口

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
