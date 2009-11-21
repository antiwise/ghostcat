package ghostcat.algorithm.traversal
{
	

	/**
	 * 地图模型类接口
	 * 
	 * @author flashyiyi
	 * 
	 */
	public interface IMapModel
	{
		/**
		 * 地图数据
		 * @return 
		 * 
		 */
		function get map():Array;
		function set map(v:Array):void;
		/**
		 * 初始化
		 * 
		 */
		function reset():void
		
		/**
		 * 保存Node
		 * 
		 * @param v	键
		 * @param node
		 * 
		 */
		function setNode(v:*,node:TraversalNote):void
		
		/**
		 * 取出Node
		 * 
		 * @param v	键
		 * @return 
		 * 
		 */
		function getNode(v:*):TraversalNote
		
		/**
		 * 提供可遍历的节点
		 * 
		 * 这里提供的是八方向移动
		 * 
		 * @param p	当前节点
		 * @return 
		 * 
		 */
		function getArounds(p:*) : Array;
		
		/**
		 * 判断是否结束
		 * 
		 * @param cur	当前节点
		 * @param end	终点
		 * @return 	是否相同的布尔值
		 * 
		 */
		function reachEnd(cur:*,end:*):Boolean;
		
		/**
		 * 获得Cost对于父节点Cost的加值
		 * 
		 * @param start	首节点
		 * @param cur	父节点
		 * @param next	当前节点
		 * @param end	终点
		 * @return 
		 * 
		 */
		function getCostAddon(start:*,cur:*,next:*,end:*):int
		 
		/**
		 * 获得Score对于Cost的加值
		 *  
		 * @param start	首节点
		 * @param cur	父节点
		 * @param next	当前节点
		 * @param end	终点
		 * @return 
		 * 
		 */
		function getScoreAddon(start:*,cur:*,next:*,end:*):int
		
	}
}