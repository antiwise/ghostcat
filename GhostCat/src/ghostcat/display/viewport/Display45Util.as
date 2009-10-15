package ghostcat.display.viewport
{
	import flash.geom.Point;

	public final class Display45Util
	{
		/**
		 * 45度格子长宽比
		 */
		public static var wh:Number;
		
		/**
		 * 设置单个格子的大小
		 * @param w
		 * @param h
		 * 
		 */
		public static function setContentSize(w:Number,h:Number):void
		{
			wh = w / h;
		}
		/**
		 * 排序函数
		 * 
		 * @param d1
		 * @param d2
		 * @return 
		 * 
		 */
		public static function SORT_45(d1:*, d2:*):int
		{
			if (!wh)
				throw new Error("请先执行setContentSize方法");
			
			var p1:Point = new Point(d1.x + d1.y * wh,d1.y - d1.x/wh)
			var p2:Point = new Point(d2.x + d2.y * wh,d2.y - d2.x/wh)
			
			if (p1.x > p2.x || p1.y > p2.y)
				return 1;
			else
				return -1;
		}
		
		/**
		 * 从45度显示坐标换算为90度
		 * @param p
		 * @return 
		 * 
		 */
		public function trans45To90(p:Point):Point
		{
			return new Point(p.x + p.y * wh,p.y - p.x/wh);
		}
		
		/**
		 * 从90度换算为45度显示坐标
		 * @param p
		 * @return 
		 * 
		 */
		public function trans90Ti45(p:Point):Point
		{
			return new Point((p.x - p.y * wh)/2,(p.x / wh + p.y)/2);
		}
	}
}