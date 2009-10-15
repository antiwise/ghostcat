package ghostcat.operation
{
	import flash.geom.Point;
	
	import ghostcat.util.easing.TweenEvent;
	import ghostcat.util.easing.TweenUtil;
	import ghostcat.algorithm.bezier.SmoothCurve;
	
	/**
	 * 曲线缓动
	 *  
	 * @author flashyiyi
	 * 
	 */
	public class SmoothCurveTweenOper extends TweenOper
	{
		/**
		 * 曲线实例
		 */
		public var smoothCurve:SmoothCurve;
		
		public function SmoothCurveTweenOper(target:*=null, smoothCurve:SmoothCurve=null, duration:int=100, params:Object=null, invert:Boolean=false)
		{
			this.smoothCurve = smoothCurve;
			
			super(target, duration, params, invert);
		}
		/** @inheritDoc*/
		public override function execute() : void
		{
			super.execute();
			
			tween.addEventListener(TweenEvent.TWEEN_UPDATE,updateHandler);
		}
		/** @inheritDoc*/
		public override function result(event:*=null) : void
		{
			super.result(event);
			tween.removeEventListener(TweenEvent.TWEEN_UPDATE,updateHandler);
		}
		/** @inheritDoc*/
		public override function fault(event:*=null) : void
		{
			super.fault(event);
			tween.removeEventListener(TweenEvent.TWEEN_UPDATE,updateHandler);
		}
		
		/**
		 * 更新图像 
		 * @param event
		 * 
		 */
		protected function updateHandler(event:TweenEvent):void
		{
			var r:Number = tween.currentTime / tween.duration;
			var p:Point = smoothCurve.getPointByDistance(smoothCurve.length * r);
			target.x = p.x;
			target.y = p.y;
		}
	}
}