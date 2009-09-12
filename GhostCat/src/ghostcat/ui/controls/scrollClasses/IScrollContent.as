package ghostcat.ui.controls.scrollClasses
{
	public interface IScrollContent
	{
		function get maxScrollH():int
		function get maxScrollV():int
		function get scrollH():int
		function get scrollV():int
		function set scrollH(v:int):void
		function set scrollV(v:int):void
	}
}