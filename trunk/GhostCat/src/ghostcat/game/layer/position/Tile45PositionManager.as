package ghostcat.game.layer.position
{
	import flash.geom.Point;
	
	import ghostcat.display.game.Display45Util;

	/**
	 * 等角网格转换器 
	 * @author flashyiyi
	 * 
	 */
	public class Tile45PositionManager extends TilePositionManager
	{
		public function Tile45PositionManager(tileWidth:Number,tileHeight:Number,offestX:Number = 0.0,offestY:Number = 0.0):void
		{
			super(tileWidth,tileHeight,offestX,offestY);
		}
		
		public override function untransform(p:Point):Point
		{
			var x:Number = p.x;
			var y:Number = p.y;
			return new Point((x + y) / tileWidth - offestX,(y - x) / tileHeight - offestY);
		}
		
		public override function transform(p:Point):Point
		{
			var x:Number = p.x;
			var y:Number = p.y;
			return new Point((x - y) / 2 * tileWidth + offestX, (x + y) / 2 * tileHeight + offestY);
		}
	}
}