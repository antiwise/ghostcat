package ghostcat.game.item.sort
{
	import flash.display.DisplayObject;
	
	/**
	 * 等角深度计算模块
	 * @author flashyiyi
	 * 
	 */
	public class Sort45Calculater implements ISortCalculater
	{
		/**
		 * 网格宽高比
		 */
		static public var wh:Number = 2.0;
		/**
		 * 最大场景宽度
		 */
		static public var maxViewportWidth:Number = 50000;
		
		public var target:DisplayObject;
		public var offestY:Number = 0.0;
		
		public function Sort45Calculater(target:DisplayObject)
		{
			this.target = target;
		}
		
		public function calculate():Number
		{
			var targetX:Number = target.x;
			var targetY:Number = target.y + offestY;
			var x:Number = targetX + targetY * wh
			var y:Number = targetY - targetX / wh;
			return x + y * maxViewportWidth; 
		}
	}
}