package ghostcat.community
{
	import flash.display.DisplayObjectContainer;

	public interface IGroupManager
	{
		function add(v:*,checkDup:Boolean = true):void
		function remove(v:*):void
		function addAll(v:*):void
		function removeAll(v:*=null):void
		function calculate(v:*):void
		function calculateAll(onlyFilter:Boolean = true):void
		function destory():void
	}
}