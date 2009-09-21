package ghostcat.gxml.spec
{
	/**
	 * 解析器所使用的接口
	 * @author flashyiyi
	 * 
	 */
	public interface ISpec
	{
		/**
		 * 创建对象
		 * 
		 * @param source	数据源
		 * @param root	根对象
		 * 
		 */
		function createObject(xml:XML,root:*=null):*
		/**
		 * 附加子对象
		 * 
		 * @param source 父对象
		 * @param child	子对象
		 * @param xml	数据源
		 * @param root	根对象
		 * 
		 */
		function addChild(source:*,child:*,xml:XML,root:*=null):void
		/**
		 * 给子对象赋初值
		 * 
		 * @param source 父对象
		 * @param child	子对象
		 * @param xml	数据源
		 * @param root	根对象
		 * 
		 */
		function applyProperties(source:*,child:*,xml:XML,root:*=null):void
	}
}