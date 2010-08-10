package ghostcat.ui.containers
{
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import ghostcat.display.GBase;
	import ghostcat.util.easing.Circ;
	import ghostcat.util.easing.TweenUtil;
	
	/**
	 * 抽屉窗体
	 * @author flashyiyi
	 * 
	 */
	public class GDrawerPanel extends GBase
	{
		/**
		 * 缩小时的矩形
		 */
		public var drawerRect:Rectangle;
		
		/**
		 * 展开时的矩形
		 */
		public var allRect:Rectangle;
		
		/**
		 * 缓动持续时间
		 */
		public var duration:int = 1000;
		
		/**
		 * 缓动函数
		 */
		public var easing:Function = Circ.easeOut;
		
		/**
		 * 点几展开 
		 */
		public var clickToOpen:Boolean = true;
		
		private var _opened:Boolean;
		
		/**
		 * 
		 * @param skin
		 * @param replace
		 * @param drawRect	缩小时的矩形
		 * @param opened	初始时是否展开
		 * 
		 */
		public function GDrawerPanel(skin:*=null, replace:Boolean=true, drawRect:Rectangle=null, opened:Boolean = false)
		{
			this.drawerRect = drawRect;
			this._opened = opened;
	
			super(skin, replace);
			
			addEventListener(MouseEvent.CLICK,clickHandler);
		}
		
		protected function clickHandler(event:MouseEvent):void
		{
			if (clickToOpen && this.drawerRect.contains(mouseX,mouseY))
				opened = !opened;
		}
		
		public function get opened():Boolean
		{
			return _opened;
		}

		public function set opened(v:Boolean):void
		{
			_opened = v;
			TweenUtil.removeTween(this);
			if (v)
				TweenUtil.to(this,duration,{scrollRect:allRect ? allRect : content.getRect(this),ease:easing,onUpdate:this.vaildSize});
			else
				TweenUtil.to(this,duration,{scrollRect:drawerRect,ease:easing,onUpdate:this.vaildSize});
		}
		
		/**
		 * 立即更新打开状态 
		 * @param opened
		 * 
		 */
		public function refreshOpenedState(opened:Boolean):void
		{
			_opened = opened;
			
			if (_opened || !drawerRect)
				this.scrollRect = allRect ? allRect : content.getRect(this);
			else
				this.scrollRect = drawerRect;
			
			this.invalidateSize();
		}
		/** @inheritDoc*/
		public override function setContent(skin:*, replace:Boolean=true) : void
		{
			super.setContent(skin,replace);
			refreshOpenedState(opened);
		}
		
		/** @inheritDoc*/
		public override function destory() : void
		{
			if (destoryed)
				return;
		
			removeEventListener(MouseEvent.CLICK,clickHandler);
		
			super.destory();
		}
		
	}
}