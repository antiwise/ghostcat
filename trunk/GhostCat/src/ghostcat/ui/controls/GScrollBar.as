package ghostcat.ui.controls
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.filters.BlurFilter;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	
	import ghostcat.events.TickEvent;
	import ghostcat.filter.FilterProxy;
	import ghostcat.ui.UIConst;
	import ghostcat.ui.classes.scroll.IScrollContent;
	import ghostcat.ui.classes.scroll.ScrollTextContent;
	import ghostcat.ui.containers.GScrollPanel;
	import ghostcat.util.TweenUtil;
	import ghostcat.util.easing.Circ;
	
	/**
	 * 滚动条 
	 * @author flashyiyi
	 * 
	 */
	public class GScrollBar extends GSilder
	{
		private var _scrollContent:IScrollContent;
		
		private var blurProxy:FilterProxy;
		
		private var _target:DisplayObject;
		
		/**
		 * 滚动缓动效果
		 */
		public var easing:Function = Circ.easeOut;
		
		/**
		 * 缓动时间
		 */		
		public var duration:int = 1000;
		
		/**
		 * 滚动模糊
		 */		
		public var blur:Number = 0
		
		public function GScrollBar(skin:*=null, replace:Boolean=true,fields:Object=null)
		{
			super(skin, replace,fields);
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
			if (_target)
				_target.removeEventListener(Event.SCROLL,scrollHandler);
			
			_target = v;
			
			if (v is IScrollContent)
				_scrollContent = v as IScrollContent;
			else if (_target is TextField)
				_scrollContent = new ScrollTextContent(_target as TextField);
			else
			{
				if (v.parent && v.parent is IScrollContent && (v.parent as IScrollContent).content == v)
					_scrollContent = v.parent as IScrollContent;
				else	
					_scrollContent = new GScrollPanel(_target);
			}
			
			if (_target)
				_target.addEventListener(Event.SCROLL,scrollHandler);
		}
		
		public override function get value():Number
		{
			return (direction == UIConst.HORIZONTAL) ? _scrollContent.scrollH : _scrollContent.scrollV;
		}

		public override function set value(v:Number):void
		{
			super.value = v;
			
			if (direction == UIConst.HORIZONTAL)
				_scrollContent.scrollH = v; 
			else
				_scrollContent.scrollV = v;
				
		}
		
		public override function get maxValue():Number
		{
			return (direction == UIConst.HORIZONTAL) ? _scrollContent.maxScrollH : _scrollContent.maxScrollV;
		}

		public override function set maxValue(v:Number):void
		{
			throw new Error("此属性是只读的")
		}

		public override function get minValue():Number
		{
			return 0;
		}

		public override function set minValue(v:Number):void
		{
			throw new Error("此属性是只读的")
		}
		
		public override function get percent():Number
		{
			return (direction == UIConst.HORIZONTAL) ? _scrollContent.scrollH / _scrollContent.maxScrollH : _scrollContent.scrollV / _scrollContent.maxScrollV;
		}
		
		public override function set percent(v:Number):void
		{
			if (direction == UIConst.HORIZONTAL)
				_scrollContent.scrollH = _scrollContent.maxScrollH * v; 
			else
				_scrollContent.scrollV = _scrollContent.maxScrollV * v;
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
		 * 设置目标
		 * 
		 * @param target	目标
		 * @param scrollRect	目标的滚动大小
		 * 
		 */
		public function setTarget(target:DisplayObject,scrollRect:Rectangle = null):void
		{
			this.target = target;
			
			if (scrollRect)
				setTargetScrollRect(scrollRect);
		}
		
		/**
		 * 设置目标的滚动大小
		 * @param rect
		 * 
		 */
		public function setTargetScrollRect(rect:Rectangle):void
		{
			if (_scrollContent && _scrollContent is DisplayObject)
				(_scrollContent as DisplayObject).scrollRect = rect;
		}
		
		public override function updateThumb():void
		{
			if (!_scrollContent)
				return;
			
			super.updateThumb();
		}
		
		protected override function thumbMouseMoveHandler(event:Event=null):void
		{
			if (thumb.position.equals(thumb.oldPosition))
				return;
			
			if (!_scrollContent)
				return;
			
			var v:Number;
			if (direction == UIConst.HORIZONTAL)
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
		
		protected function scrollHandler(event:Event):void
		{
			updateThumb();
		}
		
		protected override function tickHandler(event:TickEvent):void
		{
			super.tickHandler(event);
			
			//模糊效果
			if (blur > 0)
			{
				if (oldValue == value)
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
					
					var v:Number = Math.abs(oldValue - value) * blur;
					if (direction == UIConst.HORIZONTAL)
						blurProxy.blurX = v;
					else
						blurProxy.blurY = v;
					
					value = value;
				}
			}
		}
		
		public override function destory() : void
		{
			super.destory();
			
			target = null;
		}
	}
}