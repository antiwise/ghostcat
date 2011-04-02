package ghostcat.gxml.conversion
{
	import ghostcat.util.ReflectXMLUtil;
	import ghostcat.gxml.spec.ISpec;

	/**
	 * XML转换为Object的转换器，用于输出JSON对象，不进行反射
	 * @author flashyiyi
	 * 
	 */
	public class XMLToObjectSpec implements ISpec
	{
		/**
		 * 是否允许用逗号分隔Text成为数组
		 */
		public var enabledDotSplit:Boolean = true;
		
		/**
		 * XML名称转换成的属性
		 */
		public var classRefName:String = "classRef";
		
		/**
		 * 创建对象以及值（值一般都被统一为数组类型）
		 * 
		 * @param source	数据源
		 * 
		 */
		public function createObject(xml:XML):*
		{
			var obj:*;
			if (xml.nodeKind()=="text")//是普通文本
			{
				var str:String = xml.toString();
				if (str.length >= 2 && str.charAt(0) == '"' && str.charAt(str.length - 1) == '"')//加双引号解除转义
					obj = [str.slice(1,str.length - 1)];
				else if (enabledDotSplit)
					obj = str.split(",");
				else
					obj = [str];
				
				for (var i:int = 0;i < obj.length;i++)
				{
					if (obj[i]=="null")
						obj[i] = null;
				}
				if (obj.length == 1)
					obj = obj[0];
			}
			else if (isClass(xml))//是类
			{
				obj = {};
				
				if (classRefName)
					obj[classRefName] = xml.name().toString();
				
				var source:XMLList = xml.attributes();
				for (i = 0; i < source.length(); i++)
					obj[source[i].name().toString()] = source[i].toString();
				
				createChildren(obj,xml);//创建类的子对象
			}
			else//是属性
			{
				obj = getPropertyValue(xml);
			}
			
			return obj;
		}
		
		/**
		 * 返回XML代表的属性的值（由于不清楚属性的类型，即使只有一个属性也会被当做数组，并在之后处理）
		 * @return 
		 * 
		 */
		protected function getPropertyValue(xml:XML):Array
		{
			var obj:Array = [];//值先暂存为数组
			var xmlList:XMLList = xml.children();
			for each (var item:XML in xmlList)
			{
				var v:* = createObject(item);
				if (v is Array)
					obj = obj.concat(v);
				else
					obj.push(v)
			}
			return obj
		}
		
		/**
		 * 附加子对象
		 * 
		 * @param source 父对象
		 * @param child	子对象
		 * 
		 */
		public function addChild(source:*,child:*,xml:XML):void
		{
			var name:String = xml.localName().toString();
			if (!isClass(xml))
			{
				if (child is Array)
				{	
					//只有大于两个元素的才会被认为是数组
					if (child.length > 1)//在这里判断是否真的是数组，不是则取第一个元素用原来的处理方式
						source[name] = child;
					else if (child.length > 0)
						source[name] = child[0];
				}
				else
					source[name] = child;
			}
		}
		
		/**
		 * 给子对象赋初值
		 * 
		 * @param source 父对象
		 * @param child	子对象
		 * 
		 */
		public function applyProperties(source:*,child:*,xml:XML):void
		{
			//需要从父对象传值给子对象可重写此方法
		}
		
		/**
		 * 创建全部子对象
		 * 
		 * @param source
		 * 
		 */
		protected function createChildren(source:*,xml:XML):void
		{
			for each (var item:XML in xml.children())
			{
				var v:* = createObject(item);
				applyProperties(source,v,xml);
				addChild(source,v,item);
			}
		}
		
		/**
		 * 判断是否是类
		 * 
		 * @param xml
		 * @return 
		 * 
		 */
		protected function isClass(xml:XML):Boolean
		{
			if (xml.nodeKind()=="text")
				return false;
			
			var name:String = xml.localName();
			if (name)
			{
				var firstCode:String = name.charAt(0);
				return firstCode >= "A" && firstCode <= "Z";
			}
			else
			{
				return false;
			}
		}
		
		public function get root():*
		{
			return null;
		}
		
		public function set root(v:*):void
		{
			
		}
	}
}