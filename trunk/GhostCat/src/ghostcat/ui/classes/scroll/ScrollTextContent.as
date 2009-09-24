package ghostcat.ui.classes.scroll
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.text.TextField;
	
	/**
	 * 文本框滚动
	 * @author flashyiyi
	 * 
	 */
	public class ScrollTextContent extends EventDispatcher implements IScrollContent
	{
		private var target:TextField;
		
		public function ScrollTextContent(target:TextField)
		{
			this.target = target;
			target.addEventListener(Event.SCROLL,scrollHandler,false,0,true);
		}
		
		private function scrollHandler(event:Event):void
		{
			dispatchEvent(new Event(Event.SCROLL));
		}
		/** @inheritDoc*/
		public function get content():DisplayObject
		{
			return target;
		}
		/** @inheritDoc*/
		public function get maxScrollH():int
		{
			return target.maxScrollH;
		}
		/** @inheritDoc*/
		public function get maxScrollV():int
		{
			return target.maxScrollV;
		}
		/** @inheritDoc*/
		public function get scrollH():int
		{
			return	target.scrollH;
		}
		/** @inheritDoc*/
		public function set scrollH(v:int):void
		{
			target.scrollH = v;
		}
		/** @inheritDoc*/
		public function get scrollV():int
		{
			return	target.scrollV;
		}
		/** @inheritDoc*/
		public function set scrollV(v:int):void
		{
			target.scrollV = v;
		}
	}
}