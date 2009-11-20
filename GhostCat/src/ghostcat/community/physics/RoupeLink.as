package ghostcat.community.physics
{
	import flash.geom.Point;
	
	import ghostcat.display.transfer.effect.BombHandler;
	
	/**
	 * 弹性绳物理
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class RoupeLink extends PhysicsManager
	{
		/**
		 * 吸引系数
		 */
		public var elasticity:Number;
		
		/**
		 * 衰减系数
		 */
		public var friction:Number;
		
		/**
		 * 是否计算尾节点
		 */
		public var hasEnd:Boolean;
		
		public function RoupeLink(elasticity:Number = 0.3,friction:Number = 0.85,gravity:Point = null,hasEnd:Boolean = false)
		{
			this.elasticity = elasticity;
			this.friction = friction;
			
			if (!gravity)
				gravity = new Point(0,0.98);
			this.gravity = gravity;
			this.hasEnd = hasEnd;
		}
		
		public override function tick(interval:int):void
		{
			var prevPoint:*;//上一个点
			var nextPoint:*;//下一个点
			var curPoint:*;//当前点
			var speed:Point;//当前速度
			
			var len:int = hasEnd ? data.length : data.length - 1;
			for (var i:int = 1;i < len;i++)//依次向下处理
			{
				var item:PhysicsItem = data[i] as PhysicsItem;
				prevPoint = (data[i - 1] as PhysicsItem).target;
				curPoint = item.target;
				nextPoint = (i < data.length - 1) ? (data[i + 1] as PhysicsItem).target : null;
				speed = (data[i] as PhysicsItem).velocity;
				
				//数值始终尝试向两点间中值靠拢，尾部则靠向上一个点
				var targetX:Number;
				var targetY:Number;
				if (nextPoint)
				{
					targetX = (prevPoint.x + nextPoint.x)/2;//取中值为目标
					targetY = (prevPoint.y + nextPoint.y)/2;
				}
				else
				{
					targetX = prevPoint.x;//取上一个值为目标
					targetY = prevPoint.y;
				}
				speed.x += (targetX - curPoint.x) * elasticity;//以于目标的距离乘以引力系数，模拟引力
				speed.y += (targetY - curPoint.y) * elasticity;
				speed.x += gravity.x;//附加重力矢量
				speed.y += gravity.y;
				speed.x *= friction;//速度比例衰减
				speed.y *= friction;
				
				item.x += item.velocity.x;
				item.y += item.velocity.y;
			}
		}
	}
}
