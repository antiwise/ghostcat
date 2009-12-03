package ghostcat.operation.server
{
	import flash.net.NetConnection;
	
	import ghostcat.operation.Queue;

	/**
	 * 请求分组
	 * @author flashyiyi
	 * 
	 */
	public class ActionGroupOper extends RemoteOper
	{
		/**
		 * 组数据 
		 */
		public var data:Array = [];
		
		/**
		 * 当前组id 
		 */
		public var curId:int = -1;
		/**
		 * 当前组 
		 */
		public var curGroup:ActionGroup;
		
		private var commitedId:int;//请求时缓存当前curId
		
		public function ActionGroupOper(nc:NetConnection=null,metord:String=null)
		{
			super(nc,metord);
			this.maxRetry = 0;//不允许重试
			this.appendGroup();
		}
		
		/**
		 * 增加一个新组 
		 * @return 
		 * 
		 */
		public function appendGroup():ActionGroup
		{
			curId++;
			
			this.curGroup = new ActionGroup(curId);
			this.data.push(curGroup);
			return curGroup;
		}
		
		/**
		 * 在当前组内增加记录 
		 * @param v
		 * 
		 */
		public function addChild(v:*):void
		{
			curGroup.data.push(v);
		}
		
		public override function commit(queue:Queue=null) : void
		{
			if (this.queue)//若已在队列则取消
				return;
			
			super.commit(queue);
		}
		
		public override function execute() : void
		{
			commitedId = curId;//记录当前的组id
			
			this.para = [data];
			super.execute();
		
			appendGroup();//创建新组，新的记录将加在这个组内
		}
		
		public override function result(event:*=null) : void
		{
			super.result(event);
			
			//如果请求成功，销毁commitId之前的记录，通信期间增加的记录不受影响
			//不成功则不做任何事情
			if (data.length > 0 && (data[0] as ActionGroup).id <= commitedId)
				data.shift();
		}
	}
}

class ActionGroup
{
	public var id:int;
	public var data:Array;
	public function ActionGroup(id:int)
	{
		this.id = id;
		this.data = [];
	}
}