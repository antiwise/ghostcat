package ghostcat.gxml.spec
{
	/**
	 * 解析器基类，无逻辑
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class ItemSpec implements ISpec
	{
		public function ItemSpec()
		{
		}
		
		/**
		 * @inheritDoc
		 */
		public function createObject(xml:XML,root:*=null):*
		{
			
		}
		
		/**
		 * @inheritDoc
		 */
		public function addChild(source:*,child:*,xml:XML,root:*=null):void
		{
			
		}
		
		/**
		 * @inheritDoc
		 */
		public function applyProperties(source:*,child:*,xml:XML,root:*=null):void
		{
			
		}
		
		/////////////////////////////
		//提供一些默认方法
		/////////////////////////////
		
		/**
		 * 创建全部子对象
		 * @param source
		 * 
		 */
		public function createChildren(source:*,xml:XML,root:*=null):void
		{
			for each (var item:XML in xml.children())
			{
				var v:* = createObject(item,root);
				applyProperties(source,v,xml,root);
				addChild(source,v,item,root);
			}
		}
	}
}