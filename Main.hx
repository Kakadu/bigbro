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
  private static var busy = false;
  /*  private static var testUrl1 = 
    "http://www.freewallpapersbase.com/video-game/wallpapers2/TheWitcher001-wallpaper.jpg";
  private static var testUrl2 = 
    "http://3.bp.blogspot.com/_e73TLiIh1yU/TOVy6XsFLzI/AAAAAAAAAps/xlFHnYstCHQ/s1600/scr2_big.jpg";
  */
  private static var urlCounter = 1;

  static function imageLoaded(event) {
    try {
      //trace("root.numChildren = " + root.numChildren);
      if ((loader != null) && root.contains(loader))
        root.removeChild(loader);
      loader = loader2;
      loader.x = loader.y = 0;
      loader.width = newWidth;
      loader.height = newHeight;
    } catch (err: Dynamic) {
      trace(err);
    }
    busy = false;
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
      newWidth = params.newWidth;
      newHeight = params.newHeight;
      pictureUrl = params.data;
      trace ("picrture = " + pictureUrl);
      root = flash.Lib.current;
      container = new MovieClip();
      container.width = newWidth;
      container.height = newHeight;
      //root.width = newWidth;
      //root.height = newHeight;
      timer = new Timer(2000);
      timer.run = loadImage;
    } catch (error: Dynamic) {
      trace("fatal error");
      trace(error);
    }
  }
}