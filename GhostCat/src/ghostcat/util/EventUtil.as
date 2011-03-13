package ghostcat.util
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import ghostcat.ui.layout.AbsoluteLayout;
	
	/**
	 * 事件辅助类
	 * @author flashyiyi
	 * 
	 */
	final public class EventUtil
	{
		/**
		 * 添加一个只执行一次的事件 
		 * @param target	事件目标
		 * @param type	事件类型
		 * @param handler	事件函数
		 * @param useParam	是否传入参数
		 * @param param	参数列表
		 * 
		 */
		static public function addEventListenerOnce(target:IEventDispatcher,type:String,handler:Function,useParam:Boolean = false, param:Array = null):void
		{
			target.addEventListener(type,eventHandler);
			function eventHandler(e:Event):void
			{
				target.removeEventListener(type,eventHandler);
				if (useParam)
					handler.apply(null,param);
				else
					handler(e);
			}
		}

	}
}