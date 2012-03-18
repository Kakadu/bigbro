import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Loader;
import flash.display.PixelSnapping;
import flash.display.Sprite;
import flash.display.MovieClip;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.IOErrorEvent;
import flash.net.URLRequest;
import haxe.Timer;

class Main {
  private static var newWidth: Null<Int> = null;
  private static var newHeight: Null<Int> = null;
  private static var pictureUrl = null;
  private static var timer : Timer = null;
  private static var root: MovieClip = null;
  private static var container: MovieClip = null;
  private static var loader: Loader = null;
  private static var loader2: Loader = null;
  private static var interval = 2000;

  static function imageLoaded(event) {
    try {
      //      trace("root.numChildren = " + root.numChildren);
      if ((loader != null) && root.contains(loader))
        root.removeChild(loader);
      if (loader != null)
        loader.visible = true;
      loader2.visible = true;
      loader = loader2;
      loader.x = loader.y = 0;
      loader.width = newWidth;
      loader.height = newHeight;
      timer = haxe.Timer.delay(loadImage,interval);
    } catch (err: Dynamic) {
      trace(err);
    }
  }
  static function loadImage() {
    //trace("loading...");
    //movieClipLoader.loadClip(pictureUrl, container);
    //    loader.addEventListener
    
    loader2 = new Loader();
    root.addChild(loader2);
    loader2.contentLoaderInfo.addEventListener(Event.COMPLETE, imageLoaded);
    loader2.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, loadError);
    loader2.load(new URLRequest(pictureUrl));    
  }
  static function loadError(event) {
    trace("Unable to load image: " + event);
  }
  static function main() {
    try {
      var params = flash.Lib.current.loaderInfo.parameters;      
      pictureUrl = params.data;
      trace ("picture = " + pictureUrl);
      root = flash.Lib.current;
      newWidth  = flash.Lib.current.stage.stageWidth;
      newHeight = flash.Lib.current.stage.stageHeight;
      container = new MovieClip();
      container.width = newWidth;
      container.height = newHeight;
      interval = params.timeout;
      //timer = new Timer(params.timeout);
      //timer.run = loadImage;
      loadImage();
    } catch (error: Dynamic) {
      trace("fatal error");
      trace(error);
    }
  }
}