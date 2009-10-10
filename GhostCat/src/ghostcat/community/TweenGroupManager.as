package ghostcat.community
{
	import flash.display.DisplayObject;
	
	import ghostcat.util.Util;
	import ghostcat.util.easing.TweenUtil;

	/**
	 * Tween群组执行
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class TweenGroupManager extends GroupManager
	{
		/**
		 * 每个动画的执行时间
		 */
		public var duration:int;
		/**
		 * 缓动参数
		 */
		public var params:Object;
		/**
		 * 是否倒放 
		 */
		public var invert:Boolean = false;
		/**
		 * 顺序执行延迟
		 */
		public var delay:int = 0;
		public function TweenGroupManager(duration:int,params:Object,delay:int = 100,invert:Boolean = false)
		{
			this.duration = duration;
			this.params = params;
			this.delay = delay;
			this.invert = invert;
			
			super(tweenCommand);
		}
		
		/**
		 * 执行缓动
		 * @param v
		 * 
		 */
		protected function tweenCommand(v:DisplayObject):void
		{
			var o:Object = Util.copy(params);
			o.delay = data.indexOf(v) * delay;
			
			TweenUtil.to(v,duration,o);
		}
	}
}