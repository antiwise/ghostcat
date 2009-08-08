package org.ghostcat.events
{
	import flash.events.Event;
	
	public class TimeLineEvent extends Event
	{
		/**
		 * 帧标签改变
		 */
		public static const LABEL_CHANGED:String = "label_changed";
		
		/**
		 * 动画结束
		 */
		public static const TIMELINE_END:String = "timeline_end";
		
		/**
		 * 上一个帧标签
		 */
		public var prevLabel:String;
		
		/**
		 * 当前帧标签
		 */
		public var label:String;
		
		/**
		 * 上一帧
		 */		
		public var prevFrame:String
		
		/**
		 * 当前帧
		 */
		public var frame:String;
		
		public function TimeLineEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}