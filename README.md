# rtmp-player

rtmp 流直播定制 flash 播放器

## 为什么要自己写播放器

- videojs-flash 不支持 wowza 的安全认证
- aliplayer 对 rtmp 的流不友好，出错整个播放器无法自动重连，而且他们做了埋点
- jwplayer 要钱，而且开发很麻烦，对 flash 这块的支持越来越低，文档也不全了
- 其他百度云等等等云厂商的播放器大部分基于 videojs 不好用
- 剩下的都是 h5 播放器，不支持 rtmp

## 开发环境

- animate cc
- flex_sdk_4.6

## 特性

- 良好适配 wowza
- 支持截图 base64

## 使用

```html
<object
  type="application/x-shockwave-flash"
  data="index.swf"
  width="100%"
  height="100%"
  id="app"
  bgcolor="#000000"
>
  <param name="allowfullscreen" value="true" />
  <param name="allowscriptaccess" value="always" />
  <param name="wmode" value="opaque" />
  <param name="menu" value="false" />
</object>
```

```js
// 因为加载 swf 是异步操作，需要等待swf加载完成后才能进行调用
// 但是因为 swf 文件的 onload 并不会调用
// 解决办法有两种
// 1 在 swf 里面调用一个 js 方法通知(考虑到在react组件中使用，暂无实现)
// 2 用定时器判断加载状态
const app = document.getElementById("app");
let timer = null;
const canPlay = new Promise((res, rej) => {
  timer = setInterval(() => {
    try {
      if (app.PercentLoaded() === 100) {
        clearInterval(timer); // 加载完成
        res();
      }
    } catch (e) {}
  }, 50);
});

canPlay.then(() => {
  app.startLive(
    "rtmp://cyberplayerplay.kaywang.cn/cyberplayer/",
    "demo201711-L1"
  );
});
```

```js
// 播放 rtmp 流
const app = document.getElementById("app");
app.startLive(
  "rtmp://cyberplayerplay.kaywang.cn/cyberplayer/",
  "demo201711-L1"
);
```

```js
// base64 截图
const app = document.getElementById("app");
const Ouzzplayer = {
  snapshot(str) {
    const bs64 = `data:image/jpeg;base64,${str}`;
    console.log(bs64);
  }
};
app.snapshot();
```

```js
// 停止直播
app.stopLive();
```

```js
// 暂停直播，因为是直播流，暂停后不提供续播的功能
app.pause();
```

```js
// rtmp 流状态 用于封装开发做 loading 或者显示播放状态

"NetConnection.Connect.Success"; //服务器连接成功
"NetConnection.Connect.Closed"; //连接中断
"NetConnection.Connect.Failed"; //连接失败"
"NetConnection.Connect.Rejected"; //没有权限"
"NetStream.Play.Reset"; //播放列表重置"
"NetStream.Play.Start"; //播放开始"
"NetStream.Buffer.Empty"; //视频正在缓冲"
"NetStream.Buffer.Full"; //缓冲区已填满"
"NetStream.Play.StreamNotFound"; //找不到此视频");
"NetStream.Play.Stop"; //视频播放完成");
"NetStream.Pause.Notify"; //流已暂停"
"NetStream.Unpause.Notify"; //流已恢复"
"NetStream.Seek.Failed"; //搜寻失败"
"NetStream.SeekStart.Notify"; //搜寻开始"
"NetStream.Seek.Notify"; //正在搜寻……"
"NetStream.Seek.Complete"; //搜寻完毕"
"NetStream.Publish.Start"; //发布开始"
"NetStream.Unpublish.Success"; //停止发布"
"NetStream.Record.Start"; //开始录制"
"NetStream.Record.Stop"; //停止录制"
"NetStream.Publish.BadName"; //警告！试图发布已经被他人发布的流"
"NetStream.Play.PublishNotify"; //发布开始，信息已经发送到所有订阅者"); //测试发布端有没在发布
"NetStream.Play.UnpublishNotify"; //发布停止，信息已经发送到所有订阅者"); //测试发布端是否停止了发布
"NetStream.Play.InsufficientBW"; //警告！客户端没有足够的带宽，无法以正常速度播放数据"
```
