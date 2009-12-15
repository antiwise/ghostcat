package ghostcat.parse.display
{
	import flash.geom.Point;
	
	import ghostcat.parse.graphics.IGraphicsFill;
	import ghostcat.parse.graphics.IGraphicsLineStyle;
	
	public class RadiusPolygonParse extends PathParse
	{
		public function RadiusPolygonParse(x:Number,y:Number,radiuses:Array, line:IGraphicsLineStyle=null, fill:IGraphicsFill=null, grid9:Grid9Parse=null, reset:Boolean=false)
		{
			var len:int = radiuses.length;
			var dr:Number = Math.PI * 2 / len;
			var points:Array = [];
			for (var i:int = 0;i < len;i++)
			{
				var radius:Number = radiuses[i];
				points.push(new Point(x + Math.cos(dr * i) * radius,y + Math.sin(dr * i) * radius));
			}
			super(points, line, fill, grid9, reset);
		}
	}
}