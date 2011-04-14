package ghostcat.algorithm.traversal
{
	/**
	 * 遍历节点类 
	 * @author flashyiyi
	 * 
	 */
	public class TraversalNote
	{
		public var noteOpen : Boolean = true;//是否在开放列表
		public var noteClosed : Boolean = false;//是否在关闭列表
		public var cost:Number;//距离消耗
		public var score:Number;//节点得分
		public var parent:TraversalNote;//父节点
		public var point:*;//坐标
	}
}