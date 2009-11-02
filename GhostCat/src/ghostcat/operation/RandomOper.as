package ghostcat.operation
{
	import ghostcat.events.OperationEvent;
	import ghostcat.util.RandomUtil;
	
	/**
	 * 随机分支
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class RandomOper extends Oper
	{
		/**
		 * 分支列表，元素为二维数组，第一项为值，第二项为需要执行的Oper
		 */
		public var list:Array;
		
		private var choose:Oper;
		
		public function RandomOper(list:Array=null)
		{
			super();
			this.list = list;
		}
		/** @inheritDoc*/
		public override function execute():void
		{
			super.execute();
			
			if (!list || list.length == 0)
			{
				fault();
				return;
			}
			
			choose = list[int(Math.random() * list.length)];
				
			choose.addEventListener(OperationEvent.OPERATION_COMPLETE,result);
			choose.addEventListener(OperationEvent.OPERATION_ERROR,fault);
			choose.execute();
		}
		/** @inheritDoc*/
		protected override function end(event:*=null):void
		{
			super.end(event);
			
			choose.removeEventListener(OperationEvent.OPERATION_COMPLETE,result);
			choose.removeEventListener(OperationEvent.OPERATION_ERROR,fault);
		}
	}
}