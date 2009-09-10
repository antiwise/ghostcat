package org.ghostcat.ui.containers
{
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	
	import org.ghostcat.display.GBase;
	import org.ghostcat.ui.controls.scrollClasses.IScrollContent;
	
	public class ScrollPanel extends GBase implements IScrollContent
	{
		public function ScrollPanel(skin:DisplayObject,scrollRect:Rectangle = null)
		{
			super(skin);
			
			if (scrollRect)
			{
				this.width = scrollRect.width;
				this.height = scrollRect.height;
			}
			else
			{
				this.scrollRect = content.getBounds(this);
			}
			invalidateSize();
		}
		
		protected override function updateSize() : void
		{
			super.updateSize();
			
			this.scrollRect = new Rectangle(this.scrollRect.x,this.scrollRect.y,width,height);
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