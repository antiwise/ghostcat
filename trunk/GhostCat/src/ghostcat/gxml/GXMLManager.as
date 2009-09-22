package ghostcat.gxml
{
	import ghostcat.gxml.spec.ISpec;
	import ghostcat.util.Singleton;

	/**
	 * XML解析类
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class GXMLManager extends Singleton
	{
		static public function get instance():GXMLManager
		{
			return Singleton.getInstanceOrCreate(GXMLManager) as GXMLManager;
		}
		
		/**
		 * 根据XML创建对象
		 * 
		 * @param xml	XML数据
		 * @param spec	解析器类型
		 * @param root	初始对象
		 * @return 
		 * 
		 */
		public function create(xml:XML,spec:ISpec):*
		{
			return spec.createObject(xml);
		}
	}
}