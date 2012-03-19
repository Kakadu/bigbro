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
import haxe.Http;

class URLParser
{
    // Publics
    public var url : String;
    public var source : String;
    public var protocol : String;
    public var authority : String;
    public var userInfo : String;
    public var user : String;
    public var password : String;
    public var host : String;
    public var port : String;
    public var relative : String;
    public var path : String;
    public var directory : String;
    public var file : String;
    public var query : String;
    public var anchor : String;
 
    // Privates
    inline static private var _parts : Array<String> = ["source","protocol","authority","userInfo","user","password","host","port","relative","path","directory","file","query","anchor"];
 
    public function new(url:String)
    {
        // Save for 'ron
        this.url = url;
 
        // The almighty regexp (courtesy of http://blog.stevenlevithan.com/archives/parseuri)
        var r : EReg = ~/^(?:(?![^:@]+:[^:@\/]*@)([^:\/?#.]+):)?(?:\/\/)?((?:(([^:@]*)(?::([^:@]*))?)?@)?([^:\/?#]*)(?::(\d*))?)(((\/(?:[^?#](?![^?#\/]*\.[^?#\/.]+(?:[?#]|$)))*\/?)?([^?#\/]*))(?:\?([^#]*))?(?:#(.*))?)/;
 
        // Match the regexp to the url
        r.match(url);
 
        // Use reflection to set each part
        for (i in 0..._parts.length)
        {
            Reflect.setField(this, _parts[i],  r.matched(i));
        }
    }
/* 
    public function toString() : String
    {
        var s : String = "For Url -> " + url + "\n";
        for (i in 0..._parts.length)
        {
            s += _parts[i] + ": " + Reflect.field(this, _parts[i]) + (i==_parts.length-1?"":"\n");
        }
        return s;
    }
*/ 
    public static function parse(url:String) : URLParser
    {
        return new URLParser(url);
    }
}

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
  private static var domains_arr: Array<String> = [];

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
      var domains: String = if (params.domains!=null) params.domains else "";
      domains_arr = domains.split(",");
      domains_arr.insert(0,URLParser.parse(pictureUrl).authority);
      domains_arr.push("static-cdn1.ustream.tv");
      
      for (domain in domains_arr)       
         flash.system.Security.allowDomain(domain);
	  trace(domains_arr.join(","));
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
      trace(error);
      for (x in haxe.Stack.exceptionStack())
	    trace(x);				
    }
  }
}