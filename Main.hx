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
  private static var loader: Loader = null;
  private static var loader2: Loader = null;
  private static var busy = false;
  private static var testUrl1 = 
    "http://www.freewallpapersbase.com/video-game/wallpapers2/TheWitcher001-wallpaper.jpg"
;
  private static var testUrl2 = 
    "http%3A%2F%2Fwww.mmogrindhouse.com%2Fwp-content%2Fuploads%2F2009%2F08%2Fblizzstumes11.jpg";
  private static var urlCounter = 1;

  static function imageLoaded(event) {
    trace("image Loaded, event.target = " + Std.string(event.target) );
    root.removeChild(loader);
    loader = loader2;
    loader.x = loader.y = 0;
    loader.width = newWidth;
    loader.scaleX = loader.scaleY;
    //loader.height = newHeight;
    //    root.addChild(loader);
    busy = false;
  }
  static function loadImage() {
    //trace("busy = " + busy);
    //    if (!busy) {
      trace("loading...");
      loader2 = new Loader();
      root.addChild(loader2);
      loader2.contentLoaderInfo.addEventListener(Event.COMPLETE, imageLoaded);
      loader2.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, loadError);
      //loader2.width = newWidth;
      //loader2.height = newHeight;
      loader2.x = loader2.y = 0;
      busy = true;
      loader2.load(new URLRequest(pictureUrl));
      //    }
  }
  static function loadError(event) {
    trace("Unable to load image: " + event);
  }
  static function main() {
    try {
      var params = flash.Lib.current.loaderInfo.parameters;      
      newWidth = params.newWidth;
      newHeight = params.newHeight;
      trace("newWidth,newHeight = " + newWidth + "," + newHeight);
      pictureUrl = testUrl1;
      root = flash.Lib.current;
      loader = new Loader();
      loader.contentLoaderInfo.addEventListener(Event.COMPLETE, imageLoaded);
      loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, loadError);
      timer = new Timer(2000);
      timer.run = loadImage;
    } catch (error: Dynamic) {
      trace("fatal error");
      trace(error);
    }
  }
}