package ghostcat.gxml.spec
{
	import ghostcat.util.ReflectUtil;
	import ghostcat.util.ReflectXMLUtil;

	/**
	 * 解析器基类
	 * 
	 * 和FLEX一样，包名需要用namespace定义
	 * 
	 * 这个类对子对象的处理方式是根据首字母大小来判断是增加子对象还是设置属性。
	 *
	 * 诸如：
	 * <f:Sprite xmlns:f="flash.display"><visible>false</visible></f:Sprite>
	 * 最终结果是生成一个visible=false的Sprite，下面这个也是等效的
	 * <f:Sprite xmlns:f="flash.display" visible="false"/>
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class ItemSpec implements ISpec
	{
		private var _root:*;
		public function ItemSpec(root:*=null)
		{
			this.root = root;
		}
		
		/**
		 * 基础对象，用于反射外部属性
		 */
		public function get root():*
		{
			return _root;
		}

		public function set root(v:*):void
		{
			_root = v;
		}

		/**
		 * 创建对象
		 * 
		 * @param source	数据源
		 * 
		 */
		public function createObject(xml:XML):*
		{
			var id:String;
			if (xml.hasOwnProperty("@id"))//处理id
			{
				id = xml.@id.toString();
				delete xml.@id;
			}
			
			var obj:*;
			if (xml.nodeKind()=="text")
			{
				obj = xml.toString();
			}
			else if (isClass(xml))
			{
				obj = ReflectXMLUtil.XMLToObject(xml,root);
				createChildren(obj,xml);
			}
			else
			{
				obj = [];//参数先暂存为数组
				var xmlList:XMLList = xml.children();
				for each (var child:XML in xmlList)
					(obj as Array).push(createObject(child))
			}
			
			if (root && id)
				root[id] = obj;//如果设置了ID属性，创建的对象将会创建指定的外部引用
			
			return obj;
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
					var ref:Class = ReflectUtil.getTypeByProperty(source,name)
					if (ref == Array)//在这里判断是否真的是数组，不是仍然直接赋值
						source[name] = child;
					else
						ReflectXMLUtil.setProperty(source,name,child[0]);
				}
				else
					ReflectXMLUtil.setProperty(source,name,child);
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
			var name:String = xml.localName().toString();
			var firstCode:String = name.charAt(0);
			return firstCode > "A" && firstCode < "Z";
		}
	}
}