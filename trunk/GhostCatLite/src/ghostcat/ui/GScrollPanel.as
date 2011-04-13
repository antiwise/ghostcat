package ghostcat.ui
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import ghostcat.core.display.GBase;
	
	[Event(name="scroll",type="flash.events.Event")]
	
	/**
	 * 滚动区域
	 * 
	 * 标签规则：子对象中vScrollBar,hScrollBar会被转换为滚动条，所有皮肤都会在content内一起滚动
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class GScrollPanel extends GBase implements IScrollContent
	{
		private var _wheelDirect:String;

		/**
		 * 鼠标滚动方向
		 */
		public function get wheelDirect():String
		{
			return _wheelDirect;
		}

		public function set wheelDirect(value:String):void
		{
			_wheelDirect = value;
		}

		
		private var _wheelSpeed:Number = 5;

		/**
		 * 鼠标滚动速度（像素）
		 */
		public function get wheelSpeed():Number
		{
			return _wheelSpeed;
		}

		public function set wheelSpeed(value:Number):void
		{
			_wheelSpeed = value;
		}
		
		private var _oldScrollH:int;
		private var _oldScrollV:int;
		private var _tweenTargetH:Number = NaN;
		private var _tweenTargetV:Number = NaN;
		
		/**
		 * 是否在设置滚动区域时绘制透明背景
		 */
		public var createScrollArea:Boolean = true;
		
		public function GScrollPanel(skin:*,replace:Boolean = true,width:Number = NaN,height:Number = NaN)
		{
			super(skin,replace);
			
			this.scrollRect = new Rectangle(0,0,content.width,content.height);
			
			if (!isNaN(width))
				this.width = width;
			
			if (!isNaN(height))
				this.height = height;
			
			addEventListener(MouseEvent.MOUSE_WHEEL,mouseWheelHandler);
		}
		/** @inheritDoc*/
		protected override function updateSize() : void
		{
			this.scrollRect = new Rectangle(scrollRect.x,scrollRect.y,width,height);
		}
		
		public override function set scrollRect(value:Rectangle) : void
		{
			super.scrollRect = value;
			
			if (createScrollArea)
			{
				graphics.clear();
				graphics.beginFill(0,0);
				graphics.drawRect(scrollRect.x,scrollRect.y,scrollRect.width,scrollRect.height);
				graphics.endFill();
			}
		}
		
		/** @inheritDoc*/
		public function get maxScrollH():int
		{
			return Math.max(0,content.width - scrollRect.width);
		}
		/** @inheritDoc*/
		public function get maxScrollV():int
		{
			return Math.max(0,content.height - scrollRect.height);
		}
		/** @inheritDoc*/
		public function get oldScrollH():int
		{
			return _oldScrollH;
		}
		/** @inheritDoc*/
		public function get scrollH():int
		{
			return	-content.x;
		}
		/** @inheritDoc*/
		public function set scrollH(v:int):void
		{
			v = Math.max(0,Math.min(v,maxScrollH))
			
			_oldScrollH = -content.x;
			content.x = -v;
		}
		/** @inheritDoc*/
		public function get oldScrollV():int
		{
			return _oldScrollV;
		}
		/** @inheritDoc*/
		public function get scrollV():int
		{
			return -content.y;
		}
		/** @inheritDoc*/
		public function set scrollV(v:int):void
		{
			v = Math.max(0,Math.min(v,maxScrollV))
			
			_oldScrollV = -content.y;
			content.y = -v;
		}
		/** @inheritDoc*/
		public function get tweenTargetH():Number
		{
			return _tweenTargetH;
		}
		/** @inheritDoc*/
		public function get tweenTargetV():Number
		{
			return _tweenTargetV;
		}
		/** @inheritDoc*/
		public function set tweenTargetH(v:Number):void
		{
			_tweenTargetH = v;
		}
		/** @inheritDoc*/
		public function set tweenTargetV(v:Number):void
		{
			_tweenTargetV = v;
		}
		
		protected function mouseWheelHandler(event:MouseEvent):void
		{
			if (wheelDirect)
			{
				if (wheelDirect == UIConst.HORIZONTAL)
					tweenTargetH = scrollH = Math.min(maxScrollH,Math.max(0,scrollH - event.delta * wheelSpeed));	
				
				if (wheelDirect == UIConst.VERTICAL)
					tweenTargetV = scrollV = Math.min(maxScrollV,Math.max(0,scrollV - event.delta * wheelSpeed));
				
				dispatchEvent(new Event(Event.SCROLL));
			}
		}
		
		/** @inheritDoc*/
		public override function destory() : void
		{
			if (destoryed)
				return;
			
			removeEventListener(MouseEvent.MOUSE_WHEEL,mouseWheelHandler);
		
			super.destory();
		}
	}
}