package ghostcat.operation.effect
{
	import flash.filters.GlowFilter;
	
	import ghostcat.filter.FilterProxy;
	import ghostcat.operation.FunctionOper;

	/**
	 * 发光一次的效果
	 * @author flashyiyi
	 * 
	 */
	public class LightOnceEffect extends QueueEffect
	{
		private var blurProxy:FilterProxy;
		
		private var _target:*;
		/** @inheritDoc*/
		public override function get target():*
		{
			return _target;
		}

		public override function set target(v:*):void
		{
			_target = v;
		}
		
		public function LightOnceEffect(target:*, duration:int, color:uint = 0xFFFFFF, alpha:Number = 1.0, blurX:Number = 16, blurY:Number = 16, strength:Number = 2)
		{
			this.target = target;
			this.blurProxy = new FilterProxy(new GlowFilter(color,0,0,0,strength));
			
			var list:Array = [new TweenEffect(blurProxy,duration,{alpha:alpha,blurX:blurX,blurY:blurX}),
							new TweenEffect(blurProxy,duration,{alpha:0,blurX:0,blurY:0}),
							new FunctionOper(blurProxy.removeFilter)];
			super(list);
		}
		/** @inheritDoc*/
		public override function execute() : void
		{
			blurProxy.applyFilter(target);
			
			super.execute();
		}
	}
}