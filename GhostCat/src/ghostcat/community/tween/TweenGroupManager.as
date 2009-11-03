package ghostcat.community.tween
{
	import flash.display.DisplayObject;
	
	import ghostcat.community.GroupManager;
	import ghostcat.util.Util;
	import ghostcat.util.easing.TweenUtil;

	/**
	 * Tween顺序延迟群组执行
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
		
		/**
		 * 是否在倒放开始时即确认Tween属性
		 */
		public var renderOnStart:Boolean = true;
		
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
			var index:int =  invert ? (data.length - data.indexOf(v) - 1) :data.indexOf(v);
			o.delay = index * delay;
			if (renderOnStart)
				o.renderOnStart = true;
			
			TweenUtil.to(v,duration,o).update();
		}
	}
}