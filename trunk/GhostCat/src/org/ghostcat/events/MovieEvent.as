package org.ghostcat.events
{
	import flash.events.Event;
	
	/**
	 * 动画事件
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class MovieEvent extends Event
	{
		/**
		 * 动画开始 
		 */		
		public static const MOVIE_START:String="label_start";
		
		/**
		 * 动画结束 
		 */		
		public static const MOVIE_END:String="label_end";
		
		/**
		 * 动画为空 
		 */		
		public static const MOVIE_EMPTY:String="label_empty";
		
		/**
		 * 动画错误 
		 */		
		public static const MOVIE_ERROR:String="label_error";
		
		/**
		 * 动画名称 
		 */		
		public var labelName:String;
		
		public function MovieEvent(type:String,bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		public override function clone() : Event
		{
			var evt:MovieEvent = new MovieEvent(type,bubbles,cancelable);
			evt.labelName = this.labelName;
			return evt;
		}
	}
}