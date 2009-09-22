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
		public var target:*;
		public var duration:int;
		public var params:Object;
		
		public var tween:TweenUtil;
		
		public function TweenOper(target:*,duration:int,params:Object,invert:Boolean = false)
		{
			super();
			this.target = target;
			this.duration = duration;
			this.params = params;
			
			if (invert)
				this.invert = invert;
			
		}
		
		public function get invert():Boolean
		{
			return this.params.invert;
		}

		public function set invert(v:Boolean):void
		{
			this.params.invert = v;
		}

		public override function execute() : void
		{
			super.execute();
			tween = new TweenUtil(target,duration,params);
			tween.addEventListener(TweenEvent.TWEEN_END,result);
		}
		
		public override function result(event:*=null):void
		{
			tween.removeEventListener(TweenEvent.TWEEN_END,result);
			super.result(event);
		}
	}
}