package ghostcat.game.layer.camera
{
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	
	import ghostcat.algorithm.BoxsGrid;
	import ghostcat.game.layer.GameLayerBase;
	import ghostcat.util.ArrayUtil;
	
	public class BoxsGridCamera extends SimpleCamera
	{
		public var boxs:BoxsGrid;
		public var screenRect:Rectangle;
		public function BoxsGridCamera(layer:GameLayerBase,screenRect:Rectangle,rect:Rectangle,boxWidth:Number,boxHeight:Number)
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
			
			var news:Array = this.boxs.getDataInRect(r);
			var outArray:Array = [];
			var inArray:Array = [];
			ArrayUtil.hasShare(layer.childrenInScreen,news,null,outArray,inArray);
			layer.childrenInScreen = news;
			if (!this.layer.isBitmapEngine)
			{
				var child:DisplayObject
				for each (child in outArray)
					layer.addChild(child);
				
				for each (child in inArray)
					layer.removeChild(child);
			}
		}
		
	}
}