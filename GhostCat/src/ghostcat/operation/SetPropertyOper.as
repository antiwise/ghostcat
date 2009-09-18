package ghostcat.operation
{
	/**
	 * 设置属性
	 * @author flashyiyi
	 * 
	 */
	public class SetPropertyOper extends Oper
	{
		public var client:*;
		public var property:*;
		public var value:*;
		
		public function SetPropertyOper(client:*,property:*,value:*)
		{
			super();
			
			this.client = client;
			this.property = property;
			this.value = value;
		}
		
		public override function execute() : void
		{
			super.execute();
			client[property] = value;
			
			result();
		}
	}
}