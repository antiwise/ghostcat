package ghostcat.ui.containers
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import ghostcat.display.GNoScale;
	import ghostcat.ui.UIConst;
	import ghostcat.ui.controls.GHScrollBar;
	import ghostcat.ui.controls.GScrollBar;
	import ghostcat.ui.controls.GVScrollBar;
	import ghostcat.ui.scroll.IScrollContent;
	
	[Event(name="scroll",type="flash.events.Event")]
	
	/**
	 * 滚动区域
	 * 
	 * 标签规则：子对象中vScrollBar,hScrollBar会被转换为滚动条，所有皮肤都会在content内一起滚动
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class GScrollPanel extends GNoScale implements IScrollContent
	{
		/**
		 * 横向滚动条
		 */
		public var hScrollBar:GScrollBar;
		
		/**
		 * 纵向滚动条
		 */
		public var vScrollBar:GScrollBar;
		
		/**
		 * 横向滚动皮肤
		 */
		public var hScrollBarSkin:DisplayObject;
		/**
		 * 纵向滚动条皮肤
		 */
		public var vScrollBarSkin:DisplayObject;
		
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

		
		public var fields:Object = {vScrollBarField:"vScrollBar",hScrollBarField:"hScrollBar"};
		
		private var _oldScrollH:int;
		private var _oldScrollV:int;
		private var _tweenTargetH:Number = 0;
		private var _tweenTargetV:Number = 0;
		
		/**
		 * 是否在设置滚动区域时绘制透明背景
		 */
		public var createScrollArea:Boolean = true;
		
		public function GScrollPanel(skin:*,replace:Boolean = true,width:Number = NaN,height:Number = NaN,fields:Object = null)
		{
			if (fields)
				this.fields = fields;
				
			super(skin,replace);
			
			this.scrollRect = new Rectangle(0,0,content.width,content.height);
			
			if (!isNaN(width))
				this.width = width;
			
			if (!isNaN(height))
				this.height = height;
			
			addEventListener(MouseEvent.MOUSE_WHEEL,mouseWheelHandler);
		}
		/** @inheritDoc*/
		public override function setContent(skin:*, replace:Boolean=true) : void
		{
			super.setContent(skin,replace);
			
			var vScrollBarField:String = fields[vScrollBarField];
			var hScrollBarField:String = fields[hScrollBarField];
			
			if (hScrollBarField)
			{
				hScrollBarSkin = content[hScrollBarField] as DisplayObject;
				hScrollBarSkin.parent.removeChild(hScrollBarSkin);
			}
			
			if (vScrollBarField)
			{
				vScrollBarSkin = content[vScrollBarField] as DisplayObject;
				vScrollBarSkin.parent.removeChild(vScrollBarSkin);
			}
		}
		
		/**
		 * 生成横向滚动条
		 * @param skin
		 * 
		 */
		public function addHScrollBar(skin:* = null):void
		{
			removeHScrollBar();
			
			if (!skin)
				skin = hScrollBarSkin;
				
			hScrollBar = new GHScrollBar(skin);
			$addChild(hScrollBar);
			hScrollBar.target = this;
			
			invalidateSize();
		}
		
		/**
		 * 生成纵向滚动条
		 * @param skin
		 * 
		 */
		public function addVScrollBar(skin:* = null):void
		{
			removeVScrollBar();
			
			if (!skin)
				skin = vScrollBarSkin;
			
			vScrollBar = new GVScrollBar(skin);
			$addChild(vScrollBar);
			vScrollBar.target = this;
			
			invalidateSize();
		}
		
		/**
		 * 删除横向滚动条
		 * 
		 */
		public function removeHScrollBar():void
		{
			if (hScrollBar)
			{
				hScrollBar.destory();
				hScrollBar = null;
			}
		}
		
		/**
		 * 删除纵向滚动条 
		 * 
		 */
		public function removeVScrollBar():void
		{
			if (vScrollBar)
			{
				vScrollBar.destory();
				vScrollBar = null;
			}
		}
		/** @inheritDoc*/
		protected override function updatePosition() : void
		{
			super.updatePosition();
			if (hScrollBar)
				hScrollBar.y = this.y + this.height;
			
			if (vScrollBar)
				vScrollBar.x = this.x + this.width;
		}
		/** @inheritDoc*/
		protected override function updateSize() : void
		{
			super.updateSize();
			
			this.scrollRect = new Rectangle(scrollRect.x,scrollRect.y,width,height);
			
			if (hScrollBar)
			{
				hScrollBar.x = 0;
				hScrollBar.y = this.height - hScrollBar.height;
				hScrollBar.width = this.width;
			}
			
			if (vScrollBar)
			{
				vScrollBar.y = 0;
				vScrollBar.x = this.width - vScrollBar.width;
				vScrollBar.height = this.height;
			}
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
			
			if (hScrollBar)
				hScrollBar.destory();
			
			if (vScrollBar)
				vScrollBar.destory();
			
			removeEventListener(MouseEvent.MOUSE_WHEEL,mouseWheelHandler);
		
			super.destory();
		}
	}
}