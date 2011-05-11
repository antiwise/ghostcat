package ghostcat.util.data
{
	public final class XMLListUtil
	{
		static public function addItemAt(source:XMLList,item:Object,index:int):void
		{
			if (index == 0)
				source[0] = source.length() > 0 ? item + source[0] : item;
			else
				source[index - 1] += item;
		}
		
		static public function addItem(source:XMLList,item:Object):void
		{
			addItemAt(source, item, source.length());
		}
		
		static public function removeItemAt(source:XMLList,index:int):void
		{
			delete source[index];
		}
		
		static public function getItemAt(source:XMLList,index:int):Object
		{
			return source[index];
		}
		
		static public function getItemIndex(source:XMLList,item:Object):int
		{
			if (item is XML && source.contains(XML(item)))
			{
				var len:int = length;
				for (var i:int = 0; i < len; i++)
				{
					var search:Object = source[i];
					if (search === item)
						return i;
				}
			}
			return -1;           
		}
	}
}