package ghostcat.display.viewport
{
	import flash.display.DisplayObject;
	import flash.events.EventDispatcher;
	import flash.geom.Rectangle;
	
	/**
	 * Tile物品管理类
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class TileItemManager extends EventDispatcher
	{
		private var itemHeight:Number;
		private var itemWidth:Number;
		private var wh:Number;
		
		/**
		 * 根据skin的大小自动判断占用的格子范围
		 * @return 
		 * 
		 */
		public function getDefaultTileRect(skin:DisplayObject):Rectangle
		{
			var cRect:Rectangle = skin.getRect(skin);
			var rect:Rectangle = new Rectangle(0,0,cRect.right / (itemHeight / 2),cRect.bottom / (itemWidth /2));
			return rect;
		}
		
		/**
		 * 设置网格的宽高
		 * @param width
		 * @param height
		 * 
		 */
		public function setContentSize(width:Number,height:Number):void
		{
			this.itemWidth = width;
			this.itemHeight = height;
			this.wh = width / height;
		}
		
		public function TileItemManager()
		{
			
		}
	}
}