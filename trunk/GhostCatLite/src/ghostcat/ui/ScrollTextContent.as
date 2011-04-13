package ghostcat.ui
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
		private var _tweenTargetH:Number = NaN;
		private var _tweenTargetV:Number = NaN;
		
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
		
		private var _wheelDirect:String;
		
		/**
		 * 鼠标滚动方向
		 */
		public function get wheelDirect():String
		{
			return _wheelDirect;
		}
		
		public function set wheelDirect(value:String):void
		{
			_wheelDirect = value;
		}
		
		private var _wheelSpeed:Number = 1.0;
		
		/**
		 * 鼠标滚动速度（像素）
		 */
		public function get wheelSpeed():Number
		{
			return _wheelSpeed;
		}
		
		public function set wheelSpeed(value:Number):void
		{
			_wheelSpeed = value;
		}
		
		/** @inheritDoc*/
		public function get maxScrollH():int
		{
			return target.maxScrollH;
		}
		/** @inheritDoc*/
		public function get maxScrollV():int
		{
			return target.maxScrollV - 1;
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
			return	target.scrollV - 1;
		}
		/** @inheritDoc*/
		public function set scrollV(v:int):void
		{
			target.scrollV = v + 1;
		}
		/** @inheritDoc*/
		public function get tweenTargetH():Number
		{
			return _tweenTargetH;
		}
		/** @inheritDoc*/
		public function get tweenTargetV():Number
		{
			return _tweenTargetV;
		}
		/** @inheritDoc*/
		public function set tweenTargetH(v:Number):void
		{
			_tweenTargetH = v;
		}
		/** @inheritDoc*/
		public function set tweenTargetV(v:Number):void
		{
			_tweenTargetV = v;
		}
	}
}