package ghostcat.algorithm.bezier
{
	import flash.geom.Point;
	
	/**
	 * 具有物理表现的平滑曲线
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class Roupe extends SmoothCurve
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
		
		private var steps:Array = [];//速度列表
		
		public function Roupe(startPoint:Point=null, endPoint:Point=null, seqNum:int=0)
		{
			super(startPoint, endPoint, seqNum);
		}
		
		public override function insert(control:Point):void
		{
			super.insert(control);
			steps.push(new Point());
		}
		
		public function applyPhysics():void
		{
			var prevPoint:Point;//上一个点
			var nextPoint:Point;//下一个点
			var curPoint:Point;//当前点
			var stepPoint:Point;//当前速度
			
			for (var i:int = 0;i < beziers.length;i++)//依次向下处理
			{
				prevPoint = (i == 0)?start:(beziers[i - 1] as Bezier).control;
				curPoint = (beziers[i] as Bezier).control;
				nextPoint = (i == beziers.length - 1)?end:(beziers[i + 1] as Bezier).control;
				stepPoint = steps[i] as Point;
				
				//数值始终尝试向两点间中值靠拢
				var targetX:Number = (prevPoint.x + nextPoint.x)/2;
				stepPoint.x += (targetX - curPoint.x) * elasticity;
				stepPoint.x += gravity.x;
				stepPoint.x *= friction;
				
				curPoint.x += stepPoint.x;
				
				var targetY:Number = (prevPoint.y + nextPoint.y)/2;
				stepPoint.y += (targetY - curPoint.y) * elasticity;
				stepPoint.y += gravity.y;
				stepPoint.y *= friction;
				
				curPoint.y += stepPoint.y;
			}
			
		}
	}
}
