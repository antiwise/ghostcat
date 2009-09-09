package org.ghostcat.ui.controls.scrollClasses
{
	import flash.display.DisplayObject;
	import flash.events.EventDispatcher;
	import flash.geom.Rectangle;
	import flash.text.TextField;

	public class ScrollTextContent extends EventDispatcher implements IScrollContent
	{
		public var target:TextField;
		
		public function ScrollTextContent(target:TextField)
		{
			this.target = target;
		}
		
		public function get maxScrollH():int
		{
			return target.maxScrollH;
		}
		
		public function get maxScrollV():int
		{
			return target.maxScrollV;
		}
		
		public function get scrollH():int
		{
			return	target.scrollH;
		}
		
		public function set scrollH(v:int):void
		{
			target.scrollH = v;
		}
		
		public function get scrollV():int
		{
			return	target.scrollV;
		}
		
		public function set scrollV(v:int):void
		{
			target.scrollV = v;
		}
	}
}