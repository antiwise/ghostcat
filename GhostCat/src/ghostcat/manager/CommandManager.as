package ghostcat.manager
{
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	
	/**
	 * 将某个事件绑定到一个某个特定类来进行处理。
	 * 
	 * 利用AS3自带的事件冒泡，显示对象可以通过对自己发布冒泡事件，让事件得以发布到应用的顶端，也就是stage。
	 * 接着，使用此类将stage上的这个事件转移到特定类上，制定好处理规则。可以实现最简单的V->C的过程。
	 * C->M不用说。M->V的过程可以利用FLEX的绑定，具体可参考例子BindingExample.as
	 *  
	 * 默认事件是这个，按钮设置了action属性后会自动发布ActionEvent
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
		
		private function handler(event:Event):void
		{
			var action:String = event[actionField];
			if (action == null)
				return;
			var parm:* = event[parmField];
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