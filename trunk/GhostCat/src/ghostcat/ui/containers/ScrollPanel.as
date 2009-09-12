package ghostcat.ui.containers
{
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	
	import ghostcat.display.GBase;
	import ghostcat.ui.controls.GHScrollBar;
	import ghostcat.ui.controls.GScrollBar;
	import ghostcat.ui.controls.GVScrollBar;
	import ghostcat.ui.controls.scrollClasses.IScrollContent;
	
	/**
	 * 滚动区域
	 * @author flashyiyi
	 * 
	 */
	public class ScrollPanel extends GBase implements IScrollContent
	{
		public var hScrollBar:GScrollBar;
		public var vScrollBar:GScrollBar;
		
		public function ScrollPanel(skin:DisplayObject,scrollRect:Rectangle = null)
		{
			super(skin);
			
			if (scrollRect)
				this.scrollRect = scrollRect;
			
			if (!this.scrollRect)
				this.scrollRect = content.getBounds(this);
			
			invalidateSize();
		}
		
		public function addHScrollBar():void
		{
			hScrollBar = new GHScrollBar();
			parent.addChild(hScrollBar);
			hScrollBar.target = this;
			
			invalidateSize();
		}
		
		public function addVScrollBar():void
		{
			vScrollBar = new GVScrollBar();
			parent.addChild(vScrollBar);
			vScrollBar.target = this;
			
			invalidateSize();
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
			var rect:Rectangle = content.getBounds(content);
			return rect.width - scrollRect.width;
		}
		
		public function get maxScrollV():int
		{
			var rect:Rectangle = content.getBounds(content);
			return rect.height - scrollRect.height;
		}
		
		public function get scrollH():int
		{
			return	scrollRect.x;
		}
		
		public function set scrollH(v:int):void
		{
			v = Math.max(0,Math.min(v,maxScrollH))
			
			var rect:Rectangle = scrollRect.clone();
			rect.x = v;
			scrollRect = rect;
		}
		
		public function get scrollV():int
		{
			return scrollRect.y;
		}
		
		public function set scrollV(v:int):void
		{
			v = Math.max(0,Math.min(v,maxScrollV))
			
			var rect:Rectangle = scrollRect.clone();
			rect.y = v;
			scrollRect = rect;
		}
	}
}