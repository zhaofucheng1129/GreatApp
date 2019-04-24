# GreatApp

这个代码库将不断更新，用于实践优秀第三方框架的思想和原理

##简介

目前参考YYImage和Kingfisher用Swift写了一个图片加载功能，可以加载jpg、png、apng、gif、webp等图片格式

还有搜集整理的很多Extension功能 

## 截图

图片加载演示

<img src="https://raw.githubusercontent.com/zhaofucheng1129/GreatApp/master/Screenshots/20190423_025709.GIF" alt="加载本地图片演示" title="加载本地图片演示" display="inline"/><img src="https://raw.githubusercontent.com/zhaofucheng1129/GreatApp/master/Screenshots/20190424_194412.GIF" alt="加载网络图片演示" title="加载网络图片演示" display="inline"/>

字形动画演示

<img src="https://raw.githubusercontent.com/zhaofucheng1129/GreatApp/master/Screenshots/20190423_183336.GIF" alt="加载本地图片演示" title="加载本地图片演示" display="inline"/>



## Features

- 解析WebP、APNG等动图格式
- 双链表内存缓存（避免缓存污染）

## Todo

- 缓存重新绘制过的小尺寸图片
- mmap的缓存策略
- 异步显示布局界面

