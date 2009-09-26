package ghostcat.operation
{
	import ghostcat.events.TweenEvent;
	import ghostcat.util.TweenUtil;

	/**
	 * 与内部Tween对应的Oper
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class TweenOper extends Oper
	{
		private var _target:*;

		/**
		 * 目标
		 * @return 
		 * 
		 */
		public function get target():*
		{
			return _target;
		}

		public function set target(v:*):void
		{
			_target = v;
		}

		/**
		 * 持续时间
		 */
		public var duration:int;
		/**
		 * 参数
		 */
		public var params:Object;
		
		/**
		 * 缓动实例 
		 */
		public var tween:TweenUtil;
		
		public function TweenOper(target:*=null,duration:int=100,params:Object=null,invert:Boolean = false)
		{
			super();
			this._target = target;
			this.duration = duration;
			this.params = params;
			
			if (invert)
				this.invert = invert;
			
		}
		
		/**
		 * 是否倒放
		 * @return 
		 * 
		 */
		public function get invert():Boolean
		{
			return this.params.invert;
		}

		public function set invert(v:Boolean):void
		{
			if (!params)
				params = new Object()
			this.params.invert = v;
		}
		/** @inheritDoc*/
		public override function execute() : void
		{
			super.execute();
			tween = new TweenUtil(_target,duration,params);
			tween.addEventListener(TweenEvent.TWEEN_END,result);
		}
		/** @inheritDoc*/
		public override function result(event:*=null):void
		{
			tween.removeEventListener(TweenEvent.TWEEN_END,result);
			super.result(event);
		}
	}
}