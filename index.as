// 文档参考
// https://www.cnblogs.com/savageworld/archive/2006/07/28/462434.html
// https://www.oschina.net/uploads/doc/flex-doc-3.2/flash/net/NetStream.html

import mx.utils.Base64Encoder;
import mx.graphics.codec.JPEGEncoder;

var nc = null;
var ns = null;
var serverName;
var streamName;

var console = {
  info: function(value) {
    ExternalInterface.call("console.info", value);
  },
  log: function(value) {
    ExternalInterface.call("console.log", value);
  },
  error: function(value) {
    ExternalInterface.call("console.error", value);
  }
};

function createLiveStream() {
  nc = new NetConnection();
  nc.addEventListener(NetStatusEvent.NET_STATUS, function(event) {
    console.info("nc: " + event.info.code);
    if (event.info.code == "NetConnection.Connect.Success") {
      ns = new NetStream(nc);
      ns.addEventListener(NetStatusEvent.NET_STATUS, function(event) {
        console.info("ns: " + event.info.code);
      });
      var nsClientObj = new Object();
      ns.client = nsClientObj;
      ns.bufferTime = 3; // 3秒不会卡
      ns.play(streamName);
      videoObj.attachNetStream(ns);
    }
  });
  nc.connect(serverName);
}

function destoryLiveStream() {
  if (ns != null) {
    ns.close();
    ns = null;
  }
  if (nc != null) {
    nc.close();
    nc = null;
  }
}

// 不做校验，自己调用出不可能出问题
function startLive(server, stream) {
  serverName = server;
  streamName = stream;
  destoryLiveStream();
  createLiveStream();
}


function shot() {
     var matrix:Matrix = new Matrix();
   matrix.scale(5, 4);
   
  var imager = new BitmapData(800, 450, true, 0);
  imager.draw(videoObj, matrix);



  var e = new JPEGEncoder(100);  
  var actual_IMG = e.encode(imager);

  var b64 = new Base64Encoder();
  b64.encodeBytes(actual_IMG);
  // Ouzzplayer
  ExternalInterface.call("Ouzzplayer.shot", b64.toString());

}

// TODO
// function pause() {}

startLive("rtmp://cyberplayerplay.kaywang.cn/cyberplayer/", "demo201711-L1");

try {
  ExternalInterface.addCallback("startLive", startLive);
  ExternalInterface.addCallback("stopLive", destoryLiveStream);
  ExternalInterface.addCallback("shot", shot);
} catch (err) {
  console.error(err);
}
