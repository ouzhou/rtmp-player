import mx.utils.Base64Encoder;
import mx.graphics.codec.JPEGEncoder;

var nc = null;
var ns = null;
var serverName;
var streamName;

function log(value) {
  try {
    ExternalInterface.call("console.log", value);
  } catch (err) {
    // empty
  }
}

var videoObj = new Video(800, 450);
videoObj.smoothing = true;

function createLiveStream() {
  nc = new NetConnection();
  nc.client = this;
  nc.addEventListener(NetStatusEvent.NET_STATUS, function(event) {
    log("nc: " + event.info.code);
    if (event.info.code == "NetConnection.Connect.Success") {
      ns = new NetStream(nc);
      ns.addEventListener(NetStatusEvent.NET_STATUS, function(event) {
        log("ns: " + event.info.code);
      });
      var nsClientObj = new Object();
      ns.client = nsClientObj;
      ns.bufferTime = 3; // 3秒不会卡
      ns.play(streamName);
      videoObj.attachNetStream(ns);
      addChild(videoObj);
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

function startLive(server, stream) {
  serverName = server;
  streamName = stream;
  destoryLiveStream();
  createLiveStream();
}

function snapshot() {
  var imager = new BitmapData(800, 450, true, 0);
  imager.draw(videoObj);

  var e = new JPEGEncoder(100);
  var actual_IMG = e.encode(imager);

  var b64 = new Base64Encoder();
  b64.encodeBytes(actual_IMG);

  try {
    ExternalInterface.call("Ouzzplayer.snapshot", b64.toString());
  } catch (err) {
    // empty
  }
}

function pause() {
  if (ns != null) {
    ns.pause();
  }
}

try {
  ExternalInterface.addCallback("startLive", startLive);
  ExternalInterface.addCallback("stopLive", destoryLiveStream);
  ExternalInterface.addCallback("snapshot", snapshot);
  ExternalInterface.addCallback("pause", pause);
} catch (err) {
   // empty
}

// startLive("rtmp://cyberplayerplay.kaywang.cn/cyberplayer/", "demo201711-L1");
