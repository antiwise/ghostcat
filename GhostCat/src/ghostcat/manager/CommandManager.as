package ghostcat.manager
{
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	
	/**
	 * 将某个事件绑定到一个某个特定类来进行处理。
	 * 
	 *  
	 * 默认事件是ActionEvent，按钮设置了action属性后会自动发布ActionEvent
	 * @see ghostcat.events.ActionEvent
	 * 
	 * @author flashyiyi
	 * 
	 */	
	public class CommandManager
	{
		import flash.events.EventDispatcher;
		import flash.events.Event;

		private static var list:Dictionary = new Dictionary();
		
		/**
		 * 注册方法
		 * 
		 * @param target	目标，正常情况下为stage
		 * @param event	需要监听的事件类型
		 * @param command	用来处理事件的类
		 * @param actionField	指定事件中某个属性为处理类的方法名
		 * @param parmField	指定事件中某个属性为执行方法的参数（数组）
		 * 
		 */		
		public static function register(target:EventDispatcher,event:String,command:*,actionField:String="action",parmField:String="parameters"):void
		{
			new CommandManager(target,event,command,actionField,parmField);
		}
		
		/**
		 * 取消注册 
		 * @param command
		 * 
		 */
		public static function unregister(command:*):void
		{
			(list[command] as CommandManager).destory();
		}
		
		private var target:EventDispatcher;
		private var event:String;
		private var command:*;
		private var actionField:String;
		private var parmField:String;
		
		public function CommandManager(target:EventDispatcher,event:String,command:*,actionField:String="action",parmField:String="parameters")
		{
			this.target = target;
			this.event = event;
			this.command = command;
			this.actionField = actionField;
			this.parmField = parmField;
			
			target.addEventListener(event,handler);
			
			list[command] = this;
		}
		
		/**
		 * 处理方法 
		 * @param event
		 * 
		 */
		protected function handler(event:Event):void
		{
			var action:String = event.hasOwnProperty(actionField) ? event[actionField] : null;
			if (action == null)
				return;
			
			var parm:* = event.hasOwnProperty(actionField) ? event[parmField] : null;
			if (!(parm is Array))
				parm = [parm];
			
			(command[action] as Function).apply(null,parm);
		}
		
		/**
		 * 销毁方法 
		 * 
		 */
		public function destory():void
		{
			target.removeEventListener(event,handler);
			delete list[command];
		}
	}
}