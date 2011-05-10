package ghostcat.ui.controls
{
	import flash.display.BitmapData;
	import flash.display.FrameLabel;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * 供GBitmapButton使用的专门皮肤类
	 * @author flashyiyi
	 * 
	 */
	public class BitmapButtonSkin extends Sprite
	{
		public static var defaultLabels:Array = [
			new FrameLabel("up",1),new FrameLabel("over",2),
			new FrameLabel("down",3),new FrameLabel("disabled",4),
			new FrameLabel("selectedUp",5),new FrameLabel("selectedOver",6),
			new FrameLabel("selectedDown",7),new FrameLabel("selectedDisabled",8)
		];
		public var bitmapDatas:Array;
		public var labels:Array;
		/**
		 * 设置一张整图来并切分到多个状态来设置皮肤
		 * 
		 * @param source	源图
		 * @param width	横向图片数量
		 * @param height	纵向图片数量
		 * 
		 */
		public function setWholeBitmapDataSkin(source:BitmapData,width:int = 1,height:int = 4):void
		{
			bitmapDatas = separateBitmapData(source,width,height);
			labels = defaultLabels;
		}
		
		private function separateBitmapData(source:BitmapData,width:int,height:int):Array
		{
			var result:Array = [];
			for (var j:int = 0;j < Math.ceil(source.height / height);j++)
			{
				for (var i:int = 0;i < Math.ceil(source.width / width);i++)
				{
					var bitmap:BitmapData = new BitmapData(width,height,true,0);
					bitmap.copyPixels(source,new Rectangle(i*width,j*height,width,height),new Point());
					result.push(bitmap)
				}
			}
			return result;
		}
	}
}