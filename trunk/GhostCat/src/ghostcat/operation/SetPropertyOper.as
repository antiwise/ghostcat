package ghostcat.operation
{
	/**
	 * 设置属性
	 * @author flashyiyi
	 * 
	 */
	public class SetPropertyOper extends Oper
	{
		/**
		 * 目标
		 */
		public var client:*;
		/**
		 * 属性
		 */
		public var property:*;
		/**
		 * 值
		 */
		public var value:*;
		
		public function SetPropertyOper(client:*=null,property:*=null,value:*=null)
		{
			super();
			
			this.client = client;
			this.property = property;
			this.value = value;
		}
		/** @inheritDoc*/
		public override function execute() : void
		{
			super.execute();
			client[property] = value;
			
			result();
		}
	}
}