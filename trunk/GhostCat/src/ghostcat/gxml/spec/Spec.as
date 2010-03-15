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
	 * 构造函数参数可以当做constructor属性来定义
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class Spec implements ISpec
	{
		private var _root:*;
		public function Spec(root:*=null)
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
				obj = xml.toString().split(/[,|\s]+/);
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
				var params:Array = getConstructorParams(xml);//获得构造函数参数
				obj = ReflectXMLUtil.XMLToObject(xml,root,params);//创建
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
		 * 获得构造函数参数
		 * @return 
		 * 
		 */
		protected function getConstructorParams(xml:XML):Array
		{
			var obj:Array;
			
			var c:XMLList = xml.constructor;
			if (c.length()>0)
			{
				obj = getPropertyValue(c[0])
				delete xml.constructor[0];
			}
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
					if (ref == Array)//在这里判断是否真的是数组，不是则取第一个元素用原来的处理方式
						source[name] = child;
					else if (child.length > 0)
						ReflectXMLUtil.setProperty(source,name,child[0],root);
				}
				else
					ReflectXMLUtil.setProperty(source,name,child,root);
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
		 * 从父对象从继承缺少的属性（用于applyProperties方法） 
		 * 
		 */
		protected function extendsProperties(fields:Array,source:*,child:*,overwrite:Boolean = false):void
		{
			for (var i:int = 0;i < fields.length;i++)
			{
				var field:String = fields[i];
				if (source.hasOwnProperty(field) && child.hasOwnProperty(field) && (overwrite || child[field] == null || isNaN(child[field])))
					child[field] = source[field];
			}
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
	}
}