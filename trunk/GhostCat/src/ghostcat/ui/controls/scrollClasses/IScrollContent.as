package ghostcat.ui.controls.scrollClasses
{
	import flash.display.DisplayObject;

	public interface IScrollContent
	{
		function get content():DisplayObject;
		
		function get maxScrollH():int
		function get maxScrollV():int
		function get oldScrollH():int
		function get oldScrollV():int
		function get scrollH():int
		function get scrollV():int
		function set scrollH(v:int):void
		function set scrollV(v:int):void
	}
}