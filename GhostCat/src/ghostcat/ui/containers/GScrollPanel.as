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
	 * @author flashyiyi
	 * 
	 */
	public class GScrollPanel extends GNoScale implements IScrollContent
	{
		public var hScrollBar:GScrollBar;
		public var vScrollBar:GScrollBar;
		
		private var _oldScrollH:int;
		private var _oldScrollV:int;
		
		public function GScrollPanel(skin:*,scrollRect:Rectangle = null)
		{
			super(skin);
			
			if (scrollRect)
				this.scrollRect = scrollRect;
			
			if (!this.scrollRect)
				this.scrollRect = content.getBounds(this);
			
			invalidateSize();
		}
		
		/**
		 * 在父级生成横向滚动条
		 * @param skin
		 * 
		 */
		public function addHScrollBar(skin:DisplayObject = null):void
		{
			hScrollBar = new GHScrollBar(skin);
			parent.addChild(hScrollBar);
			hScrollBar.target = this;
			
			invalidateSize();
		}
		
		/**
		 * 在父级生成纵向滚动条
		 * @param skin
		 * 
		 */
		public function addVScrollBar(skin:DisplayObject = null):void
		{
			vScrollBar = new GVScrollBar(skin);
			parent.addChild(vScrollBar);
			vScrollBar.target = this;
			
			invalidateSize();
		}
		
		protected override function updatePosition() : void
		{
			super.updatePosition();
			if (hScrollBar)
				hScrollBar.y = this.y + this.height;
			
			if (vScrollBar)
				vScrollBar.x = this.x + this.width;
		}
		
		protected override function updateSize() : void
		{
			super.updateSize();
			
			this.scrollRect = new Rectangle(this.scrollRect.x,this.scrollRect.y,width,height);
			
			if (hScrollBar)
			{
				hScrollBar.y = this.y + this.height;
				hScrollBar.width = this.width;
			}
			
			if (vScrollBar)
			{
				vScrollBar.x = this.x + this.width;
				vScrollBar.height = this.height;
			}
		}
		
		public function get maxScrollH():int
		{
			return content.width - scrollRect.width;
		}
		
		public function get maxScrollV():int
		{
			return content.height - scrollRect.height;
		}
		
		public function get oldScrollH():int
		{
			return _oldScrollH;
		}
		
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
	}
}