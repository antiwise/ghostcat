package ghostcat.game.util
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;

	/**
	 * 景深排序类
	 * @author flashyiyi
	 * 
	 */
	public final class DepthSortUtil
	{
		static public function sortAll(children:Array,container:DisplayObjectContainer,sortFields:* = null):void
		{
			if (sortFields == null)
				sortFields = "y";
			
			if (sortFields is String)
				sortFields = [sortFields];
			
			var result:Array;
			if (sortFields is Array) 
				result = children.sortOn(sortFields,Array.NUMERIC|Array.RETURNINDEXEDARRAY);
			else if (sortFields is Function)
				result = children.sort(sortFields,Array.NUMERIC|Array.RETURNINDEXEDARRAY);
			else
				return;
			
			for (var i:int = 0; i < result.length; i++)
			{
				var v:DisplayObject = children[result[i]] as DisplayObject;
				if (v.parent == container && container.getChildIndex(v) != i)
					container.setChildIndex(v,i);
			}
		}
		
		static public function sort(child:DisplayObject,container:DisplayObjectContainer,sortFields:* = null):void
		{
			if (sortFields == null)
				sortFields = "y";
			
			var l:int = container.numChildren;
			for (var i:int = 0; i < l; i++)
			{
				var v:DisplayObject = container.getChildAt(0);
				if (v.parent == container && container.getChildIndex(v) != i)
				{
					var bo:Boolean;
					if (sortFields is String)
					{
						bo = child[sortFields] < v[sortFields];
					}
					else if (sortFields is Function)
					{
						bo = sortFields(child,v) == -1;
					}
					else if (sortFields is Array) 
					{
						for (var j:int = 0;j < sortFields.length;j++)
						{
							var p:String = sortFields[j];
							if (child[p] != v[p])
							{
								bo = child[p] < v[p];
								break;
							}
						}
						bo = false;
					}
					
					if (bo)
					{
						container.setChildIndex(child,i);
						break;
					}
				}
			}
			
			if (container.getChildIndex(v) != l - 1)
				container.addChild(child);
		}
	}
}