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
		 * 值
		 */
		public var values:*;
		
		public function SetPropertyOper(client:*=null,values:* =null)
		{
			super();
			
			this.client = client;
			this.values = values;
		}
		/** @inheritDoc*/
		public override function execute() : void
		{
			super.execute();
			for (var p:String in values)
				client[p] = values[p];
			
			result();
		}
	}
}