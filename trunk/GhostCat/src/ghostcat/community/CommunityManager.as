package ghostcat.community
{
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	
	import ghostcat.util.Util;
	
	/**
	 * 二维的遍历
	 * command将具有两个参数,分别指向两个物体
	 * 
	 * @author flashyiyi
	 * 
	 */	
	public class CommunityManager extends GroupManager
	{
		public function CommunityManager(command:Function)
		{
			tickWithFilter = true;
			super(command);
		}
		
		/**
		 * 多对多重复遍历所有内容一次
		 * 
		 * @param filter	是否只遍历已经注册变化的对象。设为true时，只有执行过setDirty()方法的对象会被遍历
		 * 
		 */
		public override function calculateAll(onlyFilter:Boolean = false):void
		{
			var values:Array = data;
			if (onlyCheckValues)
				values = onlyCheckValues;
			
			for (var i:int = 0; i < values.length;i++)
			{
				var v:* = values[i];
				if (!onlyFilter || dirtys[v])
					calculate(v);
			}
			dirtys = new Dictionary();
			
		}
		
		/**
		 * 一对多单独遍历一个对象
		 * 
		 * @param v	数据
		 * 
		 */				
		public override function calculate(v:*):void
		{
			if (filter!=null && filter(v)==false)
				return;
			
			for (var i:int = 0; i < data.length;i++)
			{
				var v2:* = data[i];
				if (v != v2 && !(filter!=null && filter(v2)==false))
					command(v,v2);
			}
		}
	}
}