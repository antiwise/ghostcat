package ghostcat.game.item.sort
{
	import flash.display.DisplayObject;

	public interface ISortCalculater
	{
		function set target(value:DisplayObject):void
		function get target():DisplayObject;
		
		function calculate():Number	
	}
}