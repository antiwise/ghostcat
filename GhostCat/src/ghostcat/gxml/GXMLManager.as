package ghostcat.gxml
{
	import ghostcat.gxml.spec.DisplaySpec;
	import ghostcat.gxml.spec.ISpec;
	import ghostcat.gxml.spec.ItemGroupSpec;
	import ghostcat.gxml.spec.ItemSpec;
	import ghostcat.util.core.Singleton;

	/**
	 * XML解析类
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class GXMLManager
	{
		/**
		 * 根据XML创建对象
		 * 
		 * @param xml	XML数据
		 * @param spec	解析器类型
		 * @param root	初始对象
		 * @return 
		 * 
		 */
		public static function create(xml:XML,spec:ISpec):*
		{
			return spec.createObject(xml);
		}
		
		/**
		 * 创建显示对象
		 * 
		 * @param xml	XML数据
		 * @param classNames	类名替换
		 * @param root	初始对象
		 * @param spec	解析器类型
		 * @return 
		 * 
		 */
		public static  function createDisplayObject(xml:XML,classNames:Object = null,root:* = null,spec:ItemSpec = null):*
		{
			if (!spec)
				spec = new DisplaySpec(root);
			
			if (classNames)
				spec.classNames = classNames;
			
			return spec.createObject(xml);
		}
		
		/**
		 * 创建数据组
		 * 
		 * @param xml	XML数据
		 * @param classNames	类名替换（应当将根节点替换成ItemGroup类型的对象，而子节点的类型应当具有id属性）
		 * @param spec	解析器类型
		 * @return 
		 * 
		 */
		public static function createItemGroup(xml:XML,classNames:Object = null,spec:ItemSpec = null):*
		{
			if (!spec)
				spec = new ItemGroupSpec();
			
			if (classNames)
				spec.classNames = classNames;
			
			return spec.createObject(xml);
		}
		
		/**
		 * 解析XMLList并执行一组XML定义
		 * 需要通过root和对象的id属性和外部对应
		 * 
		 * @param xml
		 * 
		 */
		public static  function exec(xmlList:XMLList,spec:ISpec):void
		{
			for each (var item:XML in xmlList)
				spec.createObject(item);
		}
	}
}