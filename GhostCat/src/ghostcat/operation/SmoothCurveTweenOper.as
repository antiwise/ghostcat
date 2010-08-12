package ghostcat.operation
{
	import flash.geom.Point;
	
	import ghostcat.algorithm.bezier.SmoothCurve;
	import ghostcat.util.easing.TweenEvent;
	
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
		
		/**
		 * 是否激活角度变化
		 */
		public var applyAngle:Boolean = true;
		
		public function SmoothCurveTweenOper(target:*=null, smoothCurve:SmoothCurve=null, duration:int=100, params:Object=null, invert:Boolean=false, applyAngle:Boolean = true)
		{
			this.smoothCurve = smoothCurve;
			this.applyAngle = applyAngle;
			
			super(target, duration, params, invert);
		}
		/** @inheritDoc*/
		public override function execute() : void
		{
			super.execute();
			tween.addEventListener(TweenEvent.TWEEN_UPDATE,updateHandler);
		}
		/** @inheritDoc*/
		protected override function end(event:*=null) : void
		{
			super.end(event);
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
			if (applyAngle)
			{
				var angle:Number = smoothCurve.getTangentAngleByDistance(smoothCurve.length * r);
				target.rotation = angle / Math.PI * 180;
			}
		}
	}
}