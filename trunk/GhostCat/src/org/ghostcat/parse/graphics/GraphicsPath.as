package org.ghostcat.parse.graphics
{
	import flash.display.Graphics;
	import flash.geom.Point;
	
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
		 * @param para	每个参数都是数组，内容可以是一个点（折线），也可以是包含两个点的数组（曲线）。
		 * 
		 */
		public function GraphicsPath(points:Array)
		{
			this.points = points;
		}
		
		public override function parseGraphics(target:Graphics) : void
		{
			var p:Point = points[0] as Point;
			var p2:Point;
			target.moveTo(p.x,p.y);
			for (var i:int = 1;i<points.length;i++)
			{
				if (points[i] is Point)
				{
					p = points[i];
					target.lineTo(p.x,p.y);
				}
				else if (points[i] is Array)
				{
					p = points[i][0];
					p2 = points[i][1];
					target.curveTo(p.x,p.y,p2.x,p2.y);
				}
			}
		}	
	}
}