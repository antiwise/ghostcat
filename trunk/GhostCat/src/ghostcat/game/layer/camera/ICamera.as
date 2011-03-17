package ghostcat.game.layer.camera
{
	import flash.display.DisplayObject;
	
	import ghostcat.game.layer.GameLayerBase;

	public interface ICamera
	{
		function render():void
		function refreshItem(item:DisplayObject):void
	}
}