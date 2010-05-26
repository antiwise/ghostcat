package ghostcat.ui.controls
{
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.Security;
	import flash.system.SecurityDomain;
	import flash.utils.ByteArray;
	
	import ghostcat.display.GNoScale;
	import ghostcat.display.loader.ImageLoader;
	import ghostcat.ui.UIConst;
	import ghostcat.ui.layout.LayoutUtil;
	import ghostcat.util.core.ClassFactory;
	import ghostcat.util.core.UniqueCall;
	import ghostcat.util.display.Geom;
	
	[Event(name="complete",type="flash.events.Event")]
	
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
		public static const UNIFORM:String = UIConst.UNIFORM;
		
		/**
		 * 等比例填充，多余的部分会被裁切
		 */
		public static const CROP:String = UIConst.CROP;
		
		/**
		 * 非等比例填充
		 */
		public static const FILL:String = UIConst.FILL;
		
		/**
		 * 载入时使用的loaderContext
		 */
		public var loaderContext:LoaderContext;
		
		/**
		 * 是否检测图片的跨域文件
		 */
		public var checkPolicyFile:Boolean = false;
		
		/**
		 * 是否使用当前域
		 */
		public var useCurrentDomain:Boolean = false;
		
		/**
		 * 是否使用中转Loader（可以绕过图片沙箱）
		 */
		public var useTempLoader:Boolean = false;
		
		private var _clipContent:Boolean = false;
		private var _scaleContent:Boolean = true;
		
		private var _horizontalAlign:String = UIConst.CENTER;
		private var _verticalAlign:String = UIConst.MIDDLE;
		
		private var _centerAtZero:Boolean = false;
		
		private var _source:*;
		
		/**
		 * 在加载完成前隐藏内容 
		 */
		public var hideContentBeforeLoad:Boolean = true;
		
		
		protected var layoutChildrenCall:UniqueCall = new UniqueCall(layoutChildren);
		
			
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
		
		private var _scaleType:String = "fill";

		/**
		 * 缩放类型
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
		 * 在原点居中 
		 * @return 
		 * 
		 */
		public function get centerAtZero():Boolean
		{
			return _centerAtZero;
		}
		
		public function set centerAtZero(value:Boolean):void
		{
			_centerAtZero = value;
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
		public function get source():*
		{
			return _source;
		}
		
		public function set source(v:*):void
		{
			if (_source == v)
				return;
			
			_source = v;
			
			var loader:Loader;
			if (v is String)
				v = new URLRequest(v as String)
			
			if (v is URLRequest)
			{
				var loaderContext:LoaderContext = this.loaderContext;
				if (!loaderContext)
				{
					loaderContext = new LoaderContext(checkPolicyFile);
					if (useCurrentDomain)
					{
						loaderContext.applicationDomain = ApplicationDomain.currentDomain;
						if (Security.sandboxType == Security.REMOTE)
							loaderContext.securityDomain = SecurityDomain.currentDomain;
					}
				}
				loader = useTempLoader ? new ImageLoader() : new Loader();
				loader.load(v as URLRequest,loaderContext);
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE,loadCompleteHandler);
				loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,loadCompleteHandler);
				
				v = loader;
			}
			
			if (v is Class)
				v = new ClassFactory(v);
			
			if (v is ClassFactory)
				v = (v as ClassFactory).newInstance();
				
			if (v is ByteArray)
			{
				loader = new Loader();
				loader.loadBytes(v as ByteArray,loaderContext);
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE,loadCompleteHandler);
				
				v = loader;
			}
			
			setContent(v as DisplayObject, replace);
			
			if (v && !(v is Loader))
				layoutChildren();
		}
		
		public function GImage(source:*=null, replace:Boolean=true)
		{
			super(source, replace);
			
			this.enabledAutoSize = false;
			this.source = source;
		}
		
		private function loadCompleteHandler(event:Event):void
		{
			(event.currentTarget as EventDispatcher).removeEventListener(Event.COMPLETE,loadCompleteHandler);
			(event.currentTarget as EventDispatcher).removeEventListener(IOErrorEvent.IO_ERROR,loadCompleteHandler);
			
			layoutChildren();
			
			dispatchEvent(new Event(Event.COMPLETE));
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
			layoutChildrenCall.invalidate();
		}
		
		/**
		 * 立即更新布局
		 * 
		 */
		public override function vaildNow():void
		{
			super.vaildNow()
			layoutChildren();
		}
		
		/**
		 * 更新布局
		 * 
		 */
		protected function layoutChildren():void
		{
			if (!content)
				return;
			
			if (content is Loader && !content.width && !content.height)
				return;
				
			if (scaleContent && sized)
				Geom.scaleToFit(content,this,_scaleType);
			else
				content.scaleX = content.scaleY = 1.0;
			
			if (centerAtZero)
				Geom.centerAtZero(content);
			else if (sized)
				LayoutUtil.silder(content,this,horizontalAlign,verticalAlign);
			
		}
	}
}