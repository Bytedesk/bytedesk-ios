# 萝卜丝 · IM + 云客服

- 致力于提供稳定、可扩展、定制化的客户服务一站式平台
- [官方网站](https://www.bytedesk.com)
- [开发文档](https://github.com/bytedesk/bytedesk-ios/wiki)

## 准备工作

- [注册账号](https://www.bytedesk.com/antv/user/login)
- [登录后台](https://www.bytedesk.com/admin#/login)
- 分配应用：登录后台->客服管理->渠道管理->添加 App

## 集成 SDK

萝卜丝·云客服在经典版[微客服](http://www.weikefu.net)基础上面做了重构，将原先一个 SDK 一分为二为两个 sdk：

- 核心库：[![bytedesk-core](https://img.shields.io/badge/bytedesk--core-2.1.2-brightgreen.svg)](https://cocoapods.org/pods/bytedesk-core)
- 界面库，完全开源(Demo 中的 bdui 项目)，方便开发者自定义界面：[![bytedesk--ui](https://img.shields.io/badge/bytedesk--ui-2.1.2-brightgreen.svg)](https://cocoapods.org/pods/bytedesk-ui#bytedesk-ui-pod)
- platform :ios, '10.0'
- 开发环境: Xcode 12
- 真机调试时，请修改Scheme为release
- 技术支持QQ 3群: 825257535

## 开发文档

- [在线客服开发文档](https://github.com/bytedesk/bytedesk-ios/wiki)
  - [5 分钟集成在线客服](https://github.com/Bytedesk/bytedesk-ios/wiki/5%E5%88%86%E9%92%9F%E9%9B%86%E6%88%90%E5%9C%A8%E7%BA%BF%E5%AE%A2%E6%9C%8D)
  - [5 分钟集成工单](https://github.com/Bytedesk/bytedesk-ios/wiki/5%E5%88%86%E9%92%9F%E9%9B%86%E6%88%90%E5%B7%A5%E5%8D%95)
  - [5 分钟集成帮助中心](https://github.com/Bytedesk/bytedesk-ios/wiki/5%E5%88%86%E9%92%9F%E9%9B%86%E6%88%90%E5%B8%AE%E5%8A%A9%E4%B8%AD%E5%BF%83)
  - [5 分钟集成意见反馈](https://github.com/Bytedesk/bytedesk-ios/wiki/5%E5%88%86%E9%92%9F%E9%9B%86%E6%88%90%E6%84%8F%E8%A7%81%E5%8F%8D%E9%A6%88)
  - [5 分钟集成自定义 UI](https://github.com/Bytedesk/bytedesk-ios/wiki/5%E5%88%86%E9%92%9F%E9%9B%86%E6%88%90%E8%87%AA%E5%AE%9A%E4%B9%89UI)
- [5 分钟集成 IM](https://github.com/Bytedesk/bytedesk-ios/wiki/5%E5%88%86%E9%92%9F%E9%9B%86%E6%88%90IM)

## 其他

- [iOS SDK](https://github.com/bytedesk/bytedesk-ios)
- [Android SDK](https://github.com/bytedesk/bytedesk-android)
- [Web 端接口](https://github.com/bytedesk/bytedesk-web)
- [微信公众号/小程序接口](https://github.com/bytedesk/bytedesk-wechat)
- [服务器端接口](https://github.com/bytedesk/bytedesk-server)
- [机器人](https://github.com/bytedesk/bytedesk-chatbot)

## 截图

<!-- 
<img src="./img/1.png" width="25%" height="25%"/>
<img src="./img/2.png" width="25%" height="25%"/>
<img src="./img/3.png" width="25%" height="25%"/>
<img src="./img/4.png" width="25%" height="25%"/>
<img src="./img/5.png" width="25%" height="25%"/>
<img src="./img/6.png" width="25%" height="25%"/>
<img src="./img/7.png" width="25%" height="25%"/> -->

| image1 | image2 | image3 |
| :----------: | :----------: | :----------: |
| <img src="./img/home.jpeg?raw=true" width="250"> | <img src="./img/robot.jpeg?raw=true" width="250"> | <img src="./img/notice.jpeg?raw=true" width="250"> |
| <img src="./img/chat.png?raw=true" width="250"> | <img src="./img/status.jpeg?raw=true" width="250"> |<img src="./img/userinfo.jpeg?raw=true" width="250"> |

