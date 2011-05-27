package ghostcat.game.layer.camera
{
	import flash.display.DisplayObject;
	
	import ghostcat.game.layer.GameLayer;

	public interface ICamera
	{
		function setPosition(x:Number,y:Number):void
		function render():void
		function refreshItem(item:DisplayObject):void
		function removeItem(item:DisplayObject):void
	}
}