package org.ghostcat.events
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	public class DragEvent extends Event
	{
		/**
		 * 开始拖动（可中断）
		 */
		public static const DRAG_START:String="drag_start";
		
		/**
		 * 拖动过程中每帧执行一次
		 */
		public static const DRAG_ON:String="drag_on";
		
		/**
		 * 停止拖动（可中断）
		 */
		public static const DRAG_STOP:String="drag_stop";
		
		/**
		 * 有物品拖动到自己之上
		 */
		public static const DRAG_OVER:String="drag_over";
		
		/**
		 * 有物品拖离自己
		 */
		public static const DRAG_OUT:String="drag_out";
		
		/**
		 * 拖动的物品
		 */
		public var dragObj:DisplayObject;
		
		public function DragEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}