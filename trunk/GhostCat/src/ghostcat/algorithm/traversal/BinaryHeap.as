package ghostcat.algorithm.traversal
{
	/**
	 * 二叉堆算法
	 * 
	 * 能够在不断追加数据的同时，随时取出数列中的最小值
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class BinaryHeap
	{
		private var data:Array ;//需要注意的是，二叉堆数据的下标是从1开始排列的
		
		/**
		 * 排序函数
		 */
		public var sortMetord:Function = defaultSortMetord;
		
		public function BinaryHeap()
		{
			clear();
		}
		
		/**
		 * 数据长度
		 *  
		 * @return 
		 * 
		 */
		public function get length():int
		{
			return data.length - 1;
		}
		
		/**
		 * 添加节点
		 * @param o
		 * 
		 */
		public function push(o:*):void
		{
			var s:int = data.push(o) - 1;//s 当前节点
			modifyIndex(s);
		}
		
		/**
		 * 修改节点后重排顺序 
		 * @param o
		 * 
		 */
		public function modify(o:*):void
		{
			var index:int = data.indexOf(o);
			if (index > 0)
				modifyIndex(index);
		}
		
		private function modifyIndex(index:int):void
		{
			var s:int = index;//s 当前节点
			while (s > 1)
			{
				var p:int = int(s / 2);//p 父节点
				if (sortMetord(data[s],data[p]))
				{
					var t:* = data[s];
					data[s] = data[p];
					data[p] = t;
				}
				else
					break;
					
				s = p;
			} 
		}
		
		/**
		 * 从数组中取出首节点（最小值）
		 * @param index
		 * 
		 */		
		public function shift():*
		{
			if (data.length == 1)//数组为空
				return null;
			
			if (data.length == 2)//数组只有一个节点
				return data.pop();
			
			var v:* = data[1];
			var s:int = 1;//s 当前节点
			
			data[1] = data.pop();//将末节点移动到队首
			
			while (true)
			{
				var os:int = s;//os s的旧值
				var p:int = s * 2;//p 子节点
				if (p < data.length)
				{
					if (sortMetord(data[p],data[s]))
						s = p;
					
					//如果另一个子节点更小
					if (p + 1 < data.length && sortMetord(data[p + 1],data[s]))
						s = p + 1;
				}
				
				if (s != os)
				{
					var t:* = data[s];
					data[s] = data[os];
					data[os] = t;
				}	
				else
					break;
			} 
			return v;
		}
		
		/**
		 * 清空 
		 * 
		 */
		public function clear():void
		{
			data = [null];
		}
		
		/**
		 * 默认排序函数
		 *  
		 * @param obj1
		 * @param obj2
		 * @return 
		 * 
		 */
		public static function defaultSortMetord(obj1:*,obj2:*):Boolean
		{
			return obj1 < obj2; 
		}
		
	}
}