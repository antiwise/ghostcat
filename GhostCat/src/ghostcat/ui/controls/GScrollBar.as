package ghostcat.ui.controls
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BlurFilter;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	
	import ghostcat.events.TickEvent;
	import ghostcat.filter.FilterProxy;
	import ghostcat.manager.DragManager;
	import ghostcat.ui.containers.GScrollPanel;
	import ghostcat.ui.controls.scrollClasses.IScrollContent;
	import ghostcat.ui.controls.scrollClasses.ScrollTextContent;
	import ghostcat.util.Tick;
	import ghostcat.util.TweenUtil;
	import ghostcat.util.easing.Circ;
	
	/**
	 * 滚动条 
	 * @author flashyiyi
	 * 
	 */
	public class GScrollBar extends GSilder
	{
		public var upArrow:GButton;
		public var downArrow:GButton;
		public var thumb:GButton;
		public var background:DisplayObject;
		
		private var _target:DisplayObject;
		private var _scrollContent:IScrollContent;
		
		private var thumbAreaStart:Number;
		private var thumbAreaLength:Number;
		
		private var blurProxy:FilterProxy;
		
		/**
		 * 方向
		 */
		private var _direction:int;
		
		/**
		 * 滚动缓动效果
		 */
		public var easing:Function = Circ.easeOut;
		
		/**
		 * 缓动时间
		 */		
		public var duration:int = 1000;
		
		/**
		 * 滚动速度
		 */
		public var detra:int = 5;
		
		/**
		 * 快速滚动速度
		 */
		public var pageDetra:int = 25;
		
		/**
		 * 滚动模糊
		 */		
		public var blur:Number = 0
		
		public var fields:Object = {upArrowField:"upArrow",downArrowField:"downArrow",
			thumbField:"thumb",backgroundField:"background"}
		
		public function GScrollBar(skin:DisplayObject=null, replace:Boolean=true,fields:Object=null)
		{
			if (fields)
				this.fields = fields;
			
			super(skin, replace);
			
			Tick.instance.addEventListener(TickEvent.TICK,tickHandler);
		}
		
		/**
		 * 设置要滚动的目标
		 * @return 
		 * 
		 */
		public function get target():DisplayObject
		{
			return _target;
		}

		public function set target(v:DisplayObject):void
		{
			_target = v;
			
			if (v is IScrollContent)
				_scrollContent = v as IScrollContent;
			else if (_target is TextField)
				_scrollContent = new ScrollTextContent(_target as TextField);
			else
				_scrollContent = new GScrollPanel(_target);
		}
		
		/**
		 * 滚动区域对象
		 * @return 
		 * 
		 */
		public function get scrollContent():IScrollContent
		{
			return _scrollContent;
		}
		
		/**
		 * 方向 
		 * @return 
		 * 
		 */
		public function get direction():int
		{
			return _direction;
		}

		public function set direction(v:int):void
		{
			_direction = v;
			invalidateSize();
		}
		
		/**
		 * 设置目标的滚动区域
		 * @param rect
		 * 
		 */
		public function setTargetScrollRect(rect:Rectangle):void
		{
			if (_scrollContent && _scrollContent is DisplayObject)
				(_scrollContent as DisplayObject).scrollRect = rect;
		}
		
		public override function setContent(skin:DisplayObject, replace:Boolean=true) : void
		{
			super.setContent(skin,replace);
			
			var upArrowField:String = fields.upArrowField;
			var downArrowField:String = fields.downArrowField;
			var thumbField:String = fields.thumbField;
			var backgroundField:String =  fields.backgroundField;
			
			if (content.hasOwnProperty(upArrowField))
				this.upArrow = new GButton(content[upArrowField]);
				
			if (content.hasOwnProperty(downArrowField))
				this.downArrow = new GButton(content[downArrowField]);
				
			if (content.hasOwnProperty(thumbField))
			{
				this.thumb = new GButton(content[thumbField]);
				thumb.addEventListener(MouseEvent.MOUSE_DOWN,thumbMouseDownHandler);
			}
				
			if (content.hasOwnProperty(backgroundField))
			{
				this.background = content[backgroundField];
				this.background.addEventListener(MouseEvent.MOUSE_DOWN,backgroundHandler);
			}
			invalidateSize();
		}
		
		protected override function updateSize() : void
		{
			super.updateSize();
			
			if (this.downArrow)
			{
				this.downArrow.x = this.width - this.downArrow.width;
				this.downArrow.y = this.height - this.downArrow.height;
			}
			
			if (direction == 0)
			{
				thumbAreaStart = upArrow ? upArrow.width : 0;
				thumbAreaLength = this.width - downArrow.width - thumb.width - thumbAreaStart;
				background.width = width;
			}
			else
			{
				thumbAreaStart = upArrow ? upArrow.height : 0;
				thumbAreaLength = this.height - downArrow.height - thumb.height - thumbAreaStart;
				background.height = height;
			}
			
			updateThumb()
		}
		
		protected function updateThumb():void
		{
			if (!_scrollContent || !thumb)
				return;
			
			var p:Number;
			if (direction == 0)
			{
				p = _scrollContent.scrollH / _scrollContent.maxScrollH;
				thumb.x = thumbAreaStart + thumbAreaLength * p;
			}
			else
			{
				p = _scrollContent.scrollV / _scrollContent.maxScrollV;
				thumb.y = thumbAreaStart + thumbAreaLength * p;
			}
		}
		
		protected function thumbMouseDownHandler(event:MouseEvent):void
		{
			var rect:Rectangle;
			if (direction == 0)
				rect = new Rectangle(thumbAreaStart,thumb.y,thumbAreaLength,thumb.y);
			else
				rect = new Rectangle(thumb.x,thumbAreaStart,thumb.x,thumbAreaLength);
				
			DragManager.startDrag(thumb,rect,null,thumbMouseMoveHandler);
		}
		
		protected function thumbMouseMoveHandler(event:Event=null):void
		{
			if (thumb.position.equals(thumb.oldPosition))
				return;
			
			var v:Number;
			
			if (!_scrollContent)
				return;
			
			if (direction == 0)
			{
				v = _scrollContent.maxScrollH * (thumb.x - thumbAreaStart) / thumbAreaLength;
				if (duration > 0)
				{
					TweenUtil.removeTween(_scrollContent,false);
					TweenUtil.to(_scrollContent,duration,{scrollH : v, ease : easing})
				}
				else
					_scrollContent.scrollH = v;
			}
			else
			{
				v = _scrollContent.maxScrollV * (thumb.y - thumbAreaStart) / thumbAreaLength;
				if (duration > 0)
				{
					TweenUtil.removeTween(_scrollContent,false);
					TweenUtil.to(_scrollContent,duration,{scrollV : v, ease : easing})
				}
				else 
					_scrollContent.scrollV = v;
			}
		}
		
		protected function tickHandler(event:TickEvent):void
		{
			if (direction == 0)
			{
				if (upArrow)
				{
					upArrow.enabled = _scrollContent.scrollH > 0;
					if (upArrow.mouseDown)
					{
						_scrollContent.scrollH -= detra;
						updateThumb();
					}
				}
				
				if (downArrow)
				{
					downArrow.enabled = _scrollContent.scrollH < _scrollContent.maxScrollH;
					if (downArrow.mouseDown)
					{
						_scrollContent.scrollH += detra;
						updateThumb();
					}
				}
				
				if (blur > 0)
				{
					if (_scrollContent.oldScrollH == _scrollContent.scrollH)
					{
						if (blurProxy)
						{
							blurProxy.removeFilter();
							blurProxy = null;
						}
					}
					else
					{
						if (!blurProxy)
						{
							blurProxy = new FilterProxy(new BlurFilter());
							blurProxy.applyFilter(_scrollContent.content);
						}
						
						blurProxy.blurX = Math.abs(_scrollContent.oldScrollH - _scrollContent.scrollH) * blur;
						
						_scrollContent.scrollH = _scrollContent.scrollH;
					}
				}
			}
			else
			{
				if (upArrow)
				{
					upArrow.enabled = _scrollContent.scrollV > 0;
					if (upArrow.mouseDown)
					{
						_scrollContent.scrollV -= detra;
						updateThumb();
					}
				}
				
				if (downArrow)
				{
					downArrow.enabled = _scrollContent.scrollV < _scrollContent.maxScrollV;
					if (downArrow.mouseDown)
					{
						_scrollContent.scrollV += detra;
						updateThumb();
					}
				}
				
				if (blur > 0)
				{
					if (_scrollContent.oldScrollV == _scrollContent.scrollV)
					{
						if (blurProxy)
						{
							blurProxy.removeFilter();
							blurProxy = null;
						}
					}
					else
					{
						if (!blurProxy)
						{
							blurProxy = new FilterProxy(new BlurFilter());
							blurProxy.applyFilter(_scrollContent.content);
						}
						
						blurProxy.blurY = Math.abs(_scrollContent.oldScrollV - _scrollContent.scrollV) * blur;
						
						_scrollContent.scrollV = _scrollContent.scrollV;
					}
				}
			}
			
			
		}
		
		protected function backgroundHandler(event:MouseEvent):void
		{
			if (direction == 0)
			{
				if (thumb.mouseX > pageDetra + thumb.width)
					thumb.x += pageDetra;
				else if (thumb.mouseX < -pageDetra)
					thumb.x -= pageDetra;
				else
					thumb.x += thumb.mouseX;
					
				thumb.x = Math.max(Math.min(downArrow.x,thumb.x),upArrow.x + upArrow.width)
			}
			else
			{
				if (thumb.mouseY > pageDetra + thumb.height)
					thumb.y += pageDetra;
				else if (thumb.mouseY < -pageDetra)
					thumb.y -= pageDetra;
				else
					thumb.y += thumb.mouseY;
					
				thumb.y = Math.max(Math.min(downArrow.y,thumb.y),upArrow.y + upArrow.height)
			}
			thumbMouseMoveHandler();
		}
		
		public override function destory() : void
		{
			super.destory();
			
			Tick.instance.removeEventListener(TickEvent.TICK,tickHandler);
			
			if (upArrow) 
				upArrow.destory();
			
			if (downArrow) 
				downArrow.destory();
			
			if (thumb) 
			{
				thumb.destory();
				thumb.removeEventListener(MouseEvent.MOUSE_DOWN,thumbMouseDownHandler);
			}
			
			if (background)
				background.removeEventListener(MouseEvent.MOUSE_DOWN,backgroundHandler);
		}
	}
}