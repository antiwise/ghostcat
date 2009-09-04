package org.ghostcat.events
{
	import flash.display.InteractiveObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * 特殊的输入事件
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class InputEvent extends MouseEvent
	{
		/**
		 * 按下按键并松开时候的发生（中途夹杂着其他按键操作则不发生）
		 */		
		public static const KEY_DOWN_UP:String = "key_down_up";
		
		/**
		 * 鼠标松开时，发布的记录包括鼠标的轨迹 
		 */
		public static const MOUSE_MOVE_PATH:String = "mouse_move_path"
		
		/**
		 * 鼠标右键
		 */		
		public static const MOUSE_RIGHT:String = "mouse_right";
		
		/**
		 * 按键的键盘码
		 */		
		public var keyCode:int;
		
		/**
		 * 鼠标运动轨迹。它是只是单纯的轨迹点的数组，具体是何种动作需要用PathAnalyzer类来判断。
		 */
		public var mousePath:Array;
		
		/**
		 * 连续按钮次数
		 */
		public var multi:int;
		
		public function InputEvent(type:String, bubbles:Boolean=true, cancelable:Boolean=false, localX:Number = NaN, localY:Number = NaN,
			relatedObject:InteractiveObject = null, ctrlKey:Boolean = false, altKey:Boolean = false, shiftKey:Boolean = false, buttonDown:Boolean = false, delta:int = 0)
		{
			super(type, bubbles, cancelable, localX, localY, relatedObject, ctrlKey, altKey, shiftKey, buttonDown, delta);
		}
		
		public override function clone() :Event
		{
			var evt:InputEvent = new InputEvent(type,bubbles,cancelable,localX,localY,relatedObject, ctrlKey, altKey, shiftKey, buttonDown, delta);
			evt.keyCode = this.keyCode;
			evt.mousePath = this.mousePath;
			evt.multi = this.multi;
			return evt;
		}
	}
}