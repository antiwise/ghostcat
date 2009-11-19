package ghostcat.algorithm.bezier
{
	import flash.geom.Point;
	
	/**
	 * 弹性绳物理
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class RoupeLink
	{
		/**
		 * 牵引加速度
		 */
		public var gravity:Point = new Point(0,0.98);
		
		/**
		 * 吸引系数
		 */
		public var elasticity:Number = 0.3;
		
		/**
		 * 衰减系数
		 */
		public var friction:Number = 0.85;
		
		/**
		 * 路径 
		 */
		public var path:Array;
		
		private var speeds:Array;//速度列表
		
		public function RoupeLink(path:Array)
		{
			this.path = path;
			refresh();
		}
		
		public function refresh():void
		{
			speeds = [];
			for (var i:int = 0;i < path.length;i++)
				speeds.push(new Point());
		}
		
		public function applyPhysics():void
		{
			var prevPoint:Point;//上一个点
			var nextPoint:Point;//下一个点
			var curPoint:Point;//当前点
			var speed:Point;//当前速度
			
			for (var i:int = 1;i < path.length - 1;i++)//依次向下处理
			{
				prevPoint = path[i - 1];
				curPoint = path[i];
				nextPoint = path[i + 1]
				speed = speeds[i - 1] as Point;
				
				//数值始终尝试向两点间中值靠拢
				var targetX:Number = (prevPoint.x + nextPoint.x)/2;//取中值为目标
				speed.x += (targetX - curPoint.x) * elasticity;//以于目标的距离乘以引力系数，模拟引力
				speed.x += gravity.x;//附加重力矢量
				speed.x *= friction;//速度比例衰减
				
				var targetY:Number = (prevPoint.y + nextPoint.y)/2;
				speed.y += (targetY - curPoint.y) * elasticity;
				speed.y += gravity.y;
				speed.y *= friction;
				
				curPoint.x += speed.x;
				curPoint.y += speed.y;
			}
			
		}
	}
}
