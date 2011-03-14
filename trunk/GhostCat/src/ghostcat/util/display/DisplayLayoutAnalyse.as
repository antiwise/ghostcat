package ghostcat.util.display
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	
	import ghostcat.debug.Debug;
	import ghostcat.util.Util;

	/**
	 * 分析显示对象的位置长宽数据
	 * @author flashyiyi
	 * 
	 */
	public final class DisplayLayoutAnalyse
	{
		/**
		 * 分析显示对象列表得到关于布局的数据
		 * @param obj
		 * @return 
		 * 
		 */
		static public function analyse(obj:DisplayObject):Object
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
					children[i] = analyse(container.getChildAt(i));
				
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
		
		static public function toString(obj:Object,deep:String = " | "):String
		{
			var s:String = "["+ Debug.getObjectValues.apply(null,[obj,"name","visible","x","y","width","height","scaleX","scaleY","rotation"])+"]\n";
			var children:Array = obj.children;
			for each (var child:Object in children)
				s += deep + toString(child,deep + " | ") + "\n";
			
			return s;
		}
	}
}