package ghostcat.parse.graphics
{
	import flash.display.Graphics;
	import flash.geom.Point;
	
	import ghostcat.parse.DisplayParse;
	
	/**
	 * 绘制折线
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class GraphicsPath extends DisplayParse
	{
		/**
		 * 点的列表 
		 */
		public var points:Array;
		
		/**
		 * @param para	每个参数都是数组，内容可以是一个点（折线），也可以是包含两个点的数组（曲线）。
		 */
		public function GraphicsPath(points:Array)
		{
			this.points = points;
		}
		
		/** @inheritDoc*/
		public override function parseGraphics(target:Graphics) : void
		{
			var p:Point = points[0] as Point;
			target.moveTo(p.x,p.y);
			for (var i:int = 1;i < points.length;i++)
			{
				if (points[i] is Point)
				{
					p = points[i];
					target.lineTo(p.x,p.y);
				}
				else if (points[i] is Array)
				{
					p = points[i][0];
					var p2:Point = points[i][1];
					target.curveTo(p.x,p.y,p2.x,p2.y);
				}
			}
		}	
	}
}