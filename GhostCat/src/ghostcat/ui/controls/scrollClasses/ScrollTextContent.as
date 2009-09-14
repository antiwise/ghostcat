package ghostcat.ui.controls.scrollClasses
{
	import flash.display.DisplayObject;
	import flash.events.EventDispatcher;
	import flash.text.TextField;

	public class ScrollTextContent extends EventDispatcher implements IScrollContent
	{
		private var target:TextField;
		
		private var _oldScrollH:int;
		private var _oldScrollV:int;
		
		public function ScrollTextContent(target:TextField)
		{
			this.target = target;
		}
		
		public function get content():DisplayObject
		{
			return target;
		}
		
		public function get maxScrollH():int
		{
			return target.maxScrollH;
		}
		
		public function get maxScrollV():int
		{
			return target.maxScrollV;
		}
		
		public function get oldScrollH():int
		{
			return _oldScrollH;
		}
		
		public function get scrollH():int
		{
			return	target.scrollH;
		}
		
		public function set scrollH(v:int):void
		{
			_oldScrollH = target.scrollH;
			target.scrollH = v;
		}
		
		public function get oldScrollV():int
		{
			return _oldScrollV;
		}
		
		public function get scrollV():int
		{
			return	target.scrollV;
		}
		
		public function set scrollV(v:int):void
		{
			_oldScrollV = target.scrollV;
			target.scrollV = v;
		}
	}
}