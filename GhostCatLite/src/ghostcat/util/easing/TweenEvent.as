package ghostcat.util.easing
{
	import flash.events.Event;
	
	
	/**
	 * 缓动类事件 
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class TweenEvent extends Event
	{
		/**
		 * 缓动开始
		 */
		public static const TWEEN_START:String="tween_start";
		/**
		 * 缓动结束 
		 */
		public static const TWEEN_END:String="tween_end";
		/**
		 * 缓动更新
		 */
		public static const TWEEN_UPDATE:String="tween_update";
		
		public function TweenEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		public override function clone() : Event
		{
			var evt:TweenEvent = new TweenEvent(type,bubbles,cancelable);
			return evt;
		}
	}
}