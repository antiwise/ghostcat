package ghostcat.operation
{
	import ghostcat.operation.effect.IEffect;
	import ghostcat.util.easing.TweenEvent;
	import ghostcat.util.easing.TweenUtil;

	/**
	 * 与内部Tween对应的Oper
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class TweenOper extends Oper implements IEffect
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
		 * 是否在倒放开始的时候立即确认属性
		 */
		public var updateWhenInvent:Boolean = true;
		
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
			return this.params ? this.params.invert : false;
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
			
			if (invert && updateWhenInvent)
				tween.update();//执行update确认属性
		}
		/** @inheritDoc*/
		protected override function end(event:*=null):void
		{
			super.end(event);
			tween.removeEventListener(TweenEvent.TWEEN_END,result);
		}
	}
}