package ghostcat.ui.scroll
{
	import flash.display.DisplayObject;
	import flash.events.EventDispatcher;
	
	/**
	 * 不设置ScrollRect的方式，同时亦不需要分层
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class RollContent extends EventDispatcher implements IScrollContent
	{
		private var target:DisplayObject;
		
		private var _maxScrollH:int = int.MAX_VALUE;
		private var _maxScrollV:int = int.MAX_VALUE;
		private var _tweenTargetH:Number = 0;
		private var _tweenTargetV:Number = 0;
		
		public function RollContent(target:DisplayObject)
		{
			this.target = target;
		}
		/** @inheritDoc*/
		public function get content():DisplayObject
		{
			return target;
		}
		/** @inheritDoc*/
		public function get maxScrollH():int
		{
			return _maxScrollH;
		}
		/** @inheritDoc*/
		public function get maxScrollV():int
		{
			return _maxScrollV;
		}
		/** @inheritDoc*/
		public function set maxScrollH(v:int):void
		{
			_maxScrollH = v;
		}
		/** @inheritDoc*/
		public function set maxScrollV(v:int):void
		{
			_maxScrollV = v;
		}
		/** @inheritDoc*/
		public function get scrollH():int
		{
			return -content.x;
		}
		/** @inheritDoc*/
		public function get scrollV():int
		{
			return -content.y;
		}
		/** @inheritDoc*/
		public function set scrollH(v:int):void
		{
			content.x = -v;
		}
		/** @inheritDoc*/
		public function set scrollV(v:int):void
		{
			content.y = -v;
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