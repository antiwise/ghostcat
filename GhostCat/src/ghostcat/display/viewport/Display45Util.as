package ghostcat.display.viewport
{
	import flash.geom.Point;

	public final class Display45Util
	{
		/**
		 * 最大横坐标
		 */
		public static var maxi:int = 10000;
		
		private static var _wh:Number;
		private static var _width:Number;
		private static var _height:Number;
		
		/**
		 * 格子长宽比
		 */
		public static function get wh():Number
		{
			return _wh
		}
		
		/**
		 * 格子宽度
		 */
		public static function get width():Number
		{
			return _width;
		}
		
		/**
		 * 格子高度
		 */
		public static function get height():Number
		{
			return _height;
		}
		
		
		/**
		 * 设置单个格子的大小
		 * @param w
		 * @param h
		 * 
		 */
		public static function setContentSize(w:Number,h:Number):void
		{
			_width = w;
			_height = h;
			_wh = w / h;
		}
		/**
		 * 排序函数
		 * 
		 * @param d1
		 * @param d2
		 * @return 
		 * 
		 */
		public static function SORT_45(v1:*, v2:*):int
		{
			if (!wh)
				throw new Error("请先执行Display45Util.setContentSize方法");
			
			var p1:Point = getItemPointAtPoint(new Point(v1.x,v1.y),width,height);
			var p2:Point = getItemPointAtPoint(new Point(v2.x,v2.y),width,height);
			
			var d:int = (p1.x + p1.y * maxi) - (p2.x + p2.y * maxi);
			if (d > 0)
				return 1;
			else if (d < 0)
				return -1;
			else
				return (v1.y > v2.y) ? 1 : -1;
		}
		
		/**
		 * 获得屏幕上点的方块索引坐标 
		 * @param p
		 * @param width
		 * @param height
		 * @return 
		 * 
		 */
		public static function getItemPointAtPoint(p:Point,width:Number = NaN,height:Number = NaN):Point
		{
			if (isNaN(height))
				width = Display45Util.width;
			if (isNaN(height))
				height = Display45Util.height;
			
			p = trans45To90(p);
			return new Point(int(p.x / width), int(p.y / height)); 
		}
		
		/**
		 * 从45度显示坐标换算为90度
		 * @param p
		 * @return 
		 * 
		 */
		public static function trans45To90(p:Point,wh:Number = NaN):Point
		{
			if (isNaN(wh))
				wh = Display45Util.wh;
			return new Point(p.x + p.y * wh,p.y - p.x/wh);
		}
		
		/**
		 * 从90度换算为45度显示坐标
		 * @param p
		 * @return 
		 * 
		 */
		public static function trans90To45(p:Point,wh:Number = NaN):Point
		{
			if (isNaN(wh))
				wh = Display45Util.wh;
			return new Point((p.x - p.y * wh)/2,(p.x / wh + p.y)/2);
		}
	}
}