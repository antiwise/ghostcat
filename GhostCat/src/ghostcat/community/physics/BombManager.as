package ghostcat.community.physics
{
	import flash.geom.Point;

	/**
	 * 爆炸物理管理器
	 * @author flashyiyi
	 * 
	 */
	public class BombManager extends PhysicsManager
	{
		public function BombManager(command:Function=null)
		{
			super(command);
		}
		
		/**
		 * 开始爆炸 
		 * @param p	起爆点
		 * @param power
		 * 
		 */
		public function bomb(p:Point,power:Number = 5,spin:Number = 10):void
		{
			for each (var item:PhysicsItem in this.data)
			{
				var offest:Point = new Point(item.x,item.y).subtract(p);
				
				item.velocity = new Point(power * offest.x,power * offest.y);
				item.spin = (Math.random() - 0.5) * spin * 2;
				item.scaleSpeed = Math.pow(0.5, offest.length / 50) / 50;
				
				item.friction = 0.95;
				item.spinFriction = 0.99;
				
			}
		}
	}
}