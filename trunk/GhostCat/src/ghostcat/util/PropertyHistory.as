package ghostcat.util
{
	import flash.events.Event;
	import flash.utils.flash_proxy;

	use namespace flash_proxy;
	[Event(name="change",type="flash.events.Event")]
	
	/**
	 * 使用备忘录模式提供简单的undo和redo的功能
	 * 
	 * @author flashyiyi
	 * 
	 */
	dynamic public class PropertyHistory extends ObjectProxy
	{
		private var propertys:Array;
		private var _stepIndex:int = -1;
		
		/**
		 * 状态数据
		 */
		public var steps:Array = [];
		/**
		 * 是否自动记录状态
		 */
		public var autoRecord:Boolean = true;
		
		public function PropertyHistory(obj:*, propertys:Array=null)
		{
			super(obj);
			this.propertys = propertys;
			
			record();
		}
		
		/**
		 * 批量设置属性，只会触发一次record
		 * @param params
		 * @return 
		 * 
		 */
		public function setPropertys(params:Object):void
		{
			for (var key:* in params)
				data[key] = params[key];
		
			if (autoRecord)
				record();
		}
		
		/**
		 * 修改状态
		 * @return 
		 * 
		 */
		public function get stepIndex():int
		{
			return _stepIndex;
		}
		
		public function set stepIndex(v:int):void
		{
			if (v < 0)
				v = 0;
			
			if (v > steps.length - 1)
				v = steps.length - 1;
			
			if (_stepIndex == v)
				return;
			
			_stepIndex = v;
		
			for (var i:int = 0;i < propertys.length;i++)
			{
				var property:String = propertys[i];
				data[property] = steps[_stepIndex][i];
			}
		}
		
		/**
		 * 记录状态 
		 * 
		 */
		public function record():void
		{
			var arr:Array = [];
			for (var i:int = 0;i < propertys.length;i++)
			{
				var property:String = propertys[i];
				arr.push(data[property]);
			}
			
			steps = steps.slice(0,_stepIndex + 1);
			steps.push(arr);
			
			_stepIndex++;
			
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		/**
		 * 回归到最初的状态
		 * 
		 */
		public function reset():void
		{
			stepIndex = 0;
		}
		
		/**
		 * 撤销
		 * 
		 */
		public function undo():void
		{
			stepIndex--;
		}
		
		/**
		 * 恢复
		 * 
		 */
		public function redo():void
		{
			stepIndex++;
		}
		
		flash_proxy override function setProperty(property:*,value:*):void 
		{
			super.setProperty(property,value);
			
			if (autoRecord)
				record();
		}
	}
}