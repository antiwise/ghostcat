package ghostcat.game.layer.camera
{
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import ghostcat.algorithm.BoxsGrid;
	import ghostcat.game.layer.GameLayer;
	import ghostcat.util.ArrayUtil;
	
	/**
	 * 剔除屏幕外的对象
	 * @author flashyiyi
	 * 
	 */
	public class BoxsGridCamera extends SimpleCamera
	{
		public var boxs:BoxsGrid;
		/**
		 * 屏幕大小 
		 */
		public var screenRect:Rectangle;
		
		/**
		 * 始终显示的对象
		 */
		public var extendsItems:Dictionary;
		
		/**
		 * 是否移除屏幕外的对象
		 */
		public var removeOutSideItems:Boolean = true;
		
		public function BoxsGridCamera(layer:GameLayer,screenRect:Rectangle,rect:Rectangle,boxWidth:Number,boxHeight:Number)
		{
			super(layer);
			
			this.screenRect = screenRect;
			this.boxs = new BoxsGrid(rect,boxWidth,boxHeight);
		}
		
		override public function refreshItem(item:DisplayObject):void
		{
			this.boxs.reinsert(item);
		}
		
		override public function render():void
		{
			super.render();
			
			var r:Rectangle = new Rectangle(
				screenRect.x + position.x,
				screenRect.y + position.y,
				screenRect.width,
				screenRect.height);
			
			var oldDict:Dictionary = layer.childrenInScreenDict; 
			var newsDict:Dictionary = new Dictionary();
			var news:Array = this.boxs.getDataInRect(r,newsDict);
			
			var child:*;
			if (extendsItems)
			{
				for (child in extendsItems)
				{
					if (!newsDict[child])
					{
						news[news.length] = child;
						newsDict[child] = true;
					}
				}
			}
			
			layer.childrenInScreen = news;
			layer.childrenInScreenDict = newsDict;
			
			if (removeOutSideItems && !this.layer.isBitmapEngine)
			{
				for (child in oldDict)
				{
					if (!newsDict[child])
						layer.removeChild(DisplayObject(child));
		
				}
				for (child in newsDict)
				{
					if (!oldDict[child])
						layer.addChild(DisplayObject(child));
				}
			}
		}
		
	}
}