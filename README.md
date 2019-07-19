# rtmp-player

rtmp 流直播定制 flash 播放器

## 为什么要自己写播放器

- 坑爹的videojs flash版本不支持wowza的安全认证
- aliplayer 对rtmp的流不友好，出错整个播放器就cash，而且他们还悄悄的埋点了，自家的数据被阿里能捕获到就很不开心了
- jwplayer 要钱，而且开发很麻烦，对flash这块的支持越来越低，文档也不全了
- 其他百度云等等等云厂商的播放器大部分基于videojs或者老版本jwplayer，不好用
- 剩下的都是h5播放器，不支持rtmp

## 开发

- animate cc
- flex_sdk_4.6

## 特性

- video smoothing 播放更顺滑
- 良好适配 wowza
- 支持截图 base64

# 接口

```js
startLive(server, stream)
stopLive()
snapshot() // 截图完成后会调用 Ouzzplayer.snapshot(base64)
pause() // 暂停，因为是直播流，暂停后不提供续播的功能
```
