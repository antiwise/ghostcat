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
		private var is45:Boolean;
		private var wh:Number;
		
		/**
		 * 根据skin的大小自动判断占用的格子范围
		 * 
		 * @param skin
		 * @return 
		 * 
		 */
		public function getDefaultTileRect(skin:DisplayObject):Rectangle
		{
			var cRect:Rectangle = skin.getRect(skin);
			var rect:Rectangle;
			if (is45)
				rect = new Rectangle(0,0,cRect.right / (itemHeight / 2),cRect.bottom / (itemWidth /2));
			else
				rect = new Rectangle(0,0,cRect.right / itemHeight,cRect.bottom / itemWidth);
			return rect;
		}
		
		/**
		 * 根据skin的大小判断图形的高度
		 * 
		 * @param skin
		 * @return 
		 * 
		 */
		public function getTileHeight(skin:DisplayObject):Number
		{
			var rect:Rectangle = skin.getRect(skin);
			return -rect.y;
		}
		
		/**
		 * 设置网格的宽高
		 * @param width
		 * @param height
		 * @param is45	是否是45度角坐标系
		 * 
		 */
		public function setContentSize(width:Number,height:Number,is45:Boolean = false):void
		{
			this.itemWidth = width;
			this.itemHeight = height;
			this.is45 = is45;
			this.wh = width / height;
		}
		
		public function TileItemManager()
		{
			
		}
	}
}