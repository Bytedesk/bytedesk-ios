#  bytedesk-ui

## appledoc使用指南

- http://ios.jobbole.com/92295/

## 生成文档

- 切换到文件夹： cd /Users/ningjinpeng/Desktop/GitOSChina/bytedeskios/bdui
- 生成html文档： appledoc --no-create-docset --output ./docs --project-name bytedesk-ui --project-company bytedesk.com --company-id bytedesk.com .

## 注释类型

/// Single line comment.

/// Single line comment spreading
/// over multiple lines.

/** Single line comment. */

/*! Single line comment */

/** 
* Single line comment spreading
* over multiple lines.
*/

/** 
Single line comment spreading
over multiple lines. No star
*/

command + option + / 方便快捷地生成注释
