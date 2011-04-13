package ghostcat.core.display
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	
	import ghostcat.core.util.Tick;
	import ghostcat.events.TickEvent;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.utils.getDefinitionByName;
	
	import ghostcat.core.util.ClassFactory;
	
	/**
	 * 这个类实现了光标和提示接口，以及属性变化事件
	 * 
	 * 建议全部可视对象都以此类作为基类，而不仅仅是组件。
	 * 如果不需要Vaild事件，可将enabledDelayUpdate设为false,便不会占用多余的性能。
	 * 
	 * @author flashyiyi
	 * 
	 */	
	public class GBase extends Sprite
	{
		private var _enabled:Boolean = true;
		
		private var _selected:Boolean = false;
		
		private var _enabledTick:Boolean = false;
		
		private var _cursor:*;
		
		private var _toolTip:*;
		
		private var _toolTipObj:*;
		
		protected var _data:Object;
		
		private var _content:DisplayObject;
		
		private var _replace:Boolean = true;
		
		/**
		 * 是否在移出显示列表的时候删除自身
		 */		
		public var destoryWhenRemove:Boolean = false;
		
		/**
		 * 是否初始化
		 */
		public var initialized:Boolean;
		
		/**
		 * 是否已经被销毁
		 */
		public var destoryed:Boolean = false;
		
		/**
		 * 是否在第一次设置content时接受content的坐标 
		 */		
		public var acceptContentPosition:Boolean = true;
		
		/**
		 * 内容是否初始化
		 */
		protected var contentInited:Boolean = false;
		
		
		/**
		 * 设置替换方式。此属性务必在设置skin之前设置，否则会导致源图像被破坏，达不到replace为false时的效果。 
		 * @return 
		 * 
		 */		
		public function get replace():Boolean
		{
			return _replace;
		}
		
		public function set replace(v:Boolean):void
		{
			_replace = v;
			setContent(_content,v);
		}
		/**
		 * 设置皮肤 
		 * @return 
		 * 
		 */		
		public function get skin():*
		{
			return _content;
		}
		
		public function set skin(v:*):void
		{
			setContent(v,replace);
		}
		
		/**
		 *
		 * 当前容纳的内容
		 * @return 
		 * 
		 */		
		
		public function get content():DisplayObject
		{
			return _content;
		}
		
		public function set content(v:DisplayObject):void
		{
			_content = v;
		}
		
		/**
		 * 设置皮肤。
		 * 
		 * @param skin		皮肤	
		 * @param replace	是否替换原图元
		 * 
		 */		
		public function setContent(skin:*,replace:Boolean=true):void
		{
			if (skin is String)
				skin = getDefinitionByName(skin as String);
			
			if (skin is Class)
				skin = new ClassFactory(skin);
			
			if (skin is ClassFactory)
				skin = (skin as ClassFactory).newInstance();
			
			if (_content == skin)
				return;
			
			if (skin is BitmapData)
				skin = new Bitmap(skin as BitmapData)
			
			if (_content && _content.parent == this)
			{
				if (_content.parent)
					removeChild(_content);
			}
			
			var oldIndex:int;
			var oldParent:DisplayObjectContainer;
			
			if (replace && skin)
			{
				//新设置内容的时候，获取内容的坐标
				if (acceptContentPosition && !contentInited)
				{
					this.x = skin.x;
					this.y = skin.y;
					
					skin.x = skin.y = 0;
				}
				
				if (_content == null)
				{
					//在最后才加入舞台
					if (skin.parent)
					{
						oldParent = skin.parent;
						oldIndex = skin.parent.getChildIndex(skin);
					}
				}
				
				addChild(skin);
				
				if (!contentInited)
				{
					this.visible = skin.visible;
					skin.visible = true;
					this.name = skin.name;
				}
			}
			
			_content = skin;
			
			if (oldParent && !(oldParent is Loader) && oldParent != this)
				oldParent.addChildAt(this,oldIndex);
			
			if (content is InteractiveObject)
				(content as InteractiveObject).mouseEnabled = false;
			
			this.contentInited = true;
		}
		
		private function addedToStageHandler(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE,addedToStageHandler)
			init();
			
			this.initialized = true;
		}
		
		private function removedFromStageHandler(event:Event):void
		{
			if (destoryWhenRemove)
			{
				this.removeEventListener(Event.REMOVED_FROM_STAGE,removedFromStageHandler);
				
				destory();
			}
		}
		
		/**
		 *
		 * 初始化方法，在第一次被加入显示列表时调用 
		 * 
		 */		
		protected function init():void
		{
		}
		
		/**
		 * 销毁方法
		 * 
		 */
		public function destory():void
		{
			if (destoryed)
				return;
			
			this.enabledTick = false;
			this.refreshInterval = 0;
			this.asBitmap = false;
			
			removeEventListener(Event.ADDED_TO_STAGE,addedToStageHandler);
			removeEventListener(Event.REMOVED_FROM_STAGE,removedFromStageHandler);
			
			if (parent)
				parent.removeChild(this);
			
			destoryed = true;
		}
		
		/**
		 * 参数与setContent方法相同
		 * 
		 */		
		public function GBase(skin:*=null,replace:Boolean=true)
		{
			this.self = this;
			
			addEventListener(Event.ADDED_TO_STAGE,addedToStageHandler);
			addEventListener(Event.REMOVED_FROM_STAGE,removedFromStageHandler);
			
			setContent(skin,replace);
		}
		
		private var _owner:DisplayObject;

		/**
		 * 拥有者
		 */
		public function get owner():DisplayObject
		{
			return _owner;
		}

		/**
		 * @private
		 */
		public function set owner(value:DisplayObject):void
		{
			_owner = value;
		}

		
		/**
		 * 自身
		 */
		public var self:GBase;
		
		/**
		 * 设置数据 
		 * @return 
		 * 
		 */		

		public function get data():*
		{
			return _data;
		}

		public function set data(v:*):void
		{
			_data = v;
		}
		
		/**
		 * 提示的内容，不一定非要是字符串，以便实现复杂内容的提示
		 * 此属性在GToolTipSprite不存在实例时无效
		 * @return 
		 * 
		 */		
		public function get toolTip():*
		{
			return _toolTip;
		}

		public function set toolTip(v:*):void
		{
			_toolTip = v;
		}
		/**
		 * 提示的自定义显示，用于单个控件特殊的提示，可多个组件共享同一个实例。类型只能是字符串或者GBase对象以及类。
		 * 当类型是字符串时，将会从GToolTipSprite查找已注册的ToolTipObj。都不满足时，将使用GToolTipSprite的默认提示
		 * 
		 * 此属性在GToolTipSprite不存在实例时无效
		 * @return 
		 * 
		 */		

		public function get toolTipObj():*
		{
			return _toolTipObj;
		}

		public function set toolTipObj(v:*):void
		{
			_toolTipObj = v;
		}
		/**
		 * 光标的Class，可能的类型是Class或者String，Class类型直接是显示的图元，
		 * String类型时，将会从GCursorSprite的cursors对象中寻找对应的Class;
		 * 
		 * 当GCursorSprite类不存在实例时，此属性无效
		 * 
		 * @return 
		 * 
		 */		
		public function get cursor():*
		{
			return _cursor;
		}

		public function set cursor(v:*):void
		{
			_cursor = v;
		}

		/**
		 * 是否选中
		 * 
		 * @return 
		 * 
		 */
		public function get selected():Boolean
		{
			return _selected;
		}

		public function set selected(v:Boolean):void
		{
			_selected = v;
		}
		
		
		/** @inheritDoc */	
		public function get enabledTick():Boolean
		{
			return _enabledTick;
		}

		public function set enabledTick(v:Boolean):void
		{
			if (_enabledTick == v)
				return;
			
			_enabledTick = v;
			
			if (_enabledTick)
				Tick.instance.addEventListener(TickEvent.TICK,tickHandler);
			else
				Tick.instance.removeEventListener(TickEvent.TICK,tickHandler);
		}

		/** @inheritDoc */
		public function get enabled():Boolean
		{
			return _enabled;
		}

		public function set enabled(v:Boolean):void
		{
			_enabled = v;
		}
		
		/**
		 * 在暂停状态下，仍然可以手动使用此方法激活tick。利用它可以处理区域调速等功能。
		 * @param v
		 * 
		 */
		public function tick(v:int):void
		{
			var evt:TickEvent = new TickEvent(TickEvent.TICK);
			evt.interval = v;
			tickHandler(evt);
		}
		
		/**
		 * 时基事件
		 * @param event
		 * 
		 */
		protected function tickHandler(event:TickEvent):void
		{
			
		}
		
		private var _bitmap:Bitmap;
		private var _asBitmap:Boolean = false;
		
		/**
		 * 将content替换成Bitmap,增加性能
		 * 
		 */		
		public function set asBitmap(v:Boolean):void
		{
			if (!content)
				return;
				
			if (v)
			{
				content.visible = false;
				reRenderBitmap();	
			}
			else
			{
				content.visible = true;
				if (_bitmap)
				{
					_bitmap.bitmapData.dispose();
					_bitmap.parent.removeChild(_bitmap);
					_bitmap = null;
				}
			}
		}
		
		public function get asBitmap():Boolean
		{
			return _asBitmap;
		}
		
		/**
		 * 更新缓存位图
		 * 
		 */			
		public function reRenderBitmap():void
		{
			var oldRect:Rectangle = _bitmap ? _bitmap.getBounds(this) : null;
			var rect:Rectangle = content.getBounds(this);
			if (!oldRect || !rect.equals(oldRect))
			{
				if (_bitmap)
				{
					removeChild(_bitmap);
					_bitmap.bitmapData.dispose();
				}
				_bitmap = new Bitmap(new BitmapData(Math.ceil(rect.width),Math.ceil(rect.height),true,0));
				_bitmap.x = rect.x;
				_bitmap.y = rect.y;
				addChild(_bitmap);
			}
			var m:Matrix = new Matrix();
			m.translate(-rect.x,-rect.y);
			_bitmap.bitmapData.draw(content,m);
		}
		
		private var _refreshInterval:int = 0;
		private var _refreshTimer:Timer;
		
		/**
		 * 自动刷新间隔，默认为不刷新 
		 * @return 
		 * 
		 */
		public function get refreshInterval():int
		{
			return _refreshInterval;
		}

		public function set refreshInterval(v:int):void
		{
			if (_refreshInterval == v)
				return;
			
			_refreshInterval = v;
			if (v == 0)
			{
				if (_refreshTimer)
				{
					_refreshTimer.removeEventListener(TimerEvent.TIMER,refreshHandler);
					_refreshTimer.stop();
					_refreshTimer = null;
				}
			}
			else
			{
				if (!_refreshTimer)
				{
					_refreshTimer = new Timer(v,int.MAX_VALUE);
					_refreshTimer.addEventListener(TimerEvent.TIMER,refreshHandler);
					_refreshTimer.start();
				}
				else
					_refreshTimer.delay = v;
			}
		}
		
		/**
		 * 定时刷新事件 
		 * @param event
		 * 
		 */
		protected function refreshHandler(event:TimerEvent):void
		{
			
		}
		
		
	}
}