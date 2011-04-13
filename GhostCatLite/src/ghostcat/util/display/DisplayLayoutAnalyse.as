package ghostcat.util.display
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	
	import ghostcat.debug.Debug;
	import ghostcat.util.Util;

	/**
	 * 分析显示对象的位置长宽数据
	 * @author flashyiyi
	 * 
	 */
	public class DisplayLayoutAnalyse
	{
		/**
		 * 分析显示对象列表得到关于布局的数据
		 * @param obj
		 * @param onlyInteractiveObject	只获取文本和容器
		 * @param onlyHasName	只获取取名后的对象
		 * @return 
		 * 
		 */
		static public function analyse(obj:DisplayObject,onlyInteractiveObject:Boolean = false,onlyHasName:Boolean = false):Object
		{
			var o:Object = {
				name:obj.name,
				visible:obj.visible,
				x:obj.x,
				y:obj.y,
				width:obj.width,
				height:obj.height,
				scaleX:obj.scaleX,
				scaleY:obj.scaleY,
				rotation:obj.rotation,
				transform:obj.transform
			};
			
			if (obj is DisplayObjectContainer)
			{
				var container:DisplayObjectContainer = DisplayObjectContainer(obj);
				var children:Array = [];
				var l:int = container.numChildren;
				for (var i:int = 0;i < l;i++)
				{
					var child:DisplayObject = container.getChildAt(i);
					if ((!onlyInteractiveObject || child is InteractiveObject) && (!onlyHasName || child.name.slice(0,8) != "instance"))
						children[children.length] = analyse(container.getChildAt(i),onlyInteractiveObject,onlyHasName);
				}
				
				o.children = children;
			}
			return o;
		}
		
		
		/**
		 * 获得某个名称对象的数据 
		 * @param obj
		 * @param name
		 * @return 
		 * 
		 */
		static public function findChildByName(obj:Object,name:String):Object
		{
			if (obj.name == name)
				return obj;
			
			if (obj.children)
			{
				for each (var child:Object in obj.children)
				{
					var obj:Object = findChildByName(child,name);
					if (obj)
						return obj;
				}
			}
			
			return null;
		}
		
		/**
		 * 输出字符串 
		 * @param deep
		 * @return 
		 * 
		 */
		static public function toString(obj:Object,deep:String = " | "):String
		{
			var s:String = "";
			var pList:Array = ["name","visible","x","y","width","height","scaleX","scaleY","rotation"];
			for each (var key:String in pList)
			{
				if (s != "")
					s += " ";
					
				s += key + "=" + obj[key];
			}
			s = "[" + s +"]" + "\n";
			
			var children:Array = obj.children;
			for each (var child:Object in children)
				s += deep + toString(child,deep + " | ") + "\n";
			
			return s;
		}
		
		/**
		 * 分析后的对象 
		 */
		public var data:Object;
		public function DisplayLayoutAnalyse(obj:DisplayObject,onlyInteractiveObject:Boolean = true,onlyHasName:Boolean = true):void
		{
			if (obj)
				this.analyse(obj,onlyInteractiveObject,onlyHasName);
		}
		
		/**
		 * 分析显示对象列表得到关于布局的数据
		 * @param obj
		 * @param onlyInteractiveObject	只获取文本和容器
		 * @param onlyHasName	只获取取名后的对象
		 * @return 
		 * 
		 */
		public function analyse(obj:DisplayObject,onlyInteractiveObject:Boolean = true,onlyHasName:Boolean = true):void
		{
			this.data = DisplayLayoutAnalyse.analyse(obj,onlyInteractiveObject,onlyHasName);
		}
		
		/**
		 * 获得某个名称对象的数据 
		 * @param obj
		 * @param name
		 * @return 
		 * 
		 */
		public function findChildByName(name:String):Object
		{
			return DisplayLayoutAnalyse.findChildByName(this.data,name);
		}
		
		/**
		 * 输出字符串 
		 * @param deep
		 * @return 
		 * 
		 */
		public function toString():String
		{
			return DisplayLayoutAnalyse.toString(this.data);
		}
	}
}