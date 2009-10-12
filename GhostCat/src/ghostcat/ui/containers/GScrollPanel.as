package ghostcat.ui.containers
{
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	
	import ghostcat.display.GNoScale;
	import ghostcat.ui.classes.scroll.IScrollContent;
	import ghostcat.ui.controls.GHScrollBar;
	import ghostcat.ui.controls.GScrollBar;
	import ghostcat.ui.controls.GVScrollBar;
	
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
		
		public var fields:Object = {vScrollBarField:"vScrollBar",hScrollBarField:"hScrollBar"};
		
		private var _oldScrollH:int;
		private var _oldScrollV:int;
		
		public function GScrollPanel(skin:*,replace:Boolean = true,scrollRect:Rectangle = null,fields:Object = null)
		{
			if (fields)
				this.fields = fields;
				
			super(skin,replace);
			
			if (scrollRect)
				this.scrollRect = scrollRect;
			
			if (!this.scrollRect && content)
				this.scrollRect = content.getBounds(this);
			
			invalidateSize();
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
			
			if (scrollRect)
				this.scrollRect = new Rectangle(this.scrollRect.x,this.scrollRect.y,width,height);
			else
				this.scrollRect = new Rectangle(0,0,width,height);
			
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
		/** @inheritDoc*/
		public function get maxScrollH():int
		{
			return content.width - scrollRect.width;
		}
		/** @inheritDoc*/
		public function get maxScrollV():int
		{
			return content.height - scrollRect.height;
		}
		
		public function get oldScrollH():int
		{
			return _oldScrollH;
		}
		/** @inheritDoc*/
		public function get scrollH():int
		{
			return	-content.x;
		}
		
		public function set scrollH(v:int):void
		{
			v = Math.max(0,Math.min(v,maxScrollH))
			
			_oldScrollH = -content.x;
			content.x = -v;
		}
		
		public function get oldScrollV():int
		{
			return _oldScrollV;
		}
		/** @inheritDoc*/
		public function get scrollV():int
		{
			return -content.y;
		}
		
		public function set scrollV(v:int):void
		{
			v = Math.max(0,Math.min(v,maxScrollV))
			
			_oldScrollV = -content.y;
			content.y = -v;
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
		
			super.destory();
		}
	}
}