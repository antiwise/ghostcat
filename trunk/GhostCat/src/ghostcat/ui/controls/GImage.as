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
	import ghostcat.ui.UIConst;
	import ghostcat.ui.layout.LayoutUtil;
	import ghostcat.util.core.CallLater;
	import ghostcat.util.core.ClassFactory;
	import ghostcat.util.display.Geom;
	
	/**
	 * 图片
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class GImage extends GNoScale
	{
		/**
		 * 等比例缩放，但不会超过容器的范围
		 */
		public static const UNIFORM:String = Geom.UNIFORM;
		
		/**
		 * 等比例填充，多余的部分会被裁切
		 */
		public static const CROP:String = Geom.CROP;
		
		/**
		 * 非等比例填充
		 */
		public static const FILL:String = Geom.FILL;
		
		/**
		 * 载入时使用的loaderContext
		 */
		public var loaderContext:LoaderContext;
		
		private var _clipContent:Boolean = false;
		private var _scaleContent:Boolean = true;
		
		private var _horizontalAlign:String = UIConst.CENTER;
		private var _verticalAlign:String = UIConst.MIDDLE;
		
		/**
		 * 垂直对齐
		 * @return 
		 * 
		 */
		public function get verticalAlign():String
		{
			return _verticalAlign;
		}

		public function set verticalAlign(v:String):void
		{
			_verticalAlign = v;
			invalidateLayout();
		}

		/**
		 * 水平对齐 
		 * @return 
		 * 
		 */
		public function get horizontalAlign():String
		{
			return _horizontalAlign;
		}

		public function set horizontalAlign(v:String):void
		{
			_horizontalAlign = v;
			invalidateLayout();
		}
		
		private var _scaleType:String = Geom.UNIFORM;

		/**
		 * 缩放类型。常量在Geom类中。
		 */
		public function get scaleType():String
		{
			return _scaleType;
		}

		public function set scaleType(v:String):void
		{
			_scaleType = v;
			invalidateLayout();
		}


		/**
		 * 是否缩放
		 * @return 
		 * 
		 */
		public function get scaleContent():Boolean
		{
			return _scaleContent;
		}

		public function set scaleContent(v:Boolean):void
		{
			_scaleContent = v;
			invalidateLayout();
		}

		/**
		 * 是否裁切 
		 * @return 
		 * 
		 */
		public function get clipContent():Boolean
		{
			return _clipContent;
		}

		public function set clipContent(v:Boolean):void
		{
			_clipContent = v;
			scrollRect = v ? new Rectangle(0,0,width,height) : null;
		}

		/**
		 * 数据源
		 * @param v
		 * 
		 */
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
		
		public function GImage(source:*=null, replace:Boolean=true)
		{
			super(source as DisplayObject, replace);
			this.source = source;
		}
		
		private function loadCompleteHandler(event:Event):void
		{
			(event.currentTarget as EventDispatcher).removeEventListener(Event.COMPLETE,loadCompleteHandler);
			
			invalidateLayout();
		}
		/** @inheritDoc*/
		protected override function updateSize() : void
		{
			super.updateSize();
			
			if (_clipContent)
				scrollRect = new Rectangle(0,0,width,height);
				
			layoutChildren();
		}
		
		/**
		 * 之后更新布局 
		 * 
		 */
		public function invalidateLayout():void
		{
			CallLater.callLater(layoutChildren,null,true);
		}
		
		/**
		 * 更新布局
		 * 
		 */
		protected function layoutChildren():void
		{
			if (scaleContent)
				Geom.scaleToFit(content,this,_scaleType);
			else
				content.scaleX = content.scaleY = 1.0;
			
			LayoutUtil.silder(content,this,horizontalAlign,verticalAlign);
		}
	}
}