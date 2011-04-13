package ghostcat.game.layer.position
{
	import flash.geom.Point;
	
	import ghostcat.game.layer.GameLayer;

	public interface IPositionManager
	{
		function transform(p:Point):Point
		function untransform(p:Point):Point;
	}
}