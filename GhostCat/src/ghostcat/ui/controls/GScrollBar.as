package ghostcat.ui.controls
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BlurFilter;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	
	import ghostcat.display.IGBase;
	import ghostcat.display.filter.FilterProxy;
	import ghostcat.events.TickEvent;
	import ghostcat.ui.UIConst;
	import ghostcat.ui.scroll.GScrollPanel;
	import ghostcat.ui.scroll.IScrollContent;
	import ghostcat.ui.scroll.ScrollTextContent;
	import ghostcat.util.easing.Circ;
	import ghostcat.util.easing.TweenEvent;
	import ghostcat.util.easing.TweenUtil;
	
	
	[Event(name="tween_start",type="ghostcat.util.easing.TweenEvent")]
	[Event(name="tween_end",type="ghostcat.util.easing.TweenEvent")]
	[Event(name="tween_update",type="ghostcat.util.easing.TweenEvent")]
	/**
	 * 滚动条 
	 * 
	 * 标签规则：和Silder相同
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class GScrollBar extends GSilder
	{
		private var _scrollContent:IScrollContent;
		
		private var blurProxy:FilterProxy;
		
		private var _target:*;
		
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
		public function get target():*
		{
			return _target;
		}

		public function set target(v:*):void
		{
			if (_target)
				_target.removeEventListener(Event.SCROLL,scrollHandler);
			
			_target = v;
			
			if (!v)
				return;
			
			if (v is IScrollContent)
				_scrollContent = v as IScrollContent;
			else if (_target is GText)
				_scrollContent = new ScrollTextContent((_target as GText).textField);
			else if (_target is TextField)
				_scrollContent = new ScrollTextContent(_target as TextField);
			else
			{
				if (v.parent && v.parent is IScrollContent && (v.parent as IScrollContent).content == v)
					_scrollContent = v.parent as IScrollContent;
				else	
					_scrollContent = new GScrollPanel(_target);
			}
			
			if (_scrollContent)
				_scrollContent.addEventListener(Event.SCROLL,scrollHandler);
		}
		
		public function get scrollContent():IScrollContent
		{
			return _scrollContent;
		}
		
		/**
		 * 缓动目标值（无缓动时为NaN）
		 * @return 
		 * 
		 */
		public function get tweenTargetValue():Number
		{
			if (!scrollContent)
				return NaN;
			
			return (direction == UIConst.HORIZONTAL) ? _scrollContent.tweenTargetH : _scrollContent.tweenTargetV;
		}
		
		/** @inheritDoc*/
		public override function get value():Number
		{
			if (!scrollContent)
				return NaN;
			
			return (direction == UIConst.HORIZONTAL) ? _scrollContent.scrollH : _scrollContent.scrollV;
		}
		public override function set value(v:Number):void
		{
			if (direction == UIConst.HORIZONTAL)
				_scrollContent.scrollH = v; 
			else
				_scrollContent.scrollV = v;
				
			super.value = v;
		}
		

		private var _pageLength:Number;
		
		/**
		 * 单页长度 
		 */
		public function get pageLength():Number
		{
			if (_pageLength)
			{
				return _pageLength;
			}
			else
			{
				var sr:Rectangle = (_scrollContent as DisplayObject).scrollRect;
				return direction == UIConst.HORIZONTAL ? sr.width : sr.height;
			}
		};
		
		public function set pageLength(v:Number):void
		{
			_pageLength = v;
		};
		
		/**
		 * 页数
		 * @return 
		 * 
		 */
		public function get page():int
		{
			return Math.ceil(value / pageLength) + 1;
		}
		
		/**
		 * 总页数
		 * @return 
		 * 
		 */
		public function get maxPage():int
		{
			return Math.ceil(maxValue / pageLength) + 1;
		}
		
		/** @inheritDoc*/
		public override function get maxValue():Number
		{
			return (direction == UIConst.HORIZONTAL) ? _scrollContent.maxScrollH : _scrollContent.maxScrollV;
		}
		
		public override function set maxValue(v:Number):void
		{
			throw new Error("此属性是只读的")
		}
		/** @inheritDoc*/
		public override function get minValue():Number
		{
			return 0;
		}

		public override function set minValue(v:Number):void
		{
			throw new Error("此属性是只读的")
		}
		/** @inheritDoc*/
		public override function get percent():Number
		{
			if (!_scrollContent)
				return NaN;
			
			return (direction == UIConst.HORIZONTAL) ? _scrollContent.scrollH / _scrollContent.maxScrollH : _scrollContent.scrollV / _scrollContent.maxScrollV;
		}
		
		public override function set percent(v:Number):void
		{
			if (!_scrollContent)
				return;
			
			if (direction == UIConst.HORIZONTAL)
				_scrollContent.scrollH = _scrollContent.maxScrollH * v; 
			else
				_scrollContent.scrollV = _scrollContent.maxScrollV * v;
		}
		
		/**
		 * 重置滚动 
		 * 
		 */
		public function resetContent(x:Boolean = true,y:Boolean = true):void
		{
			if (x)
			{
				_scrollContent.scrollH = 0.0;
				_scrollContent.tweenTargetH = NaN;
			}
			if (y)
			{
				_scrollContent.scrollV = 0.0;
				_scrollContent.tweenTargetV = NaN;
			}	
			updateThumb();
		}
		/**
		 * 设置目标
		 * 
		 * @param target	目标
		 * @param width	目标的滚动大小
		 * @param height	目标的滚动大小
		 * @param overrideWheelDirect	重置目标的鼠标滚动方向
		 */
		public function setTarget(target:*,width:Number = NaN,height:Number = NaN, overrideWheelDirect:Boolean = true, wheelSpeed:Number = NaN):void
		{
			this.target = target;
			
			if (overrideWheelDirect)
			{
				_scrollContent.wheelDirect = this.direction;
				if (!isNaN(wheelSpeed))
					_scrollContent.wheelSpeed = wheelSpeed;
			}
			
			setTargetScrollSize(width,height);
			
			tickHandler(null);
		}
		
		/**
		 * 设置目标的滚动大小
		 * @param rect
		 * 
		 */
		public function setTargetScrollSize(width:Number = NaN,height:Number = NaN):void
		{
			if (isNaN(width) && isNaN(height) || !(_scrollContent is DisplayObject))
				return;
			
			if (isNaN(width))
				width = (_scrollContent as DisplayObject).width;
			
			if (isNaN(height))
				height = (_scrollContent as DisplayObject).height;
			
			(_scrollContent as DisplayObject).scrollRect = new Rectangle(0,0,width,height);
		}
		/** @inheritDoc*/
		public override function updateThumb():void
		{
			if (!_scrollContent)
				return;
			
			super.updateThumb();
		}
		
		/**
		 * 向上按钮点击事件
		 * @param event
		 * 
		 */
		protected override function upArrowClickHandler(event:MouseEvent):void
		{
			var t:Number = direction == UIConst.HORIZONTAL ? scrollContent.tweenTargetH : scrollContent.tweenTargetV;
			if (isNaN(t))
				t = direction == UIConst.HORIZONTAL ? scrollContent.scrollH : scrollContent.scrollV;
			
			tweenToValue(t - detra,true)
		}
		
		/**
		 * 向下按钮点击事件
		 * @param event
		 * 
		 */
		protected override function downArrowClickHandler(event:MouseEvent):void
		{
			var t:Number = direction == UIConst.HORIZONTAL ? scrollContent.tweenTargetH : scrollContent.tweenTargetV;
			if (isNaN(t))
				t = direction == UIConst.HORIZONTAL ? scrollContent.scrollH : scrollContent.scrollV;
			
			tweenToValue(t + detra,true);
		}
		
		/**
		 * 缓动到值
		 * @param v
		 * 
		 */
		protected function tweenToValue(v:Number,update:Boolean = false):void
		{
			v = Math.max(Math.min(v,maxValue),minValue);
			
			//记录目标值防止重复缓动
			if (direction == UIConst.HORIZONTAL)
			{
				if (v == _scrollContent.tweenTargetH)
					return;
				
				scrollContent.tweenTargetH = v;
				if (duration > 0)
				{
					TweenUtil.removeTween(_scrollContent,false);
					TweenUtil.to(_scrollContent,duration,{scrollH : v, ease : easing, 
						onUpdate:update ? tweenUpdateWithThumb : tweenUpdateHandler, 
						onStart:tweenStartHandler, onComplete:tweenCompleteHandler
					});
				
					dispatchEvent(new Event(Event.CHANGE));
				}
				else
				{
					this.value = v;
					if (update)
						updateThumb();
				}
			}
			else
			{	
				if (v == _scrollContent.tweenTargetV)
					return;
				
				scrollContent.tweenTargetV = v;
				if (duration > 0)
				{
					TweenUtil.removeTween(_scrollContent,false);
					TweenUtil.to(_scrollContent,duration,{scrollV : v, ease : easing, 
						onUpdate:update ? tweenUpdateWithThumb : tweenUpdateHandler, 
						onStart:tweenStartHandler, onComplete:tweenCompleteHandler
					});
					
					dispatchEvent(new Event(Event.CHANGE));
				}
				else 
				{
					this.value = v;
					if (update)
						updateThumb();
				}
			}
			
			
			function tweenUpdateWithThumb():void
			{
				updateThumb();
				tweenUpdateHandler();
			}
		}
		
		/**
		 * 缓动开始方法
		 * 
		 */
		protected function tweenStartHandler():void
		{
			dispatchEvent(new TweenEvent(TweenEvent.TWEEN_START));
		}
		
		/**
		 * 缓动结束方法
		 * 
		 */
		protected function tweenCompleteHandler():void
		{
			if (direction == UIConst.HORIZONTAL)
				_scrollContent.tweenTargetH = NaN; 
			else
				_scrollContent.tweenTargetV = NaN;
			
			dispatchEvent(new TweenEvent(TweenEvent.TWEEN_END));
		}
		
		/**
		 * 缓动进行方法
		 * 
		 */
		protected function tweenUpdateHandler():void
		{
			dispatchEvent(new TweenEvent(TweenEvent.TWEEN_UPDATE));
		}
		
		/** @inheritDoc*/
		protected override function thumbMouseMoveHandler(event:Event=null):void
		{
			if (thumb.position.equals(thumb.oldPosition))
				return;
			
			if (!_scrollContent)
				return;
			
			var v:Number;
			if (direction == UIConst.HORIZONTAL)
				v = _scrollContent.maxScrollH * (thumb.x - thumbAreaStart) / thumbAreaLength;
			else
				v = _scrollContent.maxScrollV * (thumb.y - thumbAreaStart) / thumbAreaLength;
			
			tweenToValue(v);
			
		}
		
		protected function scrollHandler(event:Event):void
		{
			if (!isThumbDrag) //拖动Thumb不更新位置，否则会相互冲突
				updateThumb();
		}
		/** @inheritDoc*/
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
		/** @inheritDoc*/
		public override function destory() : void
		{
			target = null;
			
			if (_scrollContent is IGBase)
				(_scrollContent as IGBase).destory();
		
			super.destory();
		}
	}
}