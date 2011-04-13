package ghostcat.algorithm.traversal
{
	import flash.geom.Point;
	import flash.net.NetConnection;
	import flash.net.registerClassAlias;

	/**
	 * 在目标点不可走时，测试相近的点是否可走
	 * @author flashyiyi
	 * 
	 */
	public final class FindNearPoint
	{
		/**
		 * 
		 * @param isBlock	是否可走的判断函数，参数为Point类型的坐标
		 * @param oldPosition	旧坐标
		 * @param curPosition	新坐标
		 * @return 返回可走的点，返回空则不可走。
		 * 
		 */
		static public function find(isBlock:Function,oldPosition:Point,curPosition:Point):Point
		{
			if (!isBlock(curPosition))
				return curPosition.clone();
			
			var d:Point = curPosition.subtract(oldPosition);
			var k:Number = Math.atan2(d.y, d.x);
			const dks:Array = [-0.25,0.25,-0.5,0.5];
			for each (var dk:Number in dks)
			{
				var newPosition:Point = oldPosition.add(Point.polar(d.length,k + Math.PI * dk));
				if (!isBlock(newPosition))
					return newPosition;
			}
			
			return null;
		}
	}
}