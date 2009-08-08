package org.ghostcat.parse.graphics
{
	import flash.display.Graphics;
	
	import org.ghostcat.parse.DisplayParse;
	
	/**
	 * 绘制折线。flash没有这样的东西纯属脑残表现，所以flash10新增了这样一个API。
	 * 不过这个库是针对FLASH9的，所以还是有意义的。
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class GraphicsPath extends DisplayParse
	{
		public var points:Array;
		/**
		 * 
		 * @param para	每个参数都是数组，长度2的是直线，长度4的是曲线。
		 * 
		 */
		public function GraphicsPath(points:Array)
		{
			this.points = points;
		}
		
		protected override function parseGraphics(target:Graphics) : void
		{
			target.moveTo(points[0][0],points[0][1]);
			for (var i:int = 1;i<points.length;i++)
			{
				var p:Array = points[i];
				if (p.length == 2)
					target.lineTo(p[0],p[1]);
				else if (p.length == 4)
					target.curveTo(p[0],p[1],p[2],p[3]);
			}
		}	
	}
}