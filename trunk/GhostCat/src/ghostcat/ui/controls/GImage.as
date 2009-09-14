package ghostcat.ui.controls
{
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	
	import ghostcat.display.GNoScale;
	import ghostcat.ui.LayoutUtil;
	import ghostcat.ui.UIConst;
	import ghostcat.util.CallLater;
	import ghostcat.util.ClassFactory;
	import ghostcat.util.Geom;
	
	public class GImage extends GNoScale
	{
		public var loaderContext:LoaderContext;
		
		private var _clipContent:Boolean = false;
		private var _scaleContent:Boolean = true;
		
		private var _horizontalAlign:String = UIConst.CENTER;
		private var _verticalAlign:String = UIConst.MIDDLE;
		
		public function GImage(source:*=null, replace:Boolean=true)
		{
			super(source as DisplayObject, replace);
			this.source = source;
		}
		
		public function get verticalAlign():String
		{
			return _verticalAlign;
		}

		public function set verticalAlign(v:String):void
		{
			_verticalAlign = v;
			invalidateLayout();
		}

		public function get horizontalAlign():String
		{
			return _horizontalAlign;
		}

		public function set horizontalAlign(v:String):void
		{
			_horizontalAlign = v;
			invalidateLayout();
		}

		public function get scaleContent():Boolean
		{
			return _scaleContent;
		}

		public function set scaleContent(v:Boolean):void
		{
			_scaleContent = v;
			invalidateLayout();
		}

		public function get clipContent():Boolean
		{
			return _clipContent;
		}

		public function set clipContent(v:Boolean):void
		{
			_clipContent = v;
			scrollRect = v ? new Rectangle(0,0,width,height) : null;
		}

		public function set source(v:*):void
		{
			var loader:Loader;
			if (v is String)
				v = new URLRequest(v as String)
			
			if (v is URLRequest)
			{
				loader = new Loader();
				loader.load(v as URLRequest,loaderContext);
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE,loadCompleteHandler);
				
				v = loader;
			}
			
			if (v is Class)
				v = new ClassFactory(v);
			
			if (v is ClassFactory)
				v = new ClassFactory().newInstance();
				
			if (v is ByteArray)
			{
				loader = new Loader();
				loader.loadBytes(v as ByteArray,loaderContext);
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE,loadCompleteHandler);
				
				v = loader;
			}
			
			setContent(v as DisplayObject, replace);
		}
		
		private function loadCompleteHandler(event:Event):void
		{
			(event.currentTarget as EventDispatcher).removeEventListener(Event.COMPLETE,loadCompleteHandler);
			
			invalidateLayout();
		}
		
		protected override function updateSize() : void
		{
			super.updateSize();
			
			if (_clipContent)
				scrollRect = new Rectangle(0,0,width,height);
				
			layoutChildren();
		}
		
		public function invalidateLayout():void
		{
			CallLater.callLater(layoutChildren,null,true);
		}
		
		protected function layoutChildren():void
		{
			if (scaleContent)
				Geom.scaleToFit(content,this,true);
			else
				content.scaleX = content.scaleY = 1.0;
			
			LayoutUtil.silder(content,this,horizontalAlign,verticalAlign);
		}
	}
}