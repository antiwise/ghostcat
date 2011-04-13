package ghostcat.ui
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;
	
	/**
	 * 设置一组对象的属性，对其设置属性以及调用函数将会影响到所有的子对象
	 * @author flashyiyi
	 * 
	 */
	dynamic public class Group extends Proxy 
	{
		public var children:Array;
		private var data:Object;
		
		public function Group(children:Array)
		{
			this.children = children;
			this.data = {};
		}
		
		private var _groupX:Number = 0.0;
		private var _groupY:Number = 0.0;
		
		/**
		 * 设置Group的横坐标
		 * @return 
		 * 
		 */
		public function get groupX():Number
		{
			return _groupX;
		}

		public function set groupX(value:Number):void
		{
			var dv:Number = value - _groupX;
			_groupX = value;
			
			for (var i:int = 0; i < children.length;i++)
			{
				var child:* = children[i];
				if (child && child.hasOwnProperty("x"))
					child["x"] += dv;
			}
		}
		
		/**
		 * 设置Group的纵坐标
		 * @return 
		 * 
		 */
		public function get groupY():Number
		{
			return _groupY;
		}
		
		public function set groupY(value:Number):void
		{
			var dv:Number = value - _groupY;
			_groupY = value;
			
			for (var i:int = 0; i < children.length;i++)
			{
				var child:* = children[i];
				if (child && child.hasOwnProperty("y"))
					child["y"] += dv;
			}
		}
		
		

		flash_proxy override function callProperty(methodName:*, ...args):*
		{
			var result:Array = [];
			for (var i:int = 0; i < children.length;i++)
			{
				var child:* = children[i];
				if (child && child.hasOwnProperty(methodName) && child[methodName] is Function)
					result[i] = (child[methodName] as Function).apply(null,args);
			}
			return result;
		}
		
		flash_proxy override function getProperty(property:*):* 
		{
			return data[property];
		}
		
		flash_proxy override function setProperty(property:*,value:*):void 
		{
			data[property] = value;
			for (var i:int = 0; i < children.length;i++)
			{
				var child:* = children[i];
				if (child && child.hasOwnProperty(property))
					child[property] = value;
			}
		}
	}
}