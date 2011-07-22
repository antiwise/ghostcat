package ghostcat.gxml.jsonspec
{
	import flash.utils.getQualifiedClassName;
	
	import ghostcat.gxml.spec.ItemGroup;
	
	/**
	 * 解析数据组
	 * 
	 * 需要用classNames属性重定义items,item代表的类，其中items应当是ItemGroup或者继承于ItemGroup的对象，而item则对应相应的数据类，应当有一个id属性
	 * 例如：classNames = {items:ItemGroup,item:PropItem};
	 * 
	 * createObject方法将返回一个ItemGroup对象容纳以id为标示的数据组
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class JSONItemGroupSpec extends JSONItemSpec
	{
		public function JSONItemGroupSpec()
		{
			super();
		}
		
		/** @inheritDoc */
		public override function addChild(source:*,child:*,name:*):void
		{
			if (source is ItemGroup)
				(source as ItemGroup).add(child);
			else
				super.addChild(source,child,name);
		}
		
		/**
		 * 创建ItemGroup
		 *  
		 * @param source
		 * @param type
		 * @return 
		 * 
		 */
		public function createItemGroup(source:Array,type:Class):*
		{
			var group:ItemGroup = new ItemGroup();
			var typeName:String = getQualifiedClassName(type);
			for each (var v:Object in source)
			{
				v[classRefName] = typeName;
				group.add(createObject(v));
			}
			return group;
		}
	}
}