package ghostcat.game.layer.position
{
	import flash.geom.Point;
	
	import ghostcat.game.layer.GameLayerBase;

	public interface IPositionManager
	{
		function setObjectPosition(obj:*,p:Point):void
		function getObjectPosition(obj:*):Point;
	}
}