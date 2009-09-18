package ghostcat.ui.classes.scroll
{
	import flash.display.DisplayObject;
	import flash.events.IEventDispatcher;

	[Event(name="scroll",type="flash.events.Event")]
	
	public interface IScrollContent extends IEventDispatcher
	{
		function get content():DisplayObject;
		
		function get maxScrollH():int
		function get maxScrollV():int
		function get scrollH():int
		function get scrollV():int
		function set scrollH(v:int):void
		function set scrollV(v:int):void
	}
}