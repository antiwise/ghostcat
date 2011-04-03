package ghostcat.extend
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.TimerEvent;
	import flash.external.ExternalInterface;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	import flash.utils.getQualifiedClassName;
	
	[Event(name="timer", type="flash.events.TimeEvent")]
	[Event(name="timer_complete", type="flash.events.TimeEvent")]
	
	/**
	 * JS实现的定时器
	 * @author flashyiyi
	 * 
	 */
	public class JSTimer extends EventDispatcher
	{
		[Embed(source="JSTimer.js",mimeType="application/octet-stream")]
		static private var jsCode:Class;
		
		static private var isRegistered:Boolean;
		static public function register(root:DisplayObject):void
		{
			if (ExternalInterface.available)
			{
				isRegistered = true;
				
				ExternalInterface.call("eval",new jsCode().toString());
				ExternalInterface.call("JSTimer.init",getQualifiedClassName(root));
				ExternalInterface.addCallback("jsTimeHandler", jsTimeHandler);
			}
		}
		
		static private function jsTimeHandler(id:String):void
		{
			JSTimer(dict[id]).timeHandler();
		}
		
		private static var dict:Dictionary = new Dictionary();
		private static var curMaxId:int = 0;
		
		private var id:int;
		private var intervalID:int;
		private var _delay:Number;
		private var _isRunning:Boolean;
		
		public function get delay():Number
		{
			return _delay;
		}
		
		public var repeatCount:int;
		public var currentCount:int;
		public function get isRunning():Boolean
		{
			return _isRunning;
		}
		public function JSTimer(delay:Number,repeatCount:int)
		{
			this.id = curMaxId++;
			this._delay = delay;
			this.repeatCount = repeatCount;
			
			this.reset();
		}
		
		public function reset():void
		{
			this.currentCount = 0;
		}
		
		public function start():void
		{
			if (!isRegistered)
				throw new Error("请先执行JSTimer.register")
			
			intervalID = ExternalInterface.call("JSTimer.start",id,delay);
			_isRunning = true;
			dict[id] = this;
		}
		
		private function timeHandler():void
		{
			dispatchEvent(new TimerEvent(TimerEvent.TIMER));
			currentCount++;
			
			if (currentCount >= repeatCount)
			{
				dispatchEvent(new TimerEvent(TimerEvent.TIMER_COMPLETE));
				stop();
			}
		}
		
		public function stop():void
		{
			if (!isRegistered)
				throw new Error("请先执行JSTimer.register")
			
			ExternalInterface.call("JSTimer.stop",intervalID);
			_isRunning = false;
			delete dict[id];
		}
	}
}