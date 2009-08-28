package org.ghostcat.manager
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
	 * 标准的MVC框架之所以不适合游戏，就是因为游戏创建，删除显示对象的操作很频繁且没有规律，显示对象的数量和类型也非常多，C->V的过程难以用统一的方法解决且保证可靠性。
	 * 而M往往和V有着强烈的耦合，甚至直接就是一对一，将它们松耦完全是在自讨苦吃。而C->M的过程也和上面同理。
	 * 归根结底，就是因为游戏并不是一个规整的结构，它的结构会根据游戏内容不同而很自然地具有自己的特性，试图抛弃这种自然的特性而采用统一的方法处理，
	 * 反而会使得开发过程变得盲目，交流成本增加，效率大大降低。
	 * 但是，MVC的确是任何一个程序都必须遵守的原则，这一点并不会因为不适合标准MVC框架而改变。既然游戏拥有自己的结构特性，那么，我们就必须按照它的特性重新实现所有模式，
	 * 也就是需要一个定制的MVC框架。
	 * 
	 * 也就是说：适合“全部”游戏的MVC框架，是不存在的。这也是游戏开发难度大的原因之一。
	 * 
	 * 牢骚到此为止。在现在这个“业务逻辑就应该是后台做的”、“前台只负责表现数据”的守旧氛围里，我还是少说些危险言论比较好。
	 * 
	 * 默认事件是这个
	 * @see org.ghostcat.events.ActionEvent
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
		
		public function destory():void
		{
			target.removeEventListener(event,handler);
			delete list[command];
		}
	}
}